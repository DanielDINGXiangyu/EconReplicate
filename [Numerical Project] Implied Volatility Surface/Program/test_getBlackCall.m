%% test getBlackCall
T = 0; % mainly to test whether allow zero time to maturity
f = 1.48;
Ks = 0:0.01:4; % mainly to test whether allow zero strike
Vs = linspace(0.25,0.35,length(Ks));
call = getBlackCall(f,T,Ks,Vs);
fprintf("\ngetBlackCall.m passes test! Also allow zero strikes\n\n");
