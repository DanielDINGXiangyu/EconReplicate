%% Replicate code for the Liu et al. (2021, AEJ Macro): Calibration_Replicate the Table 1
% Replicator: DING Xiangyu 
% This replication is based on the original code provided by Liu et al.(2021)
% See https://www.aeaweb.org/articles?id=10.1257/mac.20180045 for reference

clear 
close all
%% Set basic parameters
eta   = .85;         % span of control parameter
alpha = .5*eta;      % capital share in the production function, corresponds to "alpha*eta" in the paper
gamma = eta-alpha;   % labor share, corresponds to "(1-alpha)*eta" in the paper

del   = .1;        % depreciation rate
phi   = .032;      % interest rate gap
b     = .504/.279; % borrowing limit in SOE is b*theta

ZpZs  = 1.92;   % TFP: POE/SOE
tautil= 1.44;
tau   = tautil^(1/(1-gamma)); % tau_data=1.44 corresponds to \tilda{\tau} in the paper.
mu    = 1;      % normalize mean of eps to be 1
z_s   = 1;      % normalize the scale of SOE TFP to be 1
theta = .504/b; % theta_p, borrowing capacity of POE
beta  = .96;    % discount rate
sig_ZpZs = 1.23 ; % standard deviation of eps, POE/SOE

SubParaSet = [alpha gamma del phi b z_s ZpZs tau mu theta beta sig_ZpZs];

% Inital guess of the sig_s: standard deviation of SOEs
Pini = 0.2228; 
Plow = 0.01 ;  
Pupp = 0.9;   

% Use function fminsearchbnd. to find the value that gives the 39% of SOE borrowing
[Popt, fval] = fminsearchbnd(@(x)RepCalibration(x,SubParaSet),Pini,Plow,Pupp);    
sig_s = Popt;
Pini  = Popt;
mu_s = mu; mu_p = mu; z_p = z_s*ZpZs; sig_p = sig_s*sig_ZpZs;

%% Compute steady state at the calibrated parameters:  X = [R, rs, Hs, Hp]
%       R: return to capital of firms
%       rs: deposit (saving rate) of loanable fund market
%       Hs: SOEs firm value 
%       Hp: POEs firm value

ParaSet = [alpha gamma del phi tau theta b sig_s sig_p mu_s mu_p beta z_s z_p];

xini = [   0.1157    0.0090    3.0489    6.6851]'; xlow = [0 0 0 0 ]';xupp = [30 1  1 1]';
[xopt, fval] = fsolve(@(X)RepSolveSteadyState(X,ParaSet),xini,optimset('TolX',1e-12,'Display','off'));
xini = xopt';
if max(abs(fval))>1e-7
    error('the solution of steady state is not accurate')
end   

R  = xopt(1);rs = xopt(2); Hs=xopt(3); Hp=xopt(4);

[es_p,esm_p,ess_p,Ek_es_p,Ek_esm_p,Ek_ess_p,Ea_es_p,Ea_esm_p,Ea_ess_p,F_es_p,F_esm_p,F_ess_p,...
 es_s,esm_s,ess_s,Ek_es_s,Ek_esm_s,Ek_ess_s,Ea_es_s,Ea_esm_s,Ea_ess_s,F_es_s,F_esm_s,F_ess_s,...
 Ks,Kp,Ls,Lp,Ss,Sp,dDp,dDs,K,N,C,Y,Ys,Yp,Kes,Kep,Ns,Np,As,Ap,A,U]=RepSolveAllSteadyState(xopt,ParaSet);

% Save the result for the next step of simulation
save CaliParaSet xini alpha del beta b tau theta sig_s sig_p mu_s mu_p z_s z_p ZpZs gamma eta
save Pini_data Pini
%% present results
format short 
disp('  ')
disp('Calibrated Parameter Values')
disp(['beta:  ',num2str(beta)])
disp(['alpha: ',num2str(.5)])
disp(['eta:   ',num2str(eta)])
disp(['delta: ',num2str(del)])
disp(['phi:   ',num2str(phi)])
disp(['theta^s:',num2str(theta*b)]) 
disp(['theta^p:',num2str(theta)])
disp(['z^s:    ',num2str(z_s)])
disp(['z^p:    ',num2str(z_p)])
disp(['sig^s:  ',num2str(sig_s,'%9.3f')])
disp(['sig^p:  ',num2str(sig_p,'%9.3f')])
disp(['tau^s:  ',num2str(tautil)])
disp(['tau^p:  ',num2str(1)])

