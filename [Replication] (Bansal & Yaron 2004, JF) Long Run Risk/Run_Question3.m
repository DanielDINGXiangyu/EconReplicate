%% Financial Economics 2: Homework 1 
% Calculate the Rouwenhorst
% Ding Xiangyu: dingxiangyu01@pku.edu.cn
% 2021-6-19 20:34:18

clear;
%% Setup parameter


% Parameter of process
pmu = 0.0015; %average consumption growth
pmud = 0.0015; %average dividend growth
prho = 0; %persistence of x
psigma = 0.0078; %std of g
pphi = 3; %x(long run risk) influence on dividend
pphie = 0; %relative std of x(long run risk)
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

%% Calculate pkappa0m, pkappa0, pa1, pa1m, pa0, pa0m
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

%% Calculate other parameter

pb = pkappa1*pa1*pphie; %parameter B
plambda_meta = -pgamma; 
plambda_me = (1-ptheta)*pb; 
pbeta_me = pkappa1m * pa1m * pphie;

%% Random Number Generator

% Setup Number of Random Number for Simulation
rand_num = 1000000;


E_t = randn(rand_num, 12); % this is disturblance on x
Eta_t = randn(rand_num, 12); % this is disturblance on g
U_t = randn(rand_num, 12); % this is disturblance on gd

%Initiate vector of x
X_t = zeros(rand_num,12);
G_t = zeros(rand_num,12);
Gd_t = zeros(rand_num,12);

for ii = 2:12
    X_t(:,ii) = prho*X_t(:,ii-1) + pphie*psigma*E_t(:,ii-1);
    G_t(:,ii) = pmu + X_t(:,ii-1) + psigma*Eta_t(:,ii-1);
    Gd_t(:,ii) = pmud + pphi*X_t(:,ii-1) + pphid*psigma*U_t(:,ii-1);
end

%% Risk Free Return: Mean and Std
coef_rf = (ptheta-1)*(pkappa1*pa1*prho-pa1+1)-ptheta/ppsi;
interc_rf1 = ptheta-1-ptheta/ppsi;
interc_rf2 = (ptheta-1)*pkappa1*pa1*pphie;
interc_rf = -pa-0.5*(psigma^2)*(interc_rf1^2 +interc_rf2^2);

Rf = interc_rf-coef_rf*X_t;
Annual_Rf = sum(Rf,2);
erf = mean(Annual_Rf) * 100;
stdrf = std(Annual_Rf) * 100;
fprintf('Simulated Risk Free Rate Mean = %f\n', erf)
fprintf('Simulated Risk Free Rate Std= %f\n', stdrf)

%% Market Return: Mean, Std, Risk Premium
Ermt = plambda_me * pbeta_me * (psigma^2) - 0.5*(pphid^2 + pbeta_me^2) * psigma^2 + Rf;
Rmt = pphid*psigma*U_t + pbeta_me*psigma*E_t + Ermt;
Annual_Rmt = sum(Rmt,2);
ermt = mean(Annual_Rmt) * 100;
stdrmt = std(Annual_Rmt) * 100;
fprintf('Simulated Market Rate Mean= %f\n', ermt)
fprintf('Simulated Market Rate Std = %f\n', stdrmt)
fprintf('Simulated Market Risk Premium= %f\n', ermt-erf)

%% Price to dividend ratio
Pdt = pa0m + pa1m * X_t;
Gpt = zeros(rand_num,12);
for ii=2:12
    Gpt(:,ii) = Pdt(:,ii-1) + Gpt(:,ii) + Pdt(:,ii);
end
Gp = cumsum(Gpt,2);
Price = exp(Gp);
Dividend = Price./exp(Pdt);
Pdr = Price(:, 12) ./ sum(Dividend, 2);
fprintf('Simulated Market Risk Premium= %f\n', std(log(Pdr)))

