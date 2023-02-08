%% Function that calibrate the standard deviation of the SOE
% Replicator: DING Xiangyu 
% This replication is based on the original code provided by Liu et al.(2021)
% See https://www.aeaweb.org/articles?id=10.1257/mac.20180045 for reference
% Output: res = take 0 when 39% of SOEs are borrower 
% Input CaliParaSet is sig_s the standard deviation of the SOE


function [res]=RepCalibration(CaliParaSet,SubParaSet)
warning off all

sig_s = CaliParaSet(1);   % std of epsilon_s

alpha = SubParaSet(1);     % capital share
gamma = SubParaSet(2);     % DRS parameter
del   = SubParaSet(3);     % depreciation
phi   = SubParaSet(4);     % interest rate gap
b     = SubParaSet(5);     % borrowing limit in SOE is b*theta
z_s   = SubParaSet(6);     % sectoral productivity in soe
ZpZs  = SubParaSet(7);     % ratio of z_s/z_p
tau   = SubParaSet(8);     % output wedge
mu    = SubParaSet(9);     % mean of epsilon
theta = SubParaSet(10);    % parameter in financial constraint
beta  = SubParaSet(11);    % discount rate
sig_ZpZs = SubParaSet(12); % ratio of std_p and std_s

mu_s = mu;
mu_p = mu;  
z_p  = z_s*ZpZs;
sig_p= sig_s*sig_ZpZs;

ParaSet = [alpha gamma del phi tau theta b sig_s sig_p mu_s mu_p beta z_s z_p];

xini = [0.1399    0.0090   11.1016    6.572]';
[xopt, fval] = fsolve(@(X)RepSolveSteadyState(X,ParaSet),xini,optimset('TolX',1e-12,'Display','off'));
R  = xopt(1);rs = xopt(2);   Hs=xopt(3); Hp=xopt(4);  

alftil = alpha/(1-gamma);
kk     = alftil/(1-alftil);

% compute steady states: see RepSolveSteadyState for reference
es_p   = ((rs+del)/(alftil*z_p^alftil*R))^(1/alftil)*Hp^((1-alftil)/alftil);
esm_p  = ((rs+del+phi)/(alftil*z_p^alftil*R))^(1/alftil)*Hp^((1-alftil)/alftil);
ess_p  = ((rs+del+phi)/(alftil*z_p^alftil*R))^(1/alftil)*((1+theta)*Hp)^((1-alftil)/alftil);

Ek_p    = min(Fun_g(kk,0,mu_p,sig_p),1e3);
Ek_es_p = min(Fun_g(kk,es_p,mu_p,sig_p),1e3);
Ek_esm_p= min(Fun_g(kk,esm_p,mu_p,sig_p),1e3);
Ek_ess_p= min(Fun_g(kk,ess_p,mu_p,sig_p),1e3); 

Ea_p    = Fun_g(alftil,0,mu_p,sig_p);
Ea_es_p = Fun_g(alftil,es_p,mu_p,sig_p);
Ea_esm_p= Fun_g(alftil,esm_p,mu_p,sig_p);
Ea_ess_p= Fun_g(alftil,ess_p,mu_p,sig_p); 

F_es_p = 1-Fun_g(0,es_p,mu_p,sig_p);
F_esm_p= 1-Fun_g(0,esm_p,mu_p,sig_p);
F_ess_p= 1-Fun_g(0,ess_p,mu_p,sig_p);

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

KsHs = min(es_s^(-kk),1e3)*(Ek_s-Ek_es_s)+F_esm_s-F_es_s+min(esm_s^(-kk),1e3)*(Ek_esm_s-Ek_ess_s)+(1+b*theta)*(1-F_ess_s);
Ks   = Hs*KsHs;
KpHp = min(es_p^(-kk),1e3)*(Ek_p-Ek_es_p)+F_esm_p-F_es_p+min(esm_p^(-kk),1e3)*(Ek_esm_p-Ek_ess_p)+(1+theta)*(1-F_ess_p);
Kp   = Hp*KpHp;

KesHs = (z_s*min(es_s^(-kk),1e3))^alftil*(Ek_s-Ek_es_s)+z_s^alftil*(Ea_es_s-Ea_esm_s)...
       +(z_s*min(esm_s^(-kk),1e3))^alftil*(Ek_esm_s-Ek_ess_s)+(1+b*theta)^alftil*z_s^alftil*Ea_ess_s;
Kes   = Hs^alftil*KesHs;
KepHp = (z_p*min(es_p^(-kk),1e3))^alftil*(Ek_p-Ek_es_p)+z_p^alftil*(Ea_es_p-Ea_esm_p)...
       +(z_p*min(esm_p^(-kk),1e3))^alftil*(Ek_esm_p-Ek_ess_p)+(1+theta)^alftil*z_p^alftil*Ea_ess_p;
Kep   = Hp^alftil*KepHp;

K   = Ks+Kp;

Ns  = tau*Kes/(tau*Kes+Kep);
Np  = 1-Ns;
Ys  = Kes^(1-gamma)*Ns^gamma;
Yp  = Kep^(1-gamma)*Np^gamma;
Y   = Ys+Yp;

% target the fraction of SOE that is borrower to be 39%
mom = (1-F_esm_s)-0.39; 



res = mom*mom'*1e4;