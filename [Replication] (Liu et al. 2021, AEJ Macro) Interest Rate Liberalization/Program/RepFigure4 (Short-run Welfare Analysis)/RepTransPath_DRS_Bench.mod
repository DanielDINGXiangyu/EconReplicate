warning off all
% Replicate code for the Liu et al. (2021, AEJ Macro): Dynamic Model Figure 3 and Figure 4: Dynare code for transition path
% Replicator: DING Xiangyu 
% This replication is based on the original code provided by Liu et al.(2021)
% See https://www.aeaweb.org/articles?id=10.1257/mac.20180045 for reference
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define Endogenous Variables

var Rt rst Nt Hst Hpt Kst Kpt Kt Kest Kept Lst Lpt Sst Spt Nst Npt Ast Apt At Yt Ct Ypt Yst dDst dDpt
    est_s esmt_s esst_s F_est_s F_esmt_s F_esst_s Ek_est_s Ek_esmt_s Ek_esst_s Ea_est_s Ea_esmt_s Ea_esst_s
    est_p esmt_p esst_p F_est_p F_esmt_p F_esst_p Ek_est_p Ek_esmt_p Ek_esst_p Ea_est_p Ea_esmt_p Ea_esst_p 
    phit Ut xit KHst KHpt Hsst Wt;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define Exogenous Variables

varexo phi_sst;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define Parameters
parameters alpha del gamma phi0 phi1 tau theta b mu_s mu_p sig_s sig_p rho_phi beta z_s z_p alftil kk;
load ParaSet
set_param_value('alpha',alpha);
set_param_value('del',del);
set_param_value('gamma',gamma);
set_param_value('phi0',phi0);
set_param_value('phi1',phi1);
set_param_value('tau',tau);
set_param_value('theta',theta);
set_param_value('b',b);
set_param_value('mu_s',mu_s);
set_param_value('mu_p',mu_p);
set_param_value('sig_s',sig_s);
set_param_value('sig_p',sig_p);
set_param_value('rho_phi',rho_phi);
set_param_value('beta',beta);
set_param_value('z_s',z_s);
set_param_value('z_p',z_p);

alftil = alpha/(1-gamma);
kk     = alftil/(1-alftil);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load SteadyState_0
load SteadyState_1
external_function (name = Fun_g, nargs = 4);
external_function (name = Fun_ek,nargs = 2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The dynamic equations of the model

model;
#Ek_p     = Fun_g(kk,0,mu_p,sig_p);
#Ek_s     = Fun_g(kk,0,mu_s,sig_s);

% Compute the cutoff values
est_p   = ((rst+del)/(alftil*z_p^alftil*Rt))^(1/alftil)*Hpt(-1)^((1-alftil)/alftil);
esmt_p  = ((rst+del+phit)/(alftil*z_p^alftil*Rt))^(1/alftil)*Hpt(-1)^((1-alftil)/alftil);
esst_p  = ((rst+del+phit)/(alftil*z_p^alftil*Rt))^(1/alftil)*((1+theta)*Hpt(-1))^((1-alftil)/alftil);

% %% Computation of the integral used in equation (3.20) and (2.27)
% Correspond to the integral part in (3.20), and (2.27)
% kk is the power in the underline condition in the integral of (3.20), and (2.27)
% These equations used the cutoff values calculated above

Ek_est_p  = Fun_g(kk,est_p,mu_p,sig_p);
Ek_esmt_p = Fun_g(kk,esmt_p,mu_p,sig_p);
Ek_esst_p = Fun_g(kk,esst_p,mu_p,sig_p); 

Ea_est_p = Fun_g(alftil,est_p,mu_p,sig_p);
Ea_esmt_p= Fun_g(alftil,esmt_p,mu_p,sig_p);
Ea_esst_p= Fun_g(alftil,esst_p,mu_p,sig_p); 

F_est_p = 1-Fun_g(0,est_p,mu_p,sig_p);
F_esmt_p= 1-Fun_g(0,esmt_p,mu_p,sig_p);
F_esst_p= 1-Fun_g(0,esst_p,mu_p,sig_p);

%% Compute the cutoff value of the SOEs: Repeat the code above 
est_s   = ((rst+del)/(alftil*tau*z_s^alftil*Rt))^(1/alftil)*Hst(-1)^((1-alftil)/alftil);
esmt_s  = ((rst+del+phit)/(alftil*tau*z_s^alftil*Rt))^(1/alftil)*Hst(-1)^((1-alftil)/alftil);
esst_s  = ((rst+del+phit)/(alftil*tau*z_s^alftil*Rt))^(1/alftil)*((1+b*theta)*Hst(-1))^((1-alftil)/alftil);

Ek_est_s = Fun_g(kk,est_s,mu_s,sig_s);
Ek_esmt_s= Fun_g(kk,esmt_s,mu_s,sig_s);
Ek_esst_s= Fun_g(kk,esst_s,mu_s,sig_s); 

Ea_est_s = Fun_g(alftil,est_s,mu_s,sig_s);
Ea_esmt_s= Fun_g(alftil,esmt_s,mu_s,sig_s);
Ea_esst_s= Fun_g(alftil,esst_s,mu_s,sig_s); 

F_est_s = 1-Fun_g(0,est_s,mu_s,sig_s);
F_esmt_s= 1-Fun_g(0,esmt_s,mu_s,sig_s);
F_esst_s= 1-Fun_g(0,esst_s,mu_s,sig_s);

%% Dynamaic equation of the capital input
Kst/Hst(-1) = Fun_ek(est_s,kk)*(Ek_s-Ek_est_s)+F_esmt_s-F_est_s+Fun_ek(esmt_s,kk)*(Ek_esmt_s-Ek_esst_s)+(1+b*theta)*(1-F_esst_s);
Kpt/Hpt(-1) = Fun_ek(est_p,kk)*(Ek_p-Ek_est_p)+F_esmt_p-F_est_p+Fun_ek(esmt_p,kk)*(Ek_esmt_p-Ek_esst_p)+(1+  theta)*(1-F_esst_p);

KHst = Kst/Hst(-1);
KHpt = Kpt/Hpt(-1);
Hsst = Hst(-1);

%% Dynamaic equation of the effective capital
Kest/Hst(-1)^alftil = (z_s*Fun_ek(est_s,kk))^alftil*(Ek_s-Ek_est_s)+z_s^alftil*(Ea_est_s-Ea_esmt_s)
              +(z_s*Fun_ek(esmt_s,kk))^alftil*(Ek_esmt_s-Ek_esst_s)+(1+b*theta)^alftil*z_s^alftil*Ea_esst_s;
Kept/Hpt(-1)^alftil = (z_p*Fun_ek(est_p,kk))^alftil*(Ek_p-Ek_est_p)+z_p^alftil*(Ea_est_p-Ea_esmt_p)
              +(z_p*Fun_ek(esmt_p,kk))^alftil*(Ek_esmt_p-Ek_esst_p)+(1+  theta)^alftil*z_p^alftil*Ea_esst_p;

%% Dynamaic equation of the loan
Lpt/Hpt(-1) = Fun_ek(esmt_p,kk)*(Ek_esmt_p-Ek_esst_p)-(F_esst_p-F_esmt_p)+  theta*(1-F_esst_p);
Lst/Hst(-1) = Fun_ek(esmt_s,kk)*(Ek_esmt_s-Ek_esst_s)-(F_esst_s-F_esmt_s)+b*theta*(1-F_esst_s);

%% Dynamaic equation of the borrowing
Sst/Hst(-1) = F_est_s-Fun_ek(est_s,kk)*(Ek_s-Ek_est_s);
Spt/Hpt(-1) = F_est_p-Fun_ek(est_p,kk)*(Ek_p-Ek_est_p);

%% Dynamaic equation of the firm value
dDst  = 1-del+tau*Rt(+1)*z_s^alftil*Fun_ek(est_s(+1),kk*alftil)*alftil*Hst^(alftil-1)*(Ek_s-Ek_est_s(+1))
      -(del+rst(+1))*Fun_ek(est_s(+1),kk)*(Ek_s-Ek_est_s(+1))+(del+rst(+1))*F_est_s(+1)
      +tau*Rt(+1)*z_s^alftil*alftil*Hst^(alftil-1)*(Ea_est_s(+1)-Ea_esmt_s(+1))
      +tau*Rt(+1)*z_s^alftil*Fun_ek(esmt_s(+1),kk*alftil)*alftil*Hst^(alftil-1)*(Ek_esmt_s(+1)-Ek_esst_s(+1))
      -(del+rst(+1)+phit(+1))*Fun_ek(esmt_s(+1),kk)*(Ek_esmt_s(+1)-Ek_esst_s(+1))+(del+rst+phit(+1))*(F_esst_s(+1)-F_esmt_s(+1))
      +(1+b*theta)^alftil*tau*Rt(+1)*z_s^alftil*alftil*Hst^(alftil-1)*Ea_esst_s(+1)-(del+rst(+1)+phit(+1))*b*theta*(1-F_esst_s(+1));
    
dDpt  = 1-del    +Rt(+1)*z_p^alftil*Fun_ek(est_p(+1),kk*alftil)*alftil*Hpt^(alftil-1)*(Ek_p-Ek_est_p(+1))
      -(del+rst(+1))*Fun_ek(est_p(+1),kk)*(Ek_p-Ek_est_p(+1))+(del+rst(+1))*F_est_p(+1)
      +Rt(+1)*z_p^alftil*alftil*Hpt^(alftil-1)*(Ea_est_p(+1)-Ea_esmt_p(+1))
      +Rt(+1)*z_p^alftil*Fun_ek(esmt_p(+1),kk*alftil)*alftil*Hpt^(alftil-1)*(Ek_esmt_p(+1)-Ek_esst_p(+1))
      -(del+rst(+1)+phit(+1))*Fun_ek(esmt_p(+1),kk)*(Ek_esmt_p(+1)-Ek_esst_p(+1))+(del+rst+phit(+1))*(F_esst_p(+1)-F_esmt_p(+1))
      +(1+theta)^alftil*Rt(+1)*z_p^alftil*alftil*Hpt^(alftil-1)*Ea_esst_p(+1)-(del+rst(+1)+phit(+1))*theta*(1-F_esst_p(+1));


%% Aggregate values
1 = beta*Ct/Ct(+1)*dDst;

1 = beta*Ct/Ct(+1)*dDpt;

1/Ct = beta*(1+rst)/Ct(+1)+xit;

Yt = Ypt + Yst;

Nt = 1;

Ct+Kt(+1)-(1-del)*Kt=Yt;

Kt = Kpt+Kst;

Kt = Hpt(-1)+Hst(-1);

Rt = (1-gamma)/(tau*Kest+Kept)^gamma;

Ypt = Kept^(1-gamma)*Npt^gamma;
Yst = Kest^(1-gamma)*Nst^gamma;

Npt =     Kept/(Kept+tau*Kest);
Nst = tau*Kest/(Kept+tau*Kest);

phit-phi_sst = rho_phi*(phit(-1)-phi_sst);

Ast = Yst/(Kst^alpha)/(Nst^gamma);
Apt = Ypt/(Kpt^alpha)/(Npt^gamma);
At  = Yt/(Kt^alpha*Nt^gamma);

Ut  = log(Ct)+beta*Ut(+1);

Wt = gamma/(Rt/(1-gamma))^((1-gamma)/gamma);

end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define the initial steady state
initval;

Rt=R_0; rst=rs_0; Nt=N_0; Hst=Hs_0; Hpt=Hp_0;  
Kst=Ks_0; Kpt=Kp_0; Kt=K_0; Kest=Kes_0; Kept=Kep_0; 
Lpt=Lp_0;Lst=Ls_0; Spt=Sp_0;Sst=Ss_0; Npt=Np_0;Nst=Ns_0;
Ast=As_0;Apt=Ap_0;At=A_0;
Yt=Y_0; Ct=C_0; Yst=Ys_0; Ypt=Yp_0; dDst=dDs_0; dDpt=dDp_0;

est_s=es_s_0; esmt_s=esm_s_0; esst_s=ess_s_0; 
F_est_s=F_es_s_0; F_esmt_s=F_esm_s_0; F_esst_s=F_ess_s_0; 
Ek_est_s=Ek_es_s_0; Ek_esmt_s=Ek_esm_s_0; Ek_esst_s=Ek_ess_s_0; 
Ea_est_s=Ea_es_s_0; Ea_esmt_s=Ea_esm_s_0; Ea_esst_s=Ea_ess_s_0; 

est_p=es_p_0; esmt_p=esm_p_0; esst_p=ess_p_0; 
F_est_p=F_es_p_0; F_esmt_p=F_esm_p_0; F_esst_p=F_ess_p_0; 
Ek_est_p=Ek_es_p_0; Ek_esmt_p=Ek_esm_p_0; Ek_esst_p=Ek_ess_p_0; 
Ea_est_p=Ea_es_p_0; Ea_esmt_p=Ea_esm_p_0; Ea_esst_p=Ea_ess_p_0;

phit=phi0; phi_sst=phi0; Ut=U_0;

end;
steady;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define the end steady state
endval;
Rt=R_1; rst=rs_1; Nt=N_1; Hst=Hs_1; Hpt=Hp_1;  
Kst=Ks_1; Kpt=Kp_1; Kt=K_1; Kest=Kes_1; Kept=Kep_1; 
Lpt=Lp_1;Lst=Ls_1; Spt=Sp_1;Sst=Ss_1; Npt=Np_1;Nst=Ns_1;
Ast=As_1;Apt=Ap_1;At=A_1;
Yt=Y_1; Ct=C_1; Yst=Ys_1; Ypt=Yp_1; dDst=dDs_1; dDpt=dDp_1;

est_s=es_s_1; esmt_s=esm_s_1; esst_s=ess_s_1; 
F_est_s=F_es_s_1; F_esmt_s=F_esm_s_1; F_esst_s=F_ess_s_1; 
Ek_est_s=Ek_es_s_1; Ek_esmt_s=Ek_esm_s_1; Ek_esst_s=Ek_ess_s_1; 
Ea_est_s=Ea_es_s_1; Ea_esmt_s=Ea_esm_s_1; Ea_esst_s=Ea_ess_s_1; 

est_p=es_p_1; esmt_p=esm_p_1; esst_p=ess_p_1; 
F_est_p=F_es_p_1; F_esmt_p=F_esm_p_1; F_esst_p=F_ess_p_1; 
Ek_est_p=Ek_es_p_1; Ek_esmt_p=Ek_esm_p_1; Ek_esst_p=Ek_ess_p_1; 
Ea_est_p=Ea_es_p_1; Ea_esmt_p=Ea_esm_p_1; Ea_esst_p=Ea_ess_p_1;

phit=phi1; phi_sst=phi1; Ut=U_1;
end;
steady;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deterministic simulation
simul(periods=500,maxit=5000,stack_solve_algo=0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

