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

%% Test getpdf 1: plot the result, and check the shape of function

k=0:4/10000:4; %set 10000 grid point from 0 to 4
pdf1=getPdf(volSurface,1/12,k); %T=1 month, calculate the pdf
pdf2=getPdf(volSurface,3/12,k); %T=3 months, calculate the pdf
pdf3=getPdf(volSurface,12/12,k); %T=1 year, calculate the pdf
pdf4=getPdf(volSurface,24/12,k); %T=2 years, calculate the pdf

%plot the pdf function
subplot(2,2,1);
plot(k,pdf1);
xlabel('ST');
ylabel('Pdf of ST');
title('T=1 month'); 

subplot(2,2,2);
plot(k,pdf2);
xlabel('ST');
ylabel('Pdf of ST');
title('T=3 months'); 

subplot(2,2,3);
plot(k,pdf3);
xlabel('ST');
ylabel('Pdf of ST');
title('T=1 year'); 

subplot(2,2,4)
plot(k,pdf4);
xlabel('ST');
ylabel('Pdf of ST');
title('T=2 years'); 

% The getPdf is behave well, when the plot shows the following features:
% 1.The pdf are continuous in K for all T
% 2.The pdf have a bell shape for all T
% 3.The distribution is wider when T is longer

%% Test getpdf 2: Integration of pdf should be 1
T = linspace(0.001,1.999,100);%Set 100 grid point from 0.001 to 1.999

% Calculate the integral value for each time and ortanize in a vector integTest2
integTest2 = zeros(1,100);
for ii = 1:100
    integTest2(1,ii)=integral(@(k)getPdf(volSurface,T(ii),k),0,Inf);
end

% Test wheather the each value of integTest2 is 1
if sum(abs(integTest2-1)>1e-5) == 0
    disp('Test 2 passed: integration of pdf is 1');
else
    disp('Test 2 failed: please check the function!');
end

% The function behaves well, if the logic test shows that:
% 1. The integration of pdf function with different T are all 1
% 2. i.e. the result shows that 'Test 2 passed: Integration of pdf is 1'

%% Test 3: the mean of the risk neutral probability should be the forward

% Calculate the forwards with each T and ortanize in a vector fwdTest3
fwdTest3 = zeros(1,100);
for ii = 1:100
    fwdTest3(1,ii) = getFwdSpot(fwdCurve, T(ii));
end

% Calculate the mean of risk neutral probability with each T and ortanize in a vector meanTest3
meanTest3 = zeros(1,100);
for jj= 1:100
    meanTest3(1,jj) = integral(@(k)(getPdf(volSurface,T(jj),k).*k),0,+Inf);
end

% Test wheather each element of fwdTest3 equals to each element of meanTest3
if sum(abs(fwdTest3 - meanTest3)>1e-5) == 0
    disp('Test 3 passed: the mean of the risk neutral probability is the forward');
else
    disp('Test 3 failed: please check the function!');
end

% The function behaves well, if the logic test shows that:
% 1. The mean of the risk neutral probability is the forward
% 2. i.e. the result shows that 'Test 3 passed: the mean of the risk neutral probability is the forward'
