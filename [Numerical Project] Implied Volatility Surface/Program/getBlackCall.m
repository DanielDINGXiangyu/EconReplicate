% Inputs :
% f: forward spot for time T, i.e. E[S(T)]
% T: time to expiry of the option
% Ks: vector of strikes
% Vs: vector of implied Black volatilities
% Output :
% u: vector of call options undiscounted prices
function u = getBlackCall (f, T, Ks , Vs)
    %% input check
    if sum(size(f)) ~= 2 || sum(size(T)) ~= 2 ||...
            size(Ks,1) ~= size(Vs,1) || size(Ks,2) ~= size(Vs,2)
        error("Input invalid. Please check!");
    end 
    %% calculate Black-Scholes call price
    d1 = log(f./Ks(Ks>0))./Vs(Ks>0)/sqrt(T) + 0.5*Vs(Ks>0)*sqrt(T);
    d2 = d1 - Vs(Ks>0)*sqrt(T);
    u(Ks>0) = f*normcdf(d1) - Ks(Ks>0).*normcdf(d2);
    u(Ks==0) = f;
end