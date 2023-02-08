% Inputs :
% curve : pre - computed fwd curve data
% T: forward spot date
% Output :
% fwdSpot : E[S(t) | S (0)]
function fwdSpot = getFwdSpot (curve , T)
    %% exploit the function getRateIntegral
    fwdSpot = curve.spot*exp(getRateIntegral(curve.curvedata,T+curve.tau));

end