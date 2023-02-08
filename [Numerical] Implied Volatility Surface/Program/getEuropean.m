% Computes the price of a European payoff by integration
% Input :
% volSurface : volatility surface data
% T : time to maturity of the option
% payoff : payoff function
% ints : optional , partition of integration domain
% e.g. [0, 3, +Inf ]. Defaults to [0, +Inf]
% Output :
% u : forward price of the option ( undiscounted price )
function u = getEuropean ( volSurface , T, payoff , ints )
    %% set default value for the 4th input
    if nargin < 4
        ints = [0,+Inf];
    end
    %% input check
    assert(length(ints) >= 2, "Input invalid. Please check!");
    %% get upper bound for integral
    ub = 3;
    while getCdf(volSurface,T,ub)<1
        ub = ub+1;
    end
    %% obtain pdf
    h = 1e-4; % if choose too small bump size, the function will be very slow!
    
    % h = 0.5e-3; 
    % will return a result different at the 4th decimal point but running
    % much faster - 0.25 sec versus 1.4 sec!
    
    % if choose something between 1e-4 and 0.5e-3, the result is the same
    % as latter, but slower, say, if choose 0.2e-3, the running time
    % increases up to 0.5 sec
    
    interval = ints(1):h:ub;
    pdf = getPdf(volSurface, T, interval);
    %% implement integration
    % we apply the midpoint rule and allow multiple breaking points
    loc = sum(ub >= ints);
    u = 0;
    lb = 1;
    for i = 1:loc
        if i == length(ints)
            break;
        else
            index = sum(ints(i+1) >= interval);
        end
        y1 = payoff(interval(lb:index)+0.5*h);
        I1 = sum(h*y1.*pdf(lb:index));
        u = u + I1;
        lb = index+1;
    end
end



