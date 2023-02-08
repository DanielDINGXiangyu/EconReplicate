%% Function that solve the steady state in the dynamic model
% Replicator: DING Xiangyu 
% This replication is based on the original code provided by Liu et al.(2021)
% See https://www.aeaweb.org/articles?id=10.1257/mac.20180045 for reference
% Output: res = the RHS-LHS of the market clearing condition (3.38),(3.48) (3.50)
% Input X = [R, rs, Hs, Hp] where:
%           R: return to capital of firms
%           rs: deposit (saving rate) of loanable fund market
%           Hs: SOEs firm value 
%           Hp: POEs firm value
%       ParaSet: all other parameters

function [res]=RepSolveSteadyState(X,ParaSet)
%% Input all the parameter in the ParaSet (from the calibration)
alpha = ParaSet(1); 
gamma = ParaSet(2); 
del   = ParaSet(3);
phi   = ParaSet(4);
tau   = ParaSet(5);
theta = ParaSet(6); 
b     = ParaSet(7);

sig_s = ParaSet(8);
sig_p = ParaSet(9); 
mu_s  = ParaSet(10);
mu_p  = ParaSet(11);

beta  = ParaSet(12);
z_s   = ParaSet(13);
z_p   = ParaSet(14);

%% Initiate the variable of the endogenous variable we need to solve out

R  = X(1); %R: return to capital of firms
rs = X(2); %rs: deposit (saving rate) of loanable fund market
Hs = X(3); %Hs: SOEs firm value 
Hp = X(4); %Hp: POEs firm value

% Define the simplified parameter in equation 
alftil = alpha/(1-gamma);
kk     = alftil/(1-alftil);


%% Compute the cutoff value of the POEs 
% es_p is the low cutoff value of the firms by equation (3.22)
es_p   = ((rs+del)/(alftil*z_p^alftil*R))^(1/alftil)*Hp^((1-alftil)/alftil);

% esm_p is the middle cutoff value of the firms by equation (3.23)
esm_p  = ((rs+del+phi)/(alftil*z_p^alftil*R))^(1/alftil)*Hp^((1-alftil)/alftil);

% esm_p is the high cutoff value of the firms by equation (3.24)
ess_p  = ((rs+del+phi)/(alftil*z_p^alftil*R))^(1/alftil)*((1+theta)*Hp)^((1-alftil)/alftil);

% %% Computation of the integral used in equation (3.20) and (2.27)
% Correspond to the integral part in (3.20), and (2.27)
% kk is the power in the underline condition in the integral of (3.20), and (2.27)
% These equations used the cutoff values calculated above
Ek_p    = min(Fun_g(kk,0    ,mu_p,sig_p),1e3); 
Ek_es_p = min(Fun_g(kk,es_p ,mu_p,sig_p),1e3);
Ek_esm_p= min(Fun_g(kk,esm_p,mu_p,sig_p),1e3);
Ek_ess_p= min(Fun_g(kk,ess_p,mu_p,sig_p),1e3); 

Ea_p    = Fun_g(alftil,0,mu_p,sig_p);
Ea_es_p = Fun_g(alftil,es_p,mu_p,sig_p);
Ea_esm_p= Fun_g(alftil,esm_p,mu_p,sig_p);
Ea_ess_p= Fun_g(alftil,ess_p,mu_p,sig_p); 

F_es_p = 1-Fun_g(0,es_p,mu_p,sig_p);
F_esm_p= 1-Fun_g(0,esm_p,mu_p,sig_p);
F_ess_p= 1-Fun_g(0,ess_p,mu_p,sig_p);

%% Compute the cutoff value of the SOEs: Repeat the code above 

es_s   = ((rs+del)/(alftil*tau*z_s^alftil*R))^(1/alftil)*Hs^((1-alftil)/alftil);
esm_s  = ((rs+del+phi)/(alftil*tau*z_s^alftil*R))^(1/alftil)*Hs^((1-alftil)/alftil);
ess_s  = ((rs+del+phi)/(alftil*tau*z_s^alftil*R))^(1/alftil)*((1+b*theta)*Hs)^((1-alftil)/alftil);

Ek_s    = min(Fun_g(kk,0,mu_s,sig_s),1e3);
Ek_es_s = min(Fun_g(kk,es_s,mu_s,sig_s),1e3);
Ek_esm_s= min(Fun_g(kk,esm_s,mu_s,sig_s),1e3);
Ek_ess_s= min(Fun_g(kk,ess_s,mu_s,sig_s),1e3); 

Ea_s    = Fun_g(alftil,0,mu_s,sig_s);
Ea_es_s = Fun_g(alftil,es_s,mu_s,sig_s);
Ea_esm_s= Fun_g(alftil,esm_s,mu_s,sig_s);
Ea_ess_s= Fun_g(alftil,ess_s,mu_s,sig_s); 

F_es_s = 1-Fun_g(0,es_s,mu_s,sig_s);
F_esm_s= 1-Fun_g(0,esm_s,mu_s,sig_s);
F_ess_s= 1-Fun_g(0,ess_s,mu_s,sig_s);

%% Compute the sectoral capital input and sectoral effective units of capital

% Ks is the capital in SOE in equation (3.30), and KsHs is the captial per firm value 
KsHs = min(es_s^(-kk),1e3)*(Ek_s-Ek_es_s)+F_esm_s-F_es_s+min(esm_s^(-kk),1e3)*(Ek_esm_s-Ek_ess_s)+(1+b*theta)*(1-F_ess_s);
Ks   = Hs*KsHs; 

% Kp is the capital in POE in equation (3.30), and KpHp is the captial per firm value 
KpHp = min(es_p^(-kk),1e3)*(Ek_p-Ek_es_p)+F_esm_p-F_es_p+min(esm_p^(-kk),1e3)*(Ek_esm_p-Ek_ess_p)+(1+  theta)*(1-F_ess_p);
Kp   = Hp*KpHp;

% Kes is the effective units of capital in SOE in equation (3.27), and KesHs is the effective units of captial per firm value 
KesHs = (z_s*min(es_s^(-kk),1e3))^alftil*(Ek_s-Ek_es_s)+z_s^alftil*(Ea_es_s-Ea_esm_s)...
       +(z_s*min(esm_s^(-kk),1e3))^alftil*(Ek_esm_s-Ek_ess_s)+(1+b*theta)^alftil*z_s^alftil*Ea_ess_s;
Kes   = Hs^alftil*KesHs;

% Kep is the effective units of capital in POE in equation (3.27), and KepHp is the effective units of captial per firm value 
KepHp = (z_p*min(es_p^(-kk),1e3))^alftil*(Ek_p-Ek_es_p)+z_p^alftil*(Ea_es_p-Ea_esm_p)...
       +(z_p*min(esm_p^(-kk),1e3))^alftil*(Ek_esm_p-Ek_ess_p)+(1+theta)^alftil*z_p^alftil*Ea_ess_p;
Kep   = Hp^alftil*KepHp;

%% Compute the firm value: equation (3.38) 

% RHS except beta in envelop condition equation (3.38) for SOE which is a function of the firm value
dDs  = 1-del+tau*R*z_s^alftil*min(es_s^(-kk*alftil),1e3)*alftil*Hs^(alftil-1)*(Ek_s-Ek_es_s)...
      -(del+rs)*min(es_s^(-kk),1e3)*(Ek_s-Ek_es_s)+(del+rs)*F_es_s...
      +tau*R*z_s^alftil*alftil*Hs^(alftil-1)*(Ea_es_s-Ea_esm_s)...
      +tau*R*z_s^alftil*min(esm_s^(-kk*alftil),1e3)*alftil*Hs^(alftil-1)*(Ek_esm_s-Ek_ess_s)...
      -(del+rs+phi)*min(esm_s^(-kk),1e3)*(Ek_esm_s-Ek_ess_s)+(del+rs+phi)*(F_ess_s-F_esm_s)...
      +(1+b*theta)^alftil*tau*R*z_s^alftil*alftil*Hs^(alftil-1)*Ea_ess_s-(del+rs+phi)*b*theta*(1-F_ess_s);
    
dDp  = 1-del+R*z_p^alftil*min(es_p^(-kk*alftil),1e3)*alftil*Hp^(alftil-1)*(Ek_p-Ek_es_p)...
      -(del+rs)*min(es_p^(-kk),1e3)*(Ek_p-Ek_es_p)+(del+rs)*F_es_p...
      +R*z_p^alftil*alftil*Hp^(alftil-1)*(Ea_es_p-Ea_esm_p)...
      +R*z_p^alftil*min(esm_p^(-kk*alftil),1e3)*alftil*Hp^(alftil-1)*(Ek_esm_p-Ek_ess_p)...
      -(del+rs+phi)*min(esm_p^(-kk),1e3)*(Ek_esm_p-Ek_ess_p)+(del+rs+phi)*(F_ess_p-F_esm_p)...
      +(1+theta)^alftil*R*z_p^alftil*alftil*Hp^(alftil-1)*Ea_ess_p-(del+rs+phi)*theta*(1-F_ess_p);

K   = Ks+Kp;

temp = 1/(tau*Kes+Kep);

% define four equations for four market clearing condition (take 0 when market clear)
res(1,1) = R-(1-gamma)*temp^gamma; % RHS- LHS of the loanable fund market clear (3.48)
res(2,1) = K-Hs-Hp; % RHS-LHS of the capital market clearing condition (3.50)
res(3,1) = 1/beta-dDs; % RHS-LHS of envelop condition (3.38)  for SOE
res(4,1) = 1/beta-dDp; % RHS-LHS of envelop condition (3.38) for POE



