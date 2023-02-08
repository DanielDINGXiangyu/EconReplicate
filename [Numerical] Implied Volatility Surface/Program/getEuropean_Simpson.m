% Computes the price of a European payoff by integration
% Input :
% volSurface : volatility surface data
% T : time to maturity of the option
% payoff : payoff function
% ints : optional , partition of integration domain
% e.g. [0, 3, +Inf ]. Defaults to [0, +Inf]
% Output :
% u : forward price of the option ( undiscounted price )
function u = getEuropean_Simpson ( volSurface , T, payoff , ints )
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
    interval = ints(1):h:ub;
    pdf = getPdf(volSurface, T, interval);
    %% implement integration
    % we apply the Simpson rule and allow multiple breaking points
    loc = sum(ub >= ints);
    u = 0;
    lb = 1;
    for i = 1:loc
        if i == length(ints)
            break;
        else
            index = sum(ints(i+1) >= interval);
        end
        subinterval = interval(lb:index); l = length(subinterval);
        if mod(l,2) == 0
            % apply Simpson
            y1 = payoff(subinterval(1)+[0:l]*h);
            I1 = h*( y1(1)+y1(l+1) + 2*sum(y1(3:2:l-1)) + 4*sum(y1(2:2:l)) )/3;
        else
            % apply mid-point rule if number of grids is not even
            y1 = payoff(subinterval+0.5*h);
            I1 = sum(h*y1.*pdf(lb:index));
        end
        u = u + I1;
        lb = index+1;
    end
end


