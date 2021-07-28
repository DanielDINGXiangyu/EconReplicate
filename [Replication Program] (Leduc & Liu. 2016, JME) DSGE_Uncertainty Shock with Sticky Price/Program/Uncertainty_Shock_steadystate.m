function [ys,params,check] = Uncertainty_Shock_steadystate(ys,exo,M_,options_)
% function [ys,params,check] = NK_baseline_steadystate(ys,exo,M_,options_)
% computes the steady state for the NK_baseline.mod and uses a numerical
% solver to do so
% Inputs: 
%   - ys        [vector] vector of initial values for the steady state of
%                   the endogenous variables
%   - exo       [vector] vector of values for the exogenous variables
%   - M_        [structure] Dynare model structure
%   - options   [structure] Dynare options structure
%
% Output: 
%   - ys        [vector] vector of steady state values for the the endogenous variables
%   - params    [vector] vector of parameter values
%   - check     [scalar] set to 0 if steady state computation worked and to
%                    1 of not (allows to impose restrictions on parameters)

% read out parameters to access them with their name
NumberOfParameters = M_.param_nbr;
for ii = 1:NumberOfParameters
  paramname = M_.param_names{ii};
  eval([ paramname ' = M_.params(' int2str(ii) ');']);
end
% read out endogenous variables to access them with their name
NumberOfEndogenousVariables = M_.endo_nbr; 
for ii = 1:NumberOfEndogenousVariables
  varname = M_.endo_names{ii};
  eval([varname '= ys(' int2str(ii) ') ;']);
end
% initialize indicator
check = 0;


%% Enter model equations here
U = 0.064; qv = 0.7;
N = 1-U; m = rrho*N; u = 1-(1-rrho)*N; v = m/qv; Z = 1; T = pphi*(1-N);
Y = Z*N; Y_ss = Y; ppi = pi_ss; R = 1/bbeta*pi_ss; R_ss = R; r = R/ppi;
q = (eeta-1)/eeta; qu = m/u; sigma_zt = sigma_z;
e_z = 0; e_sigma_z = 0;
JF = kkappa/qv;
syms JW JU C Lambda wN w d cchi mmu
eq1 = JF == q*Z - w + bbeta *(1-rrho)*JF;
eq2 = JW == w - cchi/Lambda + bbeta*((1-rrho*(1-qu))*JW + rrho*(1-qu)*JU);
eq3 = JU == pphi + bbeta*(qu*JW + (1-qu)*JU);
eq4 = C == w*N + d;
eq5 = Lambda == 1/(1-h)/C - bbeta*h/(1-h)/C;
% eq6 = wN == (1-b)*(cchi/Lambda+pphi) + b*(q*Z+bbeta*(1-rrho)*bbeta*kkappa*v/u);
eq6 = wN == (1-b)*(cchi/Lambda+pphi) + b*(q*Z+bbeta*(1-rrho)*kkappa*v/u);
eq7 = wN == w;
eq8 = C + kkappa*v == Y;
eq9 = m == mmu*u^aalpha*v^(1-aalpha);
S = solve([eq1 eq2 eq3 eq4 eq5 eq6 eq7 eq8 eq9]);
JW = S.JW; JU = S.JU; C = S.C; Lambda = S.Lambda;
wN = S.wN; w = S.w; d = S.d; cchi = S.cchi; mmu = S.mmu;

%% end own model equations
params=NaN(NumberOfParameters,1);
for iter = 1:length(M_.params) %update parameters set in the file
  eval([ 'params(' num2str(iter) ') = ' M_.param_names{iter} ';' ])
end

NumberOfEndogenousVariables = M_.orig_endo_nbr; %auxiliary variables are set automatically
for ii = 1:NumberOfEndogenousVariables
  varname = M_.endo_names{ii};
  eval(['ys(' int2str(ii) ') = ' varname ';']);
end
