%% basic computation
[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
tau = lag / 365; 
Ts = days / 365;
 
domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
volSurface = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);
smile = makeSmile(fwdCurve, Ts(end), cps, deltas, vols(end,:));

%% test getFwdSpot
fwds = cell2mat(arrayfun(@(x) getFwdSpot(fwdCurve,x), Ts,'UniformOutput',false));
fwds_sorted = sort(fwds,"descend");
if sum(fwds~=fwds_sorted)>0
    error("Forward Spot not decreasing!");
else
    fprintf("\ngetFwdSpot.m passes test: decreasing since foreign interest rate is higher according to market data.\n Also continuous and smooth, please check output_test!\n\n");
end