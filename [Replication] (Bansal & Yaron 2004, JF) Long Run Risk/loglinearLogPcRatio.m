function [AnlLogPcRatio] = loglinearLogPcRatio(X_Rouw, pkappa1, ParaSetProcess, ParaSetPreference)
% Function that calculate the loglinearized price to consumption ratio
% analytically using the method in the Bensal & Yaron (2004)
% by Ding Xiangyu (dingxiangyu@pku.edu.cn)
% 2021-6-20 12:59:32
% Input： 
%       X_Rouw: grid of x (long-run risk) from Rouwenhost method
%       pkappa1: parameter kappa1 of Campbell Shiller decomposition for return to wealth
%       ParaSetProcess: row vector parameters for process
%       ParaSetPreference: row vector parameters for preference
% Output:
%       AnlLogPcRatio: Vector of analytical logarithm price to consumption Ratio




% input all the parameters
pmu = ParaSetProcess(1);
pmud = ParaSetProcess(2);
prho = ParaSetProcess(3);
psigma = ParaSetProcess(4);
pphi = ParaSetProcess(5);
pphie = ParaSetProcess(6);
pphid = ParaSetProcess(7);

ppsi = ParaSetPreference(1);
pgamma = ParaSetPreference(2);
pbeta = ParaSetPreference(3);

%Calculate kappa0 and theta
pkappa0 = -log(((1-pkappa1)^(1-pkappa1))*(pkappa1^pkappa1));
ptheta = (1-pgamma)/(1-(1/ppsi));

% calculate the A1 coefficient of log linearization
pa1 =  (1 - (1/ppsi))/(1-pkappa1*prho);

% calculate the A0 coefficient of log linearization
pa0_nume = log(pbeta) + (1 - (1/ppsi))*pmu + pkappa0 + (ptheta/2)*((pkappa1*pa1*pphie)^2 + (1 - (1/ppsi))^2 )*(psigma^2);
pa0_deno = 1 - pkappa1;
pa0 = pa0_nume/pa0_deno;


AnlLogPcRatio = pa0 + pa1*X_Rouw;


end

