function [AnlLogPdRatio] = loglinearLogPdRatio(X_Rouw, pkappa1, pkappa1m, ParaSetProcess, ParaSetPreference)
% Function that calculate the loglinearized price to dividend ratio
% analytically using the method in the Bensal & Yaron (2004)
% by Ding Xiangyu (dingxiangyu@pku.edu.cn)
% 2021-6-20 12:59:32
% Input： 
%       X_Rouw: grid of x (long-run risk) from Rouwenhost method
%       pkappa1: parameter kappa1 of Campbell Shiller decomposition for return to wealth
%       pkappa1m: parameter kappa1 of Campbell Shiller decomposition for return to market
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

%Calculate pkappa0m, kappa0 and theta
pkappa0m = -log(((1-pkappa1m)^(1-pkappa1m))*(pkappa1m^pkappa1m));
pkappa0 = -log(((1-pkappa1)^(1-pkappa1))*(pkappa1^pkappa1));
ptheta = (1-pgamma)/(1-(1/ppsi));

% calculate the A1 coefficient of log linearization
pa1 =  (1 - (1/ppsi))/(1-pkappa1*prho);

% calculate the A0 coefficient of log linearization
pa0_nume = log(pbeta) + (1 - (1/ppsi))*pmu + pkappa0 + (ptheta/2)*((pkappa1*pa1*pphie)^2 + (1 - (1/ppsi))^2 )*(psigma^2);
pa0_deno = 1 - pkappa1;
pa0 = pa0_nume/pa0_deno;

% calculate A1m
pa1m = (pphi-(1/ppsi))/(1-pkappa1m*prho);

% calculate A and C
pa = ptheta*log(pbeta) - ptheta/ppsi*pmu + (ptheta-1)*(pkappa0+pkappa1*pa0-pa0+pmu);
pc0 = 0.5*psigma^2;
pc1 = (ptheta-1-ptheta/ppsi)^2;
pc2 = ((ptheta-1)*pkappa1*pa1*pphie+pkappa1m*pa1m*pphie)^2;
pc = pc0*(pc1+pc2+pphid^2);

% calculate A0m
pa0m = (pa + pc + pkappa0m + pmud)/(1-pkappa1m);

AnlLogPdRatio = pa0m + pa1m*X_Rouw;

end

