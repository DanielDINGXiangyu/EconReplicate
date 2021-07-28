% Computes the price of a European payoff by integration
% Input :
% volSurface : volatility surface data
% T : time to maturity of the option
% payoff : payoff function
% ints : optional , partition of integration domain
% e.g. [0, 3, +Inf ]. Defaults to [0, +Inf]
% Output :
% u : forward price of the option ( undiscounted price )
function u = getEuropean_SimpsonRichardson2 ( volSurface , T, payoff , ints )
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
    id1 = find(payoff(interval)~=0,1);  % capture for call
    id2 = find(payoff(interval)==0,1);  % capture for put
    % since this function aims to value European vanilla option (and
    % vanilla can be represented as a combination of vanilla), we can
    % simply drop the zero payoff region
    pdf = getPdf(volSurface, T, interval);
    %% implement integration
    % we apply the Simpson-Richardson rule and allow multiple breaking points
    u = 0;
    if id2 == 1 % put
        loc = sum(interval(id2) >= ints);
    else % call
        loc = sum(ub >= ints);
    end
    ints_lb = sum(ints>=interval(id1));
    for i = ints_lb:loc
        if i == length(ints)
            break;
        else
            index = sum(ints(i+1) >= interval);
        end
        subinterval = interval(ints_lb:index); l = length(subinterval);
        if mod(l,2) == 0
            % apply Simpson-Richardson
            y1 = payoff(subinterval(1)+[0:l]*h);
            I1 = Calc(y1,h);
            I2 = Calc(y1(1:2:l+1),2*h);
            I1 = (16*I1-I2)/15;
        else
            % apply mid-point rule if number of grids is not even
            y1 = payoff(subinterval+0.5*h);
            I1 = sum(h*y1.*pdf(ints_lb:index));
        end
        u = u + I1;
        ints_lb = index+1;
    end
end
function I = Calc(yi,h)
   n = length(yi)-1;
   I=h*( yi(1)+yi(n+1) + 2*sum(yi(3:2:n-1)) + 4*sum(yi(2:2:n)) )/3;
end