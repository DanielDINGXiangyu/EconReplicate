%% basic computation
[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
tau = lag / 365; 
Ts = days / 365;
 
domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
volSurface = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);
smile = makeSmile(fwdCurve, Ts(end), cps, deltas, vols(end,:));
%% test getVol 1 - return original data
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

%% test getVol 2 - volatility surface
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