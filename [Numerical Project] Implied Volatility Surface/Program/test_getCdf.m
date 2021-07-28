%% Initialize the project for the test of getCdf
%clear the work space
clear;
clc;

[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
tau = lag / 365; % spot rule lag

% time to maturities in years
Ts = days / 365;

% construct market objects
domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
volSurface = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);

%% Test getCdf 1: plot the result, and check the shape of function

k=0:4/10000:4; %set 10000 grid point from 0 to 4
cdf1=getCdf(volSurface,0,k); %T=0 day, calculate the cdf
cdf2=getCdf(volSurface,1/12,k); %T=1 month, calculate the cdf
cdf3=getCdf(volSurface,6/12,k); %T=6 months, calculate the cdf
cdf4=getCdf(volSurface,2,k); %T=2 years, calculate the cdf

%plot the cdf function
subplot(2,2,1);
plot(k,cdf1,'linewidth',2);
axis([0,4,0,1]);
xlabel('ST');
ylabel('Cdf of ST');
title('T=0 day'); 

subplot(2,2,2);
plot(k,cdf2,'linewidth',2);
axis([0,4,0,1]);
xlabel('ST');
ylabel('Cdf of ST');
title('T=1 month'); 

subplot(2,2,3);
plot(k,cdf3,'linewidth',2);
axis([0,4,0,1]);
xlabel('ST');
ylabel('Cdf of ST');
title('T=6 month'); 

subplot(2,2,4);
plot(k,cdf4,'linewidth',2);
axis([0,4,0,1]);
xlabel('ST');
ylabel('Cdf of ST');
title('T=2 years'); 

% The getCdf is behave well, when the plot shows the following features:
% 1.The cdf are continuous and monotonically increases in K for all T
% 2.The cdf start from 0 when K=0 and reaches 1 when k approaches infinity
% 3.The distribution is wider when T is longer
% 4.When T=0, where is only one price, so cdf is discrete

