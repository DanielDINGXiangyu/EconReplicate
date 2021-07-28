% Uncertainty shocks are aggregate demand shocks
% dingxiangyu@pku.edu.cn. First version: 2021/06/30

% ------------------------------------------------------------------------------------
var 
C          % Consumption
Lambda     % Marginal Utility
ppi        % Inflation
m          % Matching Technology
qu         % Worker Matching Probability
qv         % Job filling Probability
N          % Employment
u          % Labor to Find Job
U          % Unemployment
Y          % Output
R          % Nominal Interest Rate
v          % Job vacancies
q          % Material Price
JF         % Firm Value
wN         % Nash Bargaining Wage
w          % Rigidity Wage

Z          % Productivity
sigma_zt   % Uncertainty
;

% ------------------------------------------------------------------------------------
varexo e_z e_sigma_z;

% ------------------------------------------------------------------------------------
parameters bbeta cchi eeta aalpha mmu rrho pphi kkappa b ggamma Omega_p pi_ss                 
phi_pi phi_y rho_z sigma_z rho_sigma_z sigma_sigma_z Y_ss R_ss h                      
;

% structural parameters
bbeta = 0.99;             % Household's discount factor
h = 0;                    % Habit persistence
% h = 0.6;                % Habit persistence
cchi = 0.547;             % Scale of disutility of working; calibrated as in the paper, but different values
eeta = 10;                % Elasticity of substitution between differentiated goods
aalpha = 0.50;            % Share parameter in matching function
mmu = 0.645;              % Matching efficiency
rrho = 0.10;              % Job separation rate
% rrho = 0.90;            % Job separation rate
pphi = 0.25;              % Flow benefit of unemployment
% pphi = 0;               % Flow benefit of unemployment
kkappa = 0.14;            % Flow cost of vacancy
% kkappa = 0.01;          % Flow cost of vacancy
b = 0.5;                  % Nash bargaining weight
ggamma = 0.8;             % Real wage rigidity
Omega_p = 112;            % Price adjustment cost 
% Omega_p = 0;            % Price adjustment cost 
pi_ss = 1.005;            % Steady-state inflation (or inflation target)
phi_pi = 1.5;             % Taylor-rule coefficient for inflation
phi_y = 0.2;              % Taylor-rule coefficient for output
Y_ss = 0.936;             % Steady-state aggregate output
R_ss = 1/bbeta*pi_ss;     % Steady-state nominal interest rate from Euler equation

% shock parameters
rho_z = 0.95;             % Persistence of technology level shock
sigma_z = 0.01;           % Mean volatility of technology shock
rho_sigma_z = 0.76;       % Persistence of technology uncertainty shock
sigma_sigma_z = 0.392;    % Standard deviation of technology uncertainty shock



% -----------------------------------------------------------------------------------
model; 
% 16 equations for the process of endogenous variables
1 = bbeta*Lambda(+1)/Lambda*R/ppi(+1);
Lambda = 1/(C-h*C(-1))-bbeta*h/(C(+1)-h*C);
q = (eeta-1)/eeta + Omega_p/eeta*(ppi/pi_ss*(ppi/pi_ss-1) - bbeta*Lambda(+1)/Lambda*Y(+1)/Y*ppi(+1)/pi_ss*(ppi(+1)/pi_ss-1));
m = mmu*u^aalpha*v^(1-aalpha);
qu = m/u;
qv = m/v;
N = (1-rrho)*N(-1) + m;
u = 1 - (1-rrho)*N(-1);
U = 1 - N;
Y = Z*N;
R = R_ss/pi_ss*pi_ss*(ppi/pi_ss)^phi_pi*(Y/Y_ss)^phi_y;
C + kkappa*v + Omega_p/2*(ppi/pi_ss-1)^2*Y = Y;
JF = q*Z - w + bbeta*Lambda(+1)/Lambda*(1-rrho)*JF(+1);
JF = cchi/qv;
b/(1-b)*JF = wN - pphi - cchi/Lambda + (1-rrho)*bbeta*Lambda(+1)/Lambda*(1-qu(+1))*b/(1-b)*JF(+1);
w = w(-1)^ggamma*wN^(1-ggamma);

% 2 equations for the process of productivity

log(Z) = rho_z*log(Z(-1)) + sigma_zt*e_z;
log(sigma_zt) = (1-rho_sigma_z)*log(sigma_z) + rho_sigma_z*log(sigma_zt(-1)) + sigma_sigma_z*e_sigma_z;


end;

% -----------------------------------------------------------------------------------
steady;
check;

% -----------------------------------------------------------------------------------
shocks;
var e_z = 1^2;
var e_sigma_z = 1^2;
end;

% -----------------------------------------------------------------------------------
stoch_simul(order=3,periods=2000,irf=40,nograph,pruning) Y C U v N ppi R JF Z q sigma_zt; 