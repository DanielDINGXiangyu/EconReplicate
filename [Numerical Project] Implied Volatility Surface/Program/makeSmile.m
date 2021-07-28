% Inputs :
% fwdCurve : forward curve data
% T: time to expiry of the option
% cps: vetor if 1 for call , -1 for put
% deltas : vector of delta in absolute value (e.g. 0.25)
% vols : vector of volatilities
% Output :
% curve : a struct containing data needed in getSmileK
function [ curve ]= makeSmile (fwdCurve , T, cps , deltas , vols )
    % Hints :
    % 1. assert vector dimension match
    % 2. resolve strikes using deltaToStrikes
    % 3. check arbitrages
    % 4. compute spline coefficients
    % 5. compute parameters aL , bL , aR and bR

    %% 1. assert vector dimension match 
    assert(length(cps)==length(deltas) && length(deltas)==length(vols),...
        'Dimension does not match! Please check!');

    %% 2. resolve strikes using deltaToStrikes and obtain call price
    % deltas_sorted = deltas(vols_index);
    fwd = getFwdSpot(fwdCurve, T); % get corresponding forward price
    Ks = arrayfun(@(x,y,z) getStrikeFromDelta(fwd, T, x, y, z),...
            cps, vols, deltas,'UniformOutput',false); % get strike price
    Ks = cell2mat(Ks);
    [Ks_sorted, Ks_index] = sort(Ks); % sort strike price
    vols_sorted = vols(Ks_index); % sort volatilities corresponding to strikes
    Ks_check = [0 Ks_sorted]; % add K_{0} = 0

    %% 3. check arbitrages 
    % get call price
    us = getBlackCall(fwd, T, Ks ,vols);
    us_sorted = us(Ks_index);
    % set (c(1)-c(0))/(k(1)-k(0)) = -1
    u0 = us_sorted(1)+Ks_sorted(1);
    us_check = [u0 us_sorted];

    % check no arbitrage (9)
    check = (us_check(3:end)-us_check(2:end-1))./...
        (Ks_check(3:end)-Ks_check(2:end-1)) < ...
        (us_check(2:end-1)-us_check(1:end-2))./...
        (Ks_check(2:end-1)-Ks_check(1:end-2));
    check = sum(check);
    if check > 0  
        error('No arbitrage not satisfied!');
    end

    %% 
    % 4. compute spline coefficients (for interpolation)
    % 5. compute parameters aL , bL , aR and bR (for extrapolation)
    coefs = spline(Ks_sorted,vols_sorted).coefs;  
    KL = Ks_sorted(1)*Ks_sorted(1)/Ks_sorted(2);
    KR = Ks_sorted(end)*Ks_sorted(end)/Ks_sorted(end-1);
    bR = atanh(sqrt(0.5))/(KR-Ks_sorted(end));
    bL = atanh(sqrt(0.5))/(Ks_sorted(1)-KL);
        % bR = atanh(-sqrt(0.5))/(KR-Ks_sorted(end));
        % bL = atanh(-sqrt(0.5))/(Ks_sorted(1)-KL);
        % can use the negative root of 0.5, then we get different/opposite of
        % the a, b coefficients, but the interpolation results are the same
        % since tanh is an odd function in the sense that
        % a*(exp(b)-exp(-b))/(exp(b)+exp(-b)) = (-a)*(exp(-b)-exp(b))/(exp(-b)+exp(b))
    derL = coefs(1,3);
    dercoef = polyder(coefs(end,:)); % can be vector of size 3,2,or 1
    value = [(Ks_sorted(end)-Ks_sorted(end-1))*(Ks_sorted(end)-Ks_sorted(end-1))...
        ;(Ks_sorted(end)-Ks_sorted(end-1));1];
    derR = dercoef*value(end-length(dercoef)+1:end); 
    % say, if length(dercoef) = 2 (parabolic essentially for the spline), then we pick up value(2:3)
    aL = -derL/bL;
    aR = derR/bR;

    %% 6. save results
    curve.Kvec_sorted = Ks_sorted;
    curve.vols_sorted = vols_sorted;
    curve.extra = [aL bL aR bR];
    % we don't actually need the spline coefficients. we can use directly the
    % command spline

end