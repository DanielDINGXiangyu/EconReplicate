% Inputs :
% volSurf : volatility surface data
% T: time to expiry of the option
% Ks: vector of strikes
% Output :
% vols : vector of volatilities
% fwd: forward spot price for maturity T
function [vols , fwd] = getVol ( volSurf , T, Ks)
    %% input check
    assert(sum(size(T)==1) == 2, "Time input should be scalar. Please check!");
    Ts_grid = volSurf.Ts;
    assert(T <= Ts_grid(end), "Time out of bound!");
    %% implement interpolation
    smile = volSurf.smile;
    % locate the input maturity
    index = sum(T >= Ts_grid);
    % calculate forward spot price
    fwdCurve = volSurf.fwdCurve; fwds_grid = volSurf.fwds; fwd = getFwdSpot(fwdCurve,T);
    if index == length(Ts_grid) % T = TN
        fwd_r = fwds_grid(end); K_rs = fwd_r/fwd.*Ks;
        vols = getSmileVol(smile{end},K_rs);
    elseif index == 0 % T < T1
        fwd_r = fwds_grid(1); K_rs = fwd_r/fwd.*Ks;
        vols = getSmileVol(smile{1},K_rs);
    else
        T_l = Ts_grid(index); T_r = Ts_grid(index+1); dT = T_r-T_l;
        % calculate forward spot price of adjacent time grid
        fwd_l = fwds_grid(index); fwd_r = fwds_grid(index+1);
        % calculate K grid points (finding moneyness equivalent strikes)
        K_l = fwd_l/fwd.*Ks;
        K_r = fwd_r/fwd.*Ks;
        % calculate volatility grid according to smile
        sigma_l = getSmileVol(smile{index},K_l);
        sigma_r = getSmileVol(smile{index+1},K_r);
        % implement interpolation
        vols = (T_r-T)*T_l/dT.*sigma_l.*sigma_l + (T-T_l)*T_r/dT.*sigma_r.*sigma_r;
        vols = sqrt(vols/T);
    end
end
