%% report transition path for liberalization in the low subsidy model, 
% replicate left column in Figure 5
% 2019/07/22
clear
%% set basic parameters
phi0    = .032;  % initial interest rate wedge
phi1    = 0;    % terminal interest rate wedge
rho_phi = 0;    % AR(1) parameter for liberalization

load CaliParaSet

dd  = 1/tau;   % 1 for benchmark, and 1/tau for the control model with tau = 1
tau0 = tau*dd;
tau1 = tau*dd;
%sig_s= sig_p;
%% compute steady state at the calibrated parameters
ParaSet_0 = [alpha gamma del phi0 tau0 theta b sig_s sig_p mu_s mu_p beta z_s z_p];
xini = [0.1781    0.0185    0.6570   13.9960]'; 
[xopt_0, fval] = fsolve(@(X)SolveSteadyState_SOE_Heter(X,ParaSet_0),xini,optimset('TolX',1e-12,'Display','off'));

if max(abs(fval))>1e-7
    error('the solution of steady state is not accurate')
end   

R_0  = xopt_0(1);rs_0 = xopt_0(2); Hs_0=xopt_0(3); Hp_0=xopt_0(4);
[es_p_0,esm_p_0,ess_p_0,Ek_es_p_0,Ek_esm_p_0,Ek_ess_p_0,Ea_es_p_0,Ea_esm_p_0,Ea_ess_p_0,F_es_p_0,F_esm_p_0,F_ess_p_0,...
 es_s_0,esm_s_0,ess_s_0,Ek_es_s_0,Ek_esm_s_0,Ek_ess_s_0,Ea_es_s_0,Ea_esm_s_0,Ea_ess_s_0,F_es_s_0,F_esm_s_0,F_ess_s_0,...
 Ks_0,Kp_0,Ls_0,Lp_0,Ss_0,Sp_0,dDp_0,dDs_0,K_0,N_0,C_0,Y_0,Ys_0,Yp_0,Kes_0,Kep_0,Ns_0,Np_0,As_0,Ap_0,A_0,U_0]=SolveAllSteadyState_SOE_Heter(xopt_0,ParaSet_0);

save ParaSet beta alpha del gamma phi0 phi1 tau tau0 tau1 theta b mu_s mu_p sig_s sig_p rho_phi z_s z_p dd
%% compute steady state for the new regime
ParaSet_1 = [alpha gamma del phi1 tau1 theta b sig_s sig_p mu_s mu_p beta z_s z_p];

[xopt_1, fval] = fsolve(@(X)SolveSteadyState_SOE_Heter(X,ParaSet_1),xini,optimset('TolX',1e-12,'Display','off'));

if max(abs(fval))>1e-7
    error('the solution of steady state is not accurate')
end   

R_1  = xopt_1(1);rs_1 = xopt_1(2); Hs_1=xopt_1(3); Hp_1=xopt_1(4);
[es_p_1,esm_p_1,ess_p_1,Ek_es_p_1,Ek_esm_p_1,Ek_ess_p_1,Ea_es_p_1,Ea_esm_p_1,Ea_ess_p_1,F_es_p_1,F_esm_p_1,F_ess_p_1,...
 es_s_1,esm_s_1,ess_s_1,Ek_es_s_1,Ek_esm_s_1,Ek_ess_s_1,Ea_es_s_1,Ea_esm_s_1,Ea_ess_s_1,F_es_s_1,F_esm_s_1,F_ess_s_1,...
 Ks_1,Kp_1,Ls_1,Lp_1,Ss_1,Sp_1,dDp_1,dDs_1,K_1,N_1,C_1,Y_1,Ys_1,Yp_1,Kes_1,Kep_1,Ns_1,Np_1,As_1,Ap_1,A_1,U_1]=SolveAllSteadyState_SOE_Heter(xopt_1,ParaSet_1);


save SteadyState_0 es_p_0 esm_p_0 ess_p_0 Ek_es_p_0 Ek_esm_p_0 Ek_ess_p_0 Ea_es_p_0 Ea_esm_p_0 Ea_ess_p_0 F_es_p_0 F_esm_p_0 F_ess_p_0 ...
                   es_s_0 esm_s_0 ess_s_0 Ek_es_s_0 Ek_esm_s_0 Ek_ess_s_0 Ea_es_s_0 Ea_esm_s_0 Ea_ess_s_0 F_es_s_0 F_esm_s_0 F_ess_s_0 ...
                   R_0 Hs_0 Hp_0 rs_0 Ks_0 Kp_0 Ls_0 Lp_0 Ss_0 Sp_0 dDp_0 dDs_0 K_0 N_0 C_0 Y_0 Ys_0 Yp_0 Kes_0 Kep_0 Ns_0 Np_0 As_0 Ap_0 A_0 U_0;
save SteadyState_1 es_p_1 esm_p_1 ess_p_1 Ek_es_p_1 Ek_esm_p_1 Ek_ess_p_1 Ea_es_p_1 Ea_esm_p_1 Ea_ess_p_1 F_es_p_1 F_esm_p_1 F_ess_p_1 ...
                   es_s_1 esm_s_1 ess_s_1 Ek_es_s_1 Ek_esm_s_1 Ek_ess_s_1 Ea_es_s_1 Ea_esm_s_1 Ea_ess_s_1 F_es_s_1 F_esm_s_1 F_ess_s_1 ...
                   R_1 Hs_1 Hp_1 rs_1 Ks_1 Kp_1 Ls_1 Lp_1 Ss_1 Sp_1 dDp_1 dDs_1 K_1 N_1 C_1 Y_1 Ys_1 Yp_1 Kes_1 Kep_1 Ns_1 Np_1 As_1 Ap_1 A_1 U_1;

dynare TransPath_DRS_tau.mod
%% plot transition path
phit  = [phi0; ones(1499,1)*phi1]; % interest rate control path
T=39;
figure(4)
RunPlotFig
delete *.log
delete *.asv
delete *dynamic.m
delete *results.mat
delete *static.m
delete *variables.m
delete *.cod
delete *.bin
delete *~
delete TransPath_DRS_Tau.m
delete SteadyState_0.mat
delete SteadyState_1.mat
delete ParaSet.mat
rmdir('TransPath_DRS_tau','s')
%set(gcf,'PaperPositionMode','auto')
%print('figure_Pro','-depsc2')
