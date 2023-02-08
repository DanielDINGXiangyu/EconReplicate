% Inputs :
% curve : pre - computed data about an interest rate curve
% t: time
% Output :
% integ : integral of the local rate function from 0 to t
function [ integ ] = getRateIntegral (curve , t)
    %% Integrate over a stepwise constant function
    if t<0
        error('Time input must be positive')
    else
        index = sum(t>=curve(:,1));
        integ = curve(index,3)+(t-curve(index,1))*curve(min(index+1,size(curve,1)),2);
    end
end
