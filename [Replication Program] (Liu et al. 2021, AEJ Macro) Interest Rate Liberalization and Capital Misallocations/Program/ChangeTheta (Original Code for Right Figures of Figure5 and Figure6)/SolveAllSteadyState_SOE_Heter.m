%% solve steady state given R, rs, Hs, Hp are known
% 2018/09/28
% Decreasing return to scale

function [es_p,esm_p,ess_p,Ek_es_p,Ek_esm_p,Ek_ess_p,Ea_es_p,Ea_esm_p,Ea_ess_p,F_es_p,F_esm_p,F_ess_p,...
          es_s,esm_s,ess_s,Ek_es_s,Ek_esm_s,Ek_ess_s,Ea_es_s,Ea_esm_s,Ea_ess_s,F_es_s,F_esm_s,F_ess_s,...
          Ks,Kp,Ls,Lp,Ss,Sp,dDp,dDs,K,N,C,Y,Ys,Yp,Kes,Kep,Ns,Np,As,Ap,A,U]=SolveAllSteadyState_SOE_Heter(X,ParaSet)
% parameters
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

% input variables
R  = X(1);
rs = X(2);
Hs = X(3);
Hp = X(4);

alftil = alpha/(1-gamma);
kk     = alftil/(1-alftil);
% compute steady states
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


LpHp = min(esm_p^(-kk),1e3)*(Ek_esm_p-Ek_ess_p)-(F_ess_p-F_esm_p)+  theta*(1-F_ess_p);
Lp   = Hp*LpHp;
LsHs = min(esm_s^(-kk),1e3)*(Ek_esm_s-Ek_ess_s)-(F_ess_s-F_esm_s)+b*theta*(1-F_ess_s);
Ls   = Hs*LsHs;

SsHs = F_es_s-min(es_s^(-kk),1e3)*(Ek_s-Ek_es_s);
Ss   = Hs*SsHs;
SpHp = F_es_p-min(es_p^(-kk),1e3)*(Ek_p-Ek_es_p);
Sp   = Hp*SpHp;
  
  
K   = Ks+Kp;

Ns  = tau*Kes/(tau*Kes+Kep);
Np  = 1-Ns;
Ys  = Kes^(1-gamma)*Ns^gamma;
Yp  = Kep^(1-gamma)*Np^gamma;
Y   = Ys+Yp;

N   = 1;

C = Y-del*K;

As = Ys/(Ks^alpha)/(Ns^gamma);
Ap = Yp/(Kp^alpha)/(Np^gamma);

A  = Y/K^alpha;

U  = log(C)/(1-beta);
