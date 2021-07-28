%% Replicate code for the Liu et al. (2021, AEJ Macro): Dynamic Model Figure 3: Transition path
% Replicator: DING Xiangyu 
% This replication is based on the original code provided by Liu et al.(2021)
% See https://www.aeaweb.org/articles?id=10.1257/mac.20180045 for reference

% Clear all the work space
clear 

% Load the calibrated parameter set in calibrated as the function
load CaliParaSet

%% Parameters
phi0    = .032; % Initial interest rate wedge before liberalization 
phi1    = 0;    % Terminal interest rate wedge after liberalization 
rho_phi = 0;    % AR(1) parameter for liberalization

% Save all the parameter in the vector ParaSet_0
ParaSet_0 = [alpha gamma del phi0 tau theta b sig_s sig_p mu_s mu_p beta z_s z_p];
%% Compute steady state at the calibrated parameters: the old steady state X = [R, rs, Hs, Hp]
%       R: return to capital of firms
%       rs: deposit (saving rate) of loanable fund market
%       Hs: SOEs firm value 
%       Hp: POEs firm value

% Initial guess of the steady state value
% Notice that we need to keep on trying the initial value of the four steady state value to make the function converge
xini = [0.1524    0.0231   10.5027    6.5649]'; 

% use MATLAB function fsolve to slove the X = [R, rs, Hs, Hp] that solve four market clearing condition:
% 1: loanable fund market clearing (3.48)
% 2: capital market clearing (3.50)
% 3: SOEs firm value solve the envelop function (3.38): no misprice of SOE firms
% 4: POEs firm value solve the envelop function (3.38): no misprice of POE firms
[xopt_0, fval] = fsolve(@(X)RepSolveSteadyState(X,ParaSet_0),xini,optimset('TolX',1e-12,'Display','off'));

% If the initial guess does not lead to congerge: we need to change the initial guess of the market clearing condition
if max(abs(fval))>1e-7
    error('the solution of steady state is not accurate')
end   

% Using equilibrium value of the X = [R, rs, Hs, Hp] to compute all other steady state value: 
% See function SolveAllSteadyState_SOE_Heter.m for reference
R_0  = xopt_0(1);rs_0 = xopt_0(2); Hs_0=xopt_0(3); Hp_0=xopt_0(4);
[es_p_0,esm_p_0,ess_p_0,Ek_es_p_0,Ek_esm_p_0,Ek_ess_p_0,Ea_es_p_0,Ea_esm_p_0,Ea_ess_p_0,F_es_p_0,F_esm_p_0,F_ess_p_0,...
 es_s_0,esm_s_0,ess_s_0,Ek_es_s_0,Ek_esm_s_0,Ek_ess_s_0,Ea_es_s_0,Ea_esm_s_0,Ea_ess_s_0,F_es_s_0,F_esm_s_0,F_ess_s_0,...
 Ks_0,Kp_0,Ls_0,Lp_0,Ss_0,Sp_0,dDp_0,dDs_0,K_0,N_0,C_0,Y_0,Ys_0,Yp_0,Kes_0,Kep_0,Ns_0,Np_0,As_0,Ap_0,A_0,U_0]=RepSolveAllSteadyState(xopt_0,ParaSet_0);
W_0 = gamma/(R_0/(1-gamma))^((1-gamma)/gamma);
save ParaSet beta alpha del gamma phi0 phi1 tau theta b mu_s mu_p sig_s sig_p rho_phi z_s z_p

%% Compute steady state for the new regime: redo the above codes using parameters of the new regimes
ParaSet_1 = [alpha gamma del phi1 tau theta b sig_s sig_p mu_s mu_p beta z_s z_p];

xini = [0.1494    0.0373    9.6522    8.2330]';
[xopt_1, fval] = fsolve(@(X)RepSolveSteadyState(X,ParaSet_1),xini,optimset('TolX',1e-12,'Display','off'));

if max(abs(fval))>1e-7
    error('the solution of steady state is not accurate')
end   

R_1  = xopt_1(1);rs_1 = xopt_1(2); Hs_1=xopt_1(3); Hp_1=xopt_1(4);
[es_p_1,esm_p_1,ess_p_1,Ek_es_p_1,Ek_esm_p_1,Ek_ess_p_1,Ea_es_p_1,Ea_esm_p_1,Ea_ess_p_1,F_es_p_1,F_esm_p_1,F_ess_p_1,...
 es_s_1,esm_s_1,ess_s_1,Ek_es_s_1,Ek_esm_s_1,Ek_ess_s_1,Ea_es_s_1,Ea_esm_s_1,Ea_ess_s_1,F_es_s_1,F_esm_s_1,F_ess_s_1,...
 Ks_1,Kp_1,Ls_1,Lp_1,Ss_1,Sp_1,dDp_1,dDs_1,K_1,N_1,C_1,Y_1,Ys_1,Yp_1,Kes_1,Kep_1,Ns_1,Np_1,As_1,Ap_1,A_1,U_1]=RepSolveAllSteadyState(xopt_1,ParaSet_1);
W_1 = gamma/(R_1/(1-gamma))^((1-gamma)/gamma);

% Save the old and new steady state value for dynare
save SteadyState_0 es_p_0 esm_p_0 ess_p_0 Ek_es_p_0 Ek_esm_p_0 Ek_ess_p_0 Ea_es_p_0 Ea_esm_p_0 Ea_ess_p_0 F_es_p_0 F_esm_p_0 F_ess_p_0 ...
                   es_s_0 esm_s_0 ess_s_0 Ek_es_s_0 Ek_esm_s_0 Ek_ess_s_0 Ea_es_s_0 Ea_esm_s_0 Ea_ess_s_0 F_es_s_0 F_esm_s_0 F_ess_s_0 ...
                   W_0 R_0 Hs_0 Hp_0 rs_0 Ks_0 Kp_0 Ls_0 Lp_0 Ss_0 Sp_0 dDp_0 dDs_0 K_0 N_0 C_0 Y_0 Ys_0 Yp_0 Kes_0 Kep_0 Ns_0 Np_0 As_0 Ap_0 A_0 U_0 xopt_0;
save SteadyState_1 es_p_1 esm_p_1 ess_p_1 Ek_es_p_1 Ek_esm_p_1 Ek_ess_p_1 Ea_es_p_1 Ea_esm_p_1 Ea_ess_p_1 F_es_p_1 F_esm_p_1 F_ess_p_1 ...
                   es_s_1 esm_s_1 ess_s_1 Ek_es_s_1 Ek_esm_s_1 Ek_ess_s_1 Ea_es_s_1 Ea_esm_s_1 Ea_ess_s_1 F_es_s_1 F_esm_s_1 F_ess_s_1 ...
                   W_1 R_1 Hs_1 Hp_1 rs_1 Ks_1 Kp_1 Ls_1 Lp_1 Ss_1 Sp_1 dDp_1 dDs_1 K_1 N_1 C_1 Y_1 Ys_1 Yp_1 Kes_1 Kep_1 Ns_1 Np_1 As_1 Ap_1 A_1 U_1 xopt_1;

%% Run dynare codes to compute the transition dynamics of the path
dynare RepTransPath_DRS_Bench.mod

% delete all the useless memories
delete *.log
delete *.asv
delete *dynamic.m
delete *results.mat
delete *static.m
delete *variables.m
delete *.cod
delete *.bin
delete *~
delete TransPath_DRS_Bench.m
delete SteadyState_0.mat
delete SteadyState_1.mat
delete ParaSet.mat
rmdir('RepTransPath_DRS_Bench','s')

%% Plot the figure

figure(2)
RepRunPlotFig   % plot transition path

%set(gcf,'PaperPositionMode','auto')
%print('figure_Pro','-depsc2')

