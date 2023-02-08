%% Initialize the project for the test of getRateIntegral
clear; %clear the work space
clc;
[spot, lag, days, domdf, fordf, vols, cps, deltas] =  getMarket(); %read data
%% Test getRateIntegral 1: plot the result, and check the shape of function
grid_num = 10000; % We set 10000 grid point from 0 year to 3 year
t_grid = linspace(0,3,grid_num);
for_integ = zeros(1,grid_num);
dom_integ = zeros(1,grid_num);
curve_for = makeDepoCurve(days/365,fordf);
curve_dom = makeDepoCurve(days/365,domdf);

% Calculate the related the interest rate integral of grid points
for ii = 1:grid_num
    for_integ(1,ii) = getRateIntegral(curve_for,t_grid(1,ii));
    dom_integ(1,ii) = getRateIntegral(curve_dom,t_grid(1,ii));
end

% Plot the function and see whether the shape is well-behaved
plot(t_grid,for_integ,t_grid,dom_integ)
xlabel('Time t')
ylabel('Rate Integral rt')
title('Plot getRateIntegral')
legend('Foreign','Domestic')

% The function is well-behaved, if the plot shows that the function:
% 1.monotonically increases in t
% 2.starts from 0 when time t = 0
% 3.is continuous
% 4,is piecewise linear

%% Test getRateIntegral 2: Show that return the original point
integ_kink_for = zeros(1,length(curve_for));
integ_kink_dom = zeros(1,length(curve_dom));

% Calculate the integral value in the original point and ortanize in a vector
for rr = 1: length(curve_for)
    integ_kink_for(1,rr) = getRateIntegral(curve_for,curve_for(rr,1));
end

for tt = 1: length(curve_dom)
    integ_kink_dom(1,tt) = getRateIntegral(curve_dom,curve_dom(tt,1));
end

% Change the original data into log return and organize in a vector
real_kink_for = [zeros(1,1);-log(fordf)]';
real_kink_dom = [zeros(1,1);-log(domdf)]';

%Test weather the original data fit the integral value, take 1e-10 as threshold
log_test2_for = sum((real_kink_for - integ_kink_for) > 1e-10);
log_test2_dom = sum((real_kink_dom - integ_kink_dom) > 1e-10);

if (log_test2_for==0) & (log_test2_dom == 0)
    disp('Test 2 passed: original value is returned');
else
    disp('Test 2 failed: please check the function');
end

% The function behaves well, if the logic test shows that:
% 1. difference between the integral value and original data are lower than the threshold
% 2. i.e. the result shows that 'Test 2 passed: original value is returned'

%% Test getRateIntegral 3: Show that return extreme value
log_test3_for = (getRateIntegral(curve_for,0)==0);
log_test3_dom = (getRateIntegral(curve_dom,0)==0);

if (log_test3_for == 1) & (log_test3_dom == 1)
    disp('Test 3 passed: function behaves well in extreme Value t=0 ');
else
    disp('Test 3 failed: please check the function');
end

% The function is well-behaved, if the logic test shows that:
% 1. the integral function give 0 when t=0 without any error
% 2. i.e. the result shows that 'Test 3 passed: function behaves well in extreme Value t=0 '