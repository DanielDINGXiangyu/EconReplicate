% Author: DING Xiangyu (dingxiangyu@pku.edu.cn)
% Function gives the numerical result of partial expectation of lognormal distribution
% log(x)~N(mu_bar,sig_bar^2)
%E(thet^k|thet>thetstar)=exp(k*mu_bar+k^2*sig_bar^2/2)*normcdf((mu_bar+k*sig_bar^2-log(thet*))/sig_bar);
% mu and sig are the mean and std of x rather than mu_bar and sig_bar

function [g] = Fun_g(k,thetstar,mu,sig)

% Translate the mean and std of x back to mu_bar and sig_bar
mu_bar  = log(mu^2/sqrt(sig^2+mu^2));  
sig_bar = sqrt(log((sig^2+mu^2)/mu^2)); 


% compute the partial expectation
g = exp(k*mu_bar+1/2*k^2*sig_bar^2)*normcdf(real(mu_bar+k*sig_bar^2-log(thetstar))/sig_bar,0,1);
end

