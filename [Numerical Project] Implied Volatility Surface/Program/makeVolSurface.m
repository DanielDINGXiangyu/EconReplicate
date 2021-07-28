% Inputs :
% fwdCurve : forward curve data
% Ts: vector of expiry times
% cps: vetor of 1 for call , -1 for put
% deltas : vector of delta in absolute value (e.g. 0.25)
% vols : matrix of volatilities
% Output :
% surface : a struct containing data needed in getVol
function volSurf = makeVolSurface ( fwdCurve , Ts , cps , deltas , vols )
    %% input check
    assert(length(cps) == length(deltas) == size(vols,2) ||...
        length(Ts) == size(vols,1),...
        "Input dimension does not match. Please check!");
    %% obtain some precomputed data
    [Ts_sorted, Ts_index] = sort(Ts); % sort time to maturity
    vols_sorted = vols(Ts_index,:); % sort the volatility matrix by rows according to the order of Ts
    Ts_cell = num2cell(Ts_sorted);
    vols_cell = mat2cell(vols_sorted,ones(1,size(vols,1)),size(vols,2));
    % obtain smile curve for each T
    smile_curve = cellfun(@(x,y) makeSmile (fwdCurve , x, cps , deltas , y ),...
       Ts_cell, vols_cell, 'UniformOutput',false);
    % obtain forward spot price
    fwds = cell2mat(arrayfun(@(x) getFwdSpot(fwdCurve, x),Ts_sorted,'UniformOutput',false));
    % check no arbitrage
    for i=1:length(Ts_sorted)-1
        K1 = fwds(i);
        K2 = fwds(i+1);
        V1 = getSmileVol(smile_curve{i},K1);
        V2 = getSmileVol(smile_curve{i+1},K2);
        C1 = getBlackCall(K1,Ts_sorted(i),K1,V1);
        C2 = getBlackCall(K2,Ts_sorted(i+1),K2,V2);
        assert(C1<C2, "No arbitrage not satisfied!");
    end
    %% save data
    volSurf.Ts = Ts_sorted;
    volSurf.vols = vols_sorted;
    volSurf.fwds = fwds;
    volSurf.fwdCurve = fwdCurve;
    volSurf.smile = smile_curve;
end