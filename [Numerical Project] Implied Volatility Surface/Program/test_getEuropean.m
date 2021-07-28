%% Notice
% Though we have tested for a wide range of inputs for the function, we
% don't write like that here because that will cause this test file running
% too slow; reader who is interested can modify the parameters here
% we used.
%% basic computation
[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
tau = lag / 365; 
Ts = days / 365;
 
domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
volSurface = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);
smile = makeSmile(fwdCurve, Ts(end), cps, deltas, vols(end,:));

%% test getEuropean 1 - multiple discontinuities
Ts = 0:0.1:2;
arrayfun(@(y) getEuropean(volSurface,y,@(x) max(x-1,0)),Ts,'UniformOutput',false);
arrayfun(@(y) getEuropean(volSurface,y,@(x) max(x-1,0),[0,+Inf]),Ts,'UniformOutput',false);
arrayfun(@(y) getEuropean(volSurface,y,@(x) max(x-1,0),[0,1,+Inf]),Ts,'UniformOutput',false);
arrayfun(@(y) getEuropean(volSurface,y,@(x) max(x-1,0),[0,0.3,0.5,0.7,+Inf]),Ts,'UniformOutput',false);
arrayfun(@(y) getEuropean(volSurface,y,@(x) max(x-1,0),[0,0.9]),Ts,'UniformOutput',false);
arrayfun(@(y) getEuropean(volSurface,y,@(x) max(x-1,0),[0.1,0.9]),Ts,'UniformOutput',false);
fprintf("getEuropean.m passes test: allow arbitray interval, allow multiple breaking points!\n Also continuous and smooth, please check output_test!\n\n");

%% test getEuropean 2-1 - put-call parity
K = 1;
T = 0.8;
call = getEuropean(volSurface,T,@(x) max(x-1,0));
put = getEuropean(volSurface,T,@(x) max(1-x,0));
I1 = call - put;
I2 = getFwdSpot(fwdCurve,T) - K;
if abs(I1-I2) > 1e-4
    disp("Put-call parity not satisfied!");
else
    disp("Put-call parity satisfied!");
end

%% test getEuropean 2-2 - put-call parity under degenerate volatility surface
vols_d = 0.3*ones(size(vols));
volSurface_d = makeVolSurface(fwdCurve, Ts, cps, deltas, vols_d);
K = 1;
T = 0.8;
call = getEuropean(volSurface_d,T,@(x) max(x-1,0));
put = getEuropean(volSurface_d,T,@(x) max(1-x,0));
I1 = call - put;
I2 = getFwdSpot(fwdCurve,T) - K;
if abs(I1-I2) > 1e-4
    disp("Put-call parity not satisfied!");
else
    disp("Put-call parity satisfied!");
end

%% test getEuropean 3-1 - match getBlackCall
K = 1;
T = 0.8;
European = getEuropean(volSurface,T,@(x) max(x-K,0));
fwd = getFwdSpot(fwdCurve,T);
vol = getVol(volSurface,0.8,fwd);
vol = vol*ones(size(K));
Black = getBlackCall(fwd,0.8,K,vol);
if abs(European-Black) > 1e-2
    disp("Not match getBlackCall!");
else
    disp("Match getBlackCall!");
end

%% test getEuropean 3-2 - match getBlackCall under degenerate volatility surface
vols_d = 0.3*ones(size(vols));
volSurface_d = makeVolSurface(fwdCurve, Ts, cps, deltas, vols_d);
K = 1;
T = 0.8;
European = getEuropean(volSurface_d,T,@(x) max(x-K,0));
fwd = getFwdSpot(fwdCurve,T);
vol = getVol(volSurface_d,0.8,fwd);
vol = vol*ones(size(K));
Black = getBlackCall(fwd,0.8,K,vol);
if abs(European-Black) > 1e-4
    disp("Not match getBlackCall under degenerate vol!");
else
    disp("Match getBlackCall under degenerate vol!");
end

%% test getEuropean 4-1 - nonvanilla option (binary option)
B1 = 1.5;
B2 = 1;
K = 1.4;
T = 0.8;
payoff = @(x) B1*(x>K)+B2*(x<=K);
num_pre = getEuropean(volSurface, T, payoff);
% we know how to value a binary option
vol = getVol(volSurface,T,K);
fwd = getFwdSpot(fwdCurve,T);
d2 = log(fwd/K)/vol/sqrt(T) - 0.5*vol*sqrt(T);
ana_pre = B1*normcdf(d2)+B2*normcdf(-d2);
if abs(num_pre-ana_pre) > 1e-2
    disp("Binary option numerical value does not match analytical value!");
else
    disp("Binary option numerical value matches analytical value!");
end

%% test getEuropean 4-2 - nonvanilla option (binary option) under degenerate volatility surface
vols_d = 0.3*ones(size(vols));
volSurface_d = makeVolSurface(fwdCurve, Ts, cps, deltas, vols_d);
smile_d = makeSmile(fwdCurve, Ts(end), cps, deltas, vols_d(end,:));
B1 = 1.5;
B2 = 1;
K = 1.4;
T = 0.8;
payoff = @(x) B1*(x>K)+B2*(x<=K);
num_pre = getEuropean(volSurface_d, T, payoff);
% we know how to value a binary option
vol = getVol(volSurface_d,T,K);
fwd = getFwdSpot(fwdCurve,T);
d2 = log(fwd/K)/vol/sqrt(T) - 0.5*vol*sqrt(T);
ana_pre = B1*normcdf(d2)+B2*normcdf(-d2);
if abs(num_pre-ana_pre) > 1e-4
    disp("Binary option cannot be approximated under degenerated volatility surface!");
else
    disp("Binary option can be approximated under degenerated volatility surface!");
end

%% test getEuropean 5 - nonvanilla option represented by vanilla
K = 1.4; T = 0.8;
nonvan_pay = @(x) max(x-K,K-x);
% an option that allows holder to choose between call and put
vancall_pay = @(x) max(x-K,0);
vanput_pay = @(x) max(K-x,0);
nonvan_pre = getEuropean(volSurface, T, nonvan_pay);
vancall_pre = getEuropean(volSurface, T, vancall_pay);
vanput_pre = getEuropean(volSurface, T, vanput_pay);
if abs(nonvan_pre-vancall_pre-vanput_pre) > 1e-10
    disp("Nonvanilla option cannot be approximated by vanilla!");
else
    disp("Nonvanilla option can be approximated by vanilla!");
end
