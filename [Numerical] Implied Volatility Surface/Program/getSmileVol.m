% Inputs :
% curve : pre - computed smile data
% Ks: vetor of strikes
% Output :
% vols : implied volatility at strikes Ks
function vols = getSmileVol (curve , Ks)
    %% extract elements from pre-computed curve data
    K_grid = curve.Kvec_sorted;
    vols = curve.vols_sorted;
    extra = curve.extra;

    %% implement interpolation and adjust extrapolation
    vol_interp = spline(K_grid,vols,Ks);

    vol_interp(Ks < K_grid(1)) = vols(1)*ones(size(Ks(Ks < K_grid(1)))) + ...
        extra(1)*tanh(extra(2)*(K_grid(1)-Ks(Ks < K_grid(1))));
    vol_interp(Ks > K_grid(end)) = vols(end)*ones(size(Ks(Ks > K_grid(end)))) + ...
        extra(3)*tanh(extra(4)*(Ks(Ks > K_grid(end))-K_grid(end)));

    %% save results
    vols = vol_interp;

end
