%% Financial Economics 2: Homework 1 Question 2 
% Ding Xiangyu: dingxiangyu01@pku.edu.cn
% 2021-6-19 20:34:18

clear;
%% Setup parameter

% Parameter of process
pmu = 0.0015; %average consumption growth
pmud = 0.0015; %average dividend growth
prho = 0.979; %persistence of x
psigma = 0.0078; %std of g
pphi = 3; %x(long run risk) influence on dividend
pphie = 0.044; %relative std of x(long run risk)
pphid = 4.5; %relative std of dividend
ParaSetProcess = [pmu,pmud,prho,psigma,pphi,pphie,pphid];

% Parameter of preference
ppsi = 1.5; %lasticity of intertemporal substitution
pgamma = 10; %coefficient of relative risk averse
pbeta = 0.998; %discount rate of utility
ParaSetPreference = [ppsi, pgamma, pbeta];

% Parameter of Campbell-Shiller Decomposition (for analytical log-linearization method)
pkappa1 = 0.997; % kappa1 for CB Decomposition of return to wealth
pkappa1m = 0.997; % kappa1 for CB Decomposition of market return

% Set the number of grid
numGrid = 500;

% Calculate out all other parameter used
ptheta = (1-pgamma)/(1-(1/ppsi)); %Coefficient theta



%% Rouwenhost Discretization of AR(1)
psigmax = pphie*psigma; % std of x(long run risk)
psigmax_uncond = psigmax/(sqrt(1-prho^2)); % unconditional std of std of x(long run risk)

[P_Rouw, X_Rouw] = rouwen(prho, 0, psigmax_uncond, numGrid);

%% Policy Function of Wealth to Consumption Ratio
% set tolence level 
tol = 1e-5;
% initiate the wealth to consumption ratio

LHS = zeros(numGrid,1);% initiate wealth to consumption ratio as a vector
RHS = ones(numGrid,1);% initiate wealth to consumption ratio as a vector
Cons = pbeta*exp((1-(1/ppsi))*(pmu+X_Rouw)+0.5*ptheta*((1-(1/ppsi))^2)*psigma^2);

while max(abs(LHS-RHS))>tol
    LHS = RHS;
    Exp_Wc = P_Rouw'*(LHS.^ptheta); % this is a vector of expectation under different x

    % the constant part on the RHS of the iteration function under different x
    RHS = Cons.*(Exp_Wc.^(1/ptheta))+1;
end

% wealth to consumption ratio WcRatio = W/C
% price to consumption ratio PcRatio = (W-C)/C = WcRatio-1
WcRatio = RHS; 
PcRatio = WcRatio - 1 ;

% take logarithm
LogWcRatio = log(WcRatio);
LogPcRatio = log(PcRatio);

%% Calculate the analytical result
[AnlLogPcRatio] = loglinearLogPcRatio(X_Rouw, pkappa1, ParaSetProcess, ParaSetPreference);

%% Plot on the figure
figure(1)
plot(X_Rouw,AnlLogPcRatio,'red',X_Rouw,LogPcRatio,'blue')
title('PcRatio = f(x)')
legend('Log Linearization','Numerical')
xlabel('Long Run Risk x'),ylabel('Logarithm Price to Consumption Ratio');

%% Policy Function of Price to Dividend Ratio

% initiate the Price to Dividend Ratio
LHSpd = zeros(numGrid,1);% initiate wealth to consumption ratio as a vector
RHSpd = ones(numGrid,1);% initiate wealth to consumption ratio as a vector
Conspd1 = pbeta^ptheta;
Conspd2 = (ptheta-1-(ptheta/ppsi))*(pmu+X_Rouw) + 0.5*((ptheta-1-(ptheta/ppsi))^2)*(psigma^2);
Conspd3 = pmud + pphi*X_Rouw + 0.5*(pphid^2)*(psigma^2);
Conspd4 = (WcRatio-1).^(ptheta-1);
Conspd = Conspd1*(exp(Conspd2).*exp(Conspd3))./Conspd4;

while max(abs(LHSpd-RHSpd))>tol
    LHSpd = RHSpd;
    Exp_WcPd = P_Rouw'*((WcRatio.^(ptheta-1)).*(LHSpd+1)); % this is a vector of expectation under different x

    % the constant part on the RHS of the iteration function under different x
    RHSpd = Conspd.*Exp_WcPd;
end

PdRatio = RHSpd;
LogPdRatio = log(PdRatio) ;


[AnlLogPdRatio] = loglinearLogPdRatio(X_Rouw, pkappa1, pkappa1m, ParaSetProcess, ParaSetPreference);

figure(2)
plot(X_Rouw,AnlLogPdRatio,'red',X_Rouw,LogPdRatio,'blue')
title('PdRatio = g(x)')
legend('Log Linearization','Numerical')
xlabel('Long Run Risk x'),ylabel('Logarithm Price to Dividend Ratio');
