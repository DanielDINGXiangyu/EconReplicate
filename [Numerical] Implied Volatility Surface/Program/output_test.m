%% basic computation
[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
tau = lag / 365; 
Ts = days / 365;
 
domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
volSurface = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);

%% output 
%% getBlackCall
subplot(2,2,1);
u1 = getBlackCall(1,0.8,0:0.01:4,0.3*ones(size(0:0.01:4)));
plot(0:0.01:4,u1);
title({["Black Call price with variating strikes"];["(fwd = 1, T = 0.8)"]});
xlabel("Strikes");
ylabel("Call Price");
%saveas(gcf,"C:/学习/研一/研一下/NUS/3. FE5116 Programming and Adanced Numerical Methods/Lecture Notes/project/Task_updated 4/output/getBlackCall1.jpg");
%saveas(gcf,"getBlackCall1.jpg");

subplot(2,2,2);
u2 = getBlackCall(1,0.8,1*ones(size(0.15:0.01:0.45)),0.15:0.01:0.45);
plot(0.15:0.01:0.45,u2);
title({["Black Call price with variating volatilities"];["(fwd = 1, T = 0.8)"]});
xlabel("Volatilities");
ylabel("Call Price");
%saveas(gcf,"getBlackCall2.jpg");

subplot(2,2,3);
u3 = cell2mat(arrayfun(@(x) getBlackCall(x,0.8,1,0.3),0.5:0.05:1.5,'UniformOutput',false));
plot(0.5:0.05:1.5,u3);
title({["Black Call price with variating forward"];["prices (T = 0.8, K = 1, \sigma = 0.3)"]});
xlabel("Forward prices");
ylabel("Call Price");
%saveas(gcf,"getBlackCall3.jpg");

subplot(2,2,4);
u4 = cell2mat(arrayfun(@(x) getBlackCall(1,x,1,0.3),0.1:0.01:2,'UniformOutput',false));
plot(0.1:0.01:2,u4);
title({["Black Call price with variating times"];["to maturity(fwd = 1, K = 1, \sigma = 0.3)"]});
xlabel("Time to maturity");
ylabel("Call Price");
%saveas(gcf,"getBlackCall4.jpg");

saveas(gcf,"getBlackCall.jpg");

%% getRateIntegral
DRI = cell2mat(arrayfun(@(x) getRateIntegral(domCurve,x),0.1:0.01:2,'UniformOutput',false));
plot(0.1:0.01:2,DRI);
title("Domestic Rate Integrals with variating times to maturity");
xlabel("Time to maturity");
ylabel("Rate Integral");
saveas(gcf,"getRateIntegral1.jpg");

FRI = cell2mat(arrayfun(@(x) getRateIntegral(forCurve,x),0.1:0.01:2,'UniformOutput',false));
plot(0.1:0.01:2,FRI);
title("Foreign Rate Integrals with variating times to maturity");
xlabel("Time to maturity");
ylabel("Rate Integral");
saveas(gcf,"getRateIntegral2.jpg");

%% getFwdSpot
FS = cell2mat(arrayfun(@(x) getFwdSpot(fwdCurve,x),0.1:0.01:2,'UniformOutput',false));
plot(0.1:0.01:2,FS);
title("Forward spot prices with variating times to maturity");
xlabel("Time to maturity");
ylabel("Forward Spot Price");
saveas(gcf,"getFwdSpot.jpg");

% decreasing since foreign interest rate is larger than domestic interest rate

%% getStrikeFromDelta
subplot(2,2,1);
K1 = cell2mat(arrayfun(@(x) getStrikeFromDelta(x,0.8,1,0.3,0.25),0.5:0.01:1.5,'UniformOutput',false));
K2 = cell2mat(arrayfun(@(x) getStrikeFromDelta(x,0.8,-1,0.3,0.25),0.5:0.01:1.5,'UniformOutput',false));
plot(0.5:0.01:1.5,K1);
hold on;
plot(0.5:0.01:1.5,K2);
title({["Implied Call/Put Strikes from delta with"];["variating forward prices"];["(T = 0.8, \sigma = 0.3, delta = 0.25)"]});
xlabel("Forward prices");
ylabel("Implied Call/Put Strikes");
legend(["Call","Put"]);
%saveas(gcf,"getStrikeFromDelta1.jpg");
hold off;

subplot(2,2,2);
K3 = cell2mat(arrayfun(@(x) getStrikeFromDelta(1,x,1,0.3,0.25),0.1:0.01:2,'UniformOutput',false));
K4 = cell2mat(arrayfun(@(x) getStrikeFromDelta(1,x,-1,0.3,0.25),0.1:0.01:2,'UniformOutput',false));
plot(0.1:0.01:2,K3);
hold on;
plot(0.1:0.01:2,K4);
title({["Implied Call/Put Strikes from delta with variating"];["times to maturity"];["(fwd = 1, \sigma = 0.3, delta = 0.25)"]});
xlabel("Time to maturity");
ylabel("Implied Call/Put Strikes");
legend(["Call","Put"]);
%saveas(gcf,"getStrikeFromDelta2.jpg");
hold off;

subplot(2,2,3);
K5 = cell2mat(arrayfun(@(x) getStrikeFromDelta(1,0.8,1,x,0.25),0.15:0.01:0.45,'UniformOutput',false));
K6 = cell2mat(arrayfun(@(x) getStrikeFromDelta(1,0.8,-1,x,0.25),0.15:0.01:0.45,'UniformOutput',false));
plot(0.15:0.01:0.45,K5);
hold on;
plot(0.15:0.01:0.45,K6);
title({["Implied Call/Put Strikes from delta"];["with variating volatilities"];["(fwd = 1, T = 0.8, delta = 0.25)"]});
xlabel("Volatilities");
ylabel("Implied Call/Put Strikes");
legend(["Call","Put"]);
%saveas(gcf,"getStrikeFromDelta3.jpg");
hold off;

subplot(2,2,4);
K7 = cell2mat(arrayfun(@(x) getStrikeFromDelta(1,0.8,1,0.3,x),0.1:0.01:0.5,'UniformOutput',false));
K8 = cell2mat(arrayfun(@(x) getStrikeFromDelta(1,0.8,-1,0.3,x),0.1:0.01:0.5,'UniformOutput',false));
plot(0.1:0.01:0.5,K7);
hold on;
plot(0.1:0.01:0.5,K8);
title({["Implied Call/Put Strikes from delta"];["with variating deltas"];["(fwd = 1, T = 0.8, \sigma = 0.3)"]});
xlabel("Deltas");
ylabel("Implied Call/Put Strikes");
legend(["Call","Put"]);
%saveas(gcf,"getStrikeFromDelta4.jpg");
hold off;

saveas(gcf,"getStrikeFromDelta.jpg");

%% getSmileVol
Ks = 0:0.01:4;
vol = zeros(10,length(Ks));
for i = 1:10
    smile = makeSmile(fwdCurve, Ts(i), cps, deltas, vols(i,:));
    vol(i,:) = cell2mat(arrayfun(@(x) getSmileVol(smile,x),Ks,'UniformOutput',false));
    plot(Ks,vol(i,:));
    hold on;
end
title("Volatility Smile");
xlabel("Strikes");
ylabel("Volatilites");
legend(["T = 0.0192","T = 0.0384","T = 0.0575","T = 0.0767","T = 0.1616","T = 0.2438","T = 0.4959","T = 1","T = 1.4959","T = 2"],'Location','Southeast');
saveas(gcf,"getSmileVol_original_data.jpg");
hold off;

Ks = 0:0.01:4;
T = 0.5
vol = zeros(10,length(Ks));
for i = 1:10
    smile = makeSmile(fwdCurve, T, cps, deltas, vols(end,:));
    vol(i,:) = cell2mat(arrayfun(@(x) getSmileVol(smile,x),Ks,'UniformOutput',false));
    T = T+0.1;
    plot(Ks,vol(i,:));
    hold on;
end
title("Volatility Smile");
xlabel("Strikes");
ylabel("Volatilites");
legend(["T = 0.5","T = 0.6","T = 0.7","T = 0.8","T = 0.9","T = 1.0","T = 1.1","T = 1.2","T = 1.3","T = 1.4"],'Location','Southeast');
saveas(gcf,"getSmileVol_same_vol_grid.jpg");
hold off;

%% getVol
% Ks = 0:0.01:4;
% Ts = 0.1:0.01:1.5;
% dense grids will make the surface black
Ks = 0:0.1:4;
Ts = 0.1:0.1:1.5;
Vol = arrayfun(@(x) getVol(volSurface,x,Ks),Ts,'UniformOutput',false);
Volmat = [];
for i = 1:size(Vol,2)
    Volmat = [Volmat;Vol{i}];
end
[K,T] = meshgrid(Ks,Ts);
figure;
surf(K,T,Volmat,'FaceAlpha',0.9,'FaceColor','interp');
title("Volatility Surface");
xlabel("Strikes");
ylabel("Time to maturity");
zlabel("Volatility");
saveas(gcf,"getVol.jpg");


%% getCdf
Ks = 0:0.01:4;
T = 0;
for i = 1:11
    cdf = cell2mat(arrayfun(@(x) getCdf(volSurface,T,x),Ks,'UniformOutput',false));
    T = T+0.2;
    plot(Ks,cdf);
    hold on;
end
plot(Ks,zeros(1,length(Ks)));
plot(Ks,ones(1,length(Ks)));
title("CDF of S_{T}");
xlabel("Strikes");
ylabel("CDF of S_{T}");
ylim([-0.2,1.2]);
legend(["T = 0","T = 0.2","T = 0.4","T = 0.6","T = 0.8","T = 1.0","T = 1.2","T = 1.4","T = 1.6","T = 1.8","T = 2"],'Location','Southeast');
saveas(gcf,"getCdf.jpg");
hold off;

%% getPdf
Ks = 0:0.01:4;
T = 0.1;
for i = 1:10
    pdf = cell2mat(arrayfun(@(x) getPdf(volSurface,T,x),Ks,'UniformOutput',false));
    T = T+0.2;
    plot(Ks,pdf);
    hold on;
end
plot(Ks,zeros(1,length(Ks)));
title("PDF of S_{T}");
xlabel("Strikes");
ylabel("PDF of S_{T}");
legend(["T = 0.1","T = 0.3","T = 0.5","T = 0.7","T = 0.9","T = 1.1","T = 1.3","T = 1.5","T = 1.7","T = 1.9"]);
saveas(gcf,"getPdf.jpg");
hold off;

%% getCdf and getPdf
Ks = 0:0.01:4;
cdf = getCdf(volSurface,0.8,Ks);
pdf = getPdf(volSurface,0.8,Ks);
plot(Ks,cdf);
hold on;
plot(Ks,pdf);
plot(Ks,zeros(1,length(Ks)),'y-.');
plot(Ks,ones(1,length(Ks)),'g-.');
ylim([-0.2,1.2]);
title("CDF and PDF for S_{T} (T = 0)");
xlabel("Strikes");
ylabel("CDF/PDF");
legend(["CDF","PDF"]);
saveas(gcf,"getCdf and getPdf.jpg");
hold off;

%% getEuropean
Ks = 0:0.01:2.5;
T = 0.5;
for i = 1:5
    European = cell2mat(arrayfun(@(x) getEuropean(volSurface,T,@(y) max(y-x,0),[0,x,+Inf]),Ks,'UniformOutput',false));
    T = T+0.2;
    plot(Ks,European);
    hold on;
end
title("Numerical undiscounted preimum");
xlabel("Strikes");
ylabel("Numerical undiscounted preimum");
legend(["T = 0.5","T = 0.7","T = 0.9","T = 1.1","T = 1.3"]);
saveas(gcf,"getEuropean.jpg");
hold off;

%% getBlackCall and getEuropean
Ks = 0:0.01:2.5;
European = cell2mat(arrayfun(@(x) getEuropean(volSurface,0.8,@(y) max(y-x,0),[0,x,+Inf]),Ks,'UniformOutput',false));
fwd = getFwdSpot(fwdCurve,0.8);
vol = getVol(volSurface,0.8,fwd);
vols = vol*ones(size(Ks));
Black = getBlackCall(fwd,0.8,Ks,vols);
plot(Ks,European,"b--",Ks,Black,"g:o");
title("Numerical and Analytical undiscounted preimum");
xlabel("Strikes");
ylabel("Undiscounted Preimum");
legend(["Numerical","Analytical"]);
saveas(gcf,"getEuropean and getBlackCall.jpg");
hold off;

%%
