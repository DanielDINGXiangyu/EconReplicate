% define a function to compute the k-th partial expectation of log-norm
% log(thet)~N(mu_bar,sig_bar.^2)
% E(thet.^k, when thet>epsstar)=exp(k.*mu_bar+k.^2.*sig_bar.^2/2).*normcdf((mu_bar+k.*sig_bar.^2-log(epst.*))/sig_bar);
% mu and sig are the mean and std of thet
% note, it is not the conditional expectation.

function [g]=Fun_g(k,epsstar,mu,sig)

% transform the mean and std of thet to the mean of log(thet)
mu_bar  = log(mu.^2./sqrt(sig.^2+mu.^2));   
sig_bar = sqrt(log((sig.^2+mu.^2)./mu.^2)); 

% compute the partial expectation
g = exp(k.*mu_bar+1/2.*k.^2.*sig_bar.^2).*normcdf(real(mu_bar+k.*sig_bar.^2-log(epsstar))./sig_bar,0,1);
g = min(g,1e3);