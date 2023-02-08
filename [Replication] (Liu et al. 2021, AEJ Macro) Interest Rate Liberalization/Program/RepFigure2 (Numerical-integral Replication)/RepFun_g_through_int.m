% Author: DING Xiangyu (dingxiangyu@pku.edu.cn)
% Function gives the numerical result of partial expectation of lognormal distribution
% log(x)~N(mu_bar,sig_bar^2)
% mu and sig are the mean and std of x rather than mu_bar and sig_bar

function [g] = RepFun_g_through_int(k,thetstar,mu,sig)

% Define independent variable x
syms x; 

% Translate the mean and std of x back to mu_bar and sig_bar
mu_bar  = log(mu^2/sqrt(sig^2+mu^2));  
sig_bar = sqrt(log((sig^2+mu^2)/mu^2)); 

% Write down the underline function for integral
f(x)= ((x)^k)*(1/(sig_bar*x*sqrt(2*pi)))*exp(-0.5*((((log(x)-mu_bar))/sig_bar)^(2)));

% Result = Integral from thetstar to positive infinity
g=double(int(f,x,thetstar,+inf)); 
end

