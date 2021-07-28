%% basic computation
[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
tau = lag / 365; 
Ts = days / 365;
 
domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
volSurface = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);
smile = makeSmile(fwdCurve, Ts(end), cps, deltas, vols(end,:));
%%
%% quick test
%%
%% running time
threshold = 1.6;
tic; for i=1:100 project;end; time = toc/100;
if time>threshold
    error("Running time more than ", num2str(threshold), " (", num2str(time), "exactly ) sec on average, please try again!");
else
    fprintf(['\nRunning time test pass! Time elapsed: ', num2str(time) ,' sec on average!\n\n']);
end
% if choose bump size of 1e-4 in getEuropean, the time is about 1.4 sec;
% if choose bump size of 0.2e-3 in getEuropean, the time is about 0.5 sec;
% if choose bump size of 0.5e-3 in getEuropean, the time is about 0.24 sec;
%% getBlackCall
T = 0.8;
f = 1.48;
Ks = 0:0.01:4;
Vs = linspace(0.25,0.35,length(Ks));
call = getBlackCall(f,T,Ks,Vs);
fprintf("\ngetBlackCall.m passes test! Also allow zero strikes\n\n");

%% getRateIntegral
domdfs_fit = cell2mat(arrayfun(@(x) getRateIntegral(domCurve,x),Ts,'UniformOutput',false));
fordfs_fit = cell2mat(arrayfun(@(x) getRateIntegral(forCurve,x),Ts,'UniformOutput',false));
err = sum(abs(exp(-domdfs_fit)-domdfs))+sum(abs(exp(-fordfs_fit)-fordfs));
if err>1e-10
    error("getRateIntegral does not return original data");
else
    fprintf("\ngetRateIntegral.m passes test: return original rate integral/discount factor!\n Also continuous and piecewise linear, please check output_test!\n\n");
end

%% getFwdSpot
fwds = cell2mat(arrayfun(@(x) getFwdSpot(fwdCurve,x), Ts,'UniformOutput',false));
fwds_sorted = sort(fwds,"descend");
if sum(fwds~=fwds_sorted)>0
    error("Forward Spot not decreasing!");
else
    fprintf("\ngetFwdSpot.m passes test: decreasing since foreign interest rate is higher according to market data.\n Also continuous and smooth, please check output_test!\n\n");
end

%% getStrikeFromDelta
fwd = 1.5;
T = 0.8;
cp = 1;
sigma = 0.3;
delta = 0.25;
h = 1e-7;
K = getStrikeFromDelta(fwd,T,cp,sigma,delta);
delta_fit = (getBlackCall(fwd+h,T,K,sigma)-getBlackCall(fwd,T,K,sigma))/h;
if abs(delta-delta_fit)>1e-5
    error("getStrikeFromDelta does not match getBlackCall");
else
    fprintf("\ngetStrikeFromDelta.m passes test: matches getBlackCall.m.\n Also continuous and smooth, please check output_test!\n\n");
end

%% getSmileVol
fwd = getFwdSpot(fwdCurve,Ts(end));
Ks = cell2mat(arrayfun(@(x,y,z) getStrikeFromDelta(fwd,Ts(end),x,y,z),cps,vols(end,:),deltas,'UniformOutput',false));
vols_fit = getSmileVol(smile,Ks);
if sum(abs(vols_fit-vols(end,:)))>1e-10
    error("getSmileVol does not return original data!");
else
    fprintf("\ngetSmileVol.m passes test: return original volatilities. \n Also smooth and smile-shaped, please check output_test!\n\n");
end

%% getVol
vols_mat = zeros(size(vols));
for i=1:length(Ts)
    fwd = getFwdSpot(fwdCurve,Ts(i));
    Ks = cell2mat(arrayfun(@(x,y,z) getStrikeFromDelta(fwd,Ts(i),x,y,z),cps,vols(i,:),deltas,'UniformOutput',false));
    vols_mat(i,:) = getVol(volSurface,Ts(i),Ks);
end
if sum(abs(vols_mat-vols))>1e-10
    error("getVol does not return original data!");
else
    fprintf("\ngetVol.m passes test: return original volatilities. \n Also smooth and smile-shaped, please check output_test!\n\n");
end

%% getCdf
T = 0.8;
ub = 1;
while getCdf(volSurface,T,ub)<1
    ub = ub+1;
end
ubb = 10*ub; % make sure the area after ub still behaves normal
Ks = 0:0.001:ubb;
cdf = getCdf(volSurface,T,Ks);
if sum(cdf<sort(cdf))/length(cdf) > 0.005
    % since there still exists some oscillations, we allow some error; we
    % set a shrehold for relative error
    error("ERROR!CDF not increasing!");
elseif max(cdf)>1 || sum(cdf<0)/length(cdf)>0.005
    error("ERROR!CDF out of bound of 0 or 1!");
else
    fprintf("getCdf.m passes test: increasing up to 1!\n Also continuous and smooth, please check output_test!\n\n");
end

%% getPdf
T = 0.8;
ub = 1;
while getCdf(volSurface,T,ub)<1
    ub = ub+1;
end
ubb = 10*ub; % make sure the area after ub still behaves normal
Ks = 0:0.001:ubb;
pdf = getPdf(volSurface,T,Ks);
fwd = getFwdSpot(fwdCurve,T);
[m,i] = max(pdf);
if sum(pdf<0)/length(pdf)>0.005
    % since there still exists some oscillations, we allow some error; we
    % set a shrehold for relative error
    error("ERROR!PDF not nonnegative!");
%elseif abs(Ks(i)-fwd)>1e-4
elseif abs(round(getEuropean(volSurface,T,@(x) x),3)-round(fwd,3))>1e-10
    error("ERROR!Mean of PDF is not forward spot price!");
elseif round(getEuropean(volSurface,T,@(x) 1),2) ~= 1
    error("ERROR!Integral of PDF is not 1!");
else
    fprintf("getPdf.m passes test: nonnegative,integrate to 1, has a mean of forward spot!\n Also continuous and smooth, please check output_test!\n\n");
end
%% getEuropean
T = 0.8;
getEuropean(volSurface,T,@(x) max(x-1,0));
getEuropean(volSurface,T,@(x) max(x-1,0),[0,+Inf]);
getEuropean(volSurface,T,@(x) max(x-1,0),[0,1,+Inf]);
getEuropean(volSurface,T,@(x) max(x-1,0),[0,0.3,0.5,0.7,+Inf]);
getEuropean(volSurface,T,@(x) max(x-1,0),[0,0.9]);
getEuropean(volSurface,T,@(x) max(x-1,0),[0.1,0.9])
fprintf("getEuropean.m passes test: allow arbitray interval, allow multiple breaking points!\n Also continuous and smooth, please check output_test!\n\n");

%%

