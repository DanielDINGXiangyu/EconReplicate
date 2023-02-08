% Inputs :
% domCurve : domestic IR curve data
% forCurve : foreign IR curve data
% spot : spot exchange rate
% tau: lag between spot and settlement
% Output :
% curve : a struct containing data needed by getFwdSpot
function curve = makeFwdCurve ( domCurve , forCurve , spot , tau)
    %% input check
    if size(domCurve,1)~=size(forCurve,1) || size(domCurve,2)~=size(forCurve,2) ||...
            sum(size(spot))~=2 || sum(size(tau))~=2 || sum(domCurve(:,1)~=forCurve(:,1))~=0
        error("Input invalid. Please check!");
    end
    %% exploit the result from section 2.2
    curvedata(:,1) = domCurve(:,1);
    curvedata(:,2:3) = domCurve(:,2:3)-forCurve(:,2:3);
 
    %% save result in curve
    curve.curvedata = curvedata;
    curve.spot = spot;
    curve.tau = tau;
end
