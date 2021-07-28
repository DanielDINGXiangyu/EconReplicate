% Inputs :
% fwd: forward spot for time T, i.e. E[S(T)]
% T: time to expiry of the option
% cp: 1 for call , -1 for put
% sigma : implied Black volatility of the option
% delta : delta in absolute value (e.g. 0.25)
% Output :
% K: strike of the option
function K = getStrikeFromDelta(fwd , T, cp , sigma , delta )
    %% input check
    if sum(size([fwd;T;cp;sigma;delta]))~=6
        error("Input invalid. Please check!");
    end
    %% apply bisection to do root-searching due to monotonicity

    K1 = 0; % initial lower bound of guessed K
    K2 = 1e+5; % initial upper bound of guessed K
    K_tol = 1e-5; % tolerance of guessed K

    while abs(K2-K1)>K_tol
        K=(K1+K2)/2;
        d1 = (log(fwd)-log(K))/(sigma*sqrt(T))+1/2*sigma*sqrt(T);
        delta_estimated = normcdf(cp*d1);
        if cp*(delta_estimated-delta)>0
            K1=K; 
            % if estimated delta is larger than actual delta (adjusted by cp flag), K is underestimated
        else
            K2=K; 
            % if estimated delta is lower than actual delta (adjusted by cp flag), K is overestimated
        end
     end
end
