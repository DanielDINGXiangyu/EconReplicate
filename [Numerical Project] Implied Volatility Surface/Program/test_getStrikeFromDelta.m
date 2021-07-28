%% test getStrikeFromDelta 1 - analytical solution for K
%In this test, we analytically calculate the value of K using predetermined values
%If the function works well, the numerically calculated value should coincide with 
%the analytical result
%Analytically, K=fwd*exp(-cp*sigma*sqrt(T)*(invnorm(delta)-1/2*sigma*sqrt(T)))
%Set sigma=T=1, delta=0, then if the function works well, K should be fwd*exp(-1/2)
sigma=2;
T=1;
fwd=1.5;
cp=1;
delta = 0.25;
K_num = getStrikeFromDelta(fwd , T, cp , sigma , delta );
K_ana = fwd*exp(-cp*sigma*sqrt(T)*(norminv(delta)-1/2*sigma*sqrt(T)));
if abs(K_num-K_ana)<1e-5
  disp('the function works well')
else
  disp('error!please check the function!')
end

%% test getStrikeFromDelta 2 - match getBlackCall
fwd = 1.5;
T = 0.8;
cp = 1;
sigma = 0.3;
delta = 0.25;
h = 1e-7;
K = getStrikeFromDelta(fwd,T,cp,sigma,delta);
delta_fit = (getBlackCall(fwd+h,T,K,sigma)-getBlackCall(fwd,T,K,sigma))/h;
if abs(delta-delta_fit)>1e-5
    error("getStrikeFromDelta does not match getBlackCall");
else
    fprintf("\ngetStrikeFromDelta.m passes test: matches getBlackCall.m.\n Also continuous and smooth, please check output_test!\n\n");
end






