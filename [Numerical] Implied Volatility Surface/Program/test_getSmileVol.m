%% basic computation
[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
tau = lag / 365; 
Ts = days / 365;
 
domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
volSurface = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);
smile = makeSmile(fwdCurve, Ts(end), cps, deltas, vols(end,:));
%% test getSmileVol 1 - return original data
fwd = getFwdSpot(fwdCurve,Ts(end));
Ks = cell2mat(arrayfun(@(x,y,z) getStrikeFromDelta(fwd,Ts(end),x,y,z),cps,vols(end,:),deltas,'UniformOutput',false));
vols_fit = getSmileVol(smile,Ks);
if sum(abs(vols_fit-vols(end,:)))>1e-10
    error("getSmileVol does not return original data!");
else
    fprintf("\ngetSmileVol.m passes test: return original volatilities. \n Also smooth and smile-shaped, please check output_test!\n\n");
end

%% test getSmileVol 2 - smile shape
Ks = 0:0.01:4;
T = 0.5;
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
saveas(gcf,"getSmileVol.jpg");
hold off;
