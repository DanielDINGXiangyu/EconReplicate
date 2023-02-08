%% Macro Finance Homework 1: Solve asset prices in RBC Model
% Author: Xiangyu DING and Pantalfini Matteo
% Xiangyu DING <dingdxy@connect.hku.hk>; Pantalfini Matteo <panta@connect.hku.hk>

% The model is a modified version of https://www.dynare.org/assets/tutorial/guide.pdf

%% 1. Variables
var 
h       $H$                 (long_name = 'Labor')
c       $C$                 (long_name = 'Consumption')
ii      $I$                 (long_name = 'Investment')
k       $K$                 (long_name = 'Capital') 
y       $Y$                 (long_name = 'Production')
m       $M$                 (long_name = 'SDF') 
w       $W$                 (long_name = 'Wage')
a       $a$                 (long_name = 'Log Productivity')
b       $b$                 (long_name = 'Log Investment Efficiency')
pc      $PC$                (long_name = 'Price to Consumption Ratio')
r       $R$                 (long_name = 'Return on Capital') 
rc      $R^c$               (long_name = 'Return on Consumption Claim')
rf      $R^f$               (long_name = 'Risk Free Return');

varexo 
e       $\varepsilon_t$     (long_name = 'Productivity Shocks')
u       $\nu_t$             (long_name = 'Investment Efficiency Shocks');

%% 2. Parameters
parameters 
BETA    $\beta$             (long_name = 'Discount Factor')
ALPHA   $\alpha$            (long_name = 'Capital Share')
DELTA   $\delta$            (long_name = 'Depreciation Rate')
THETA   $\theta$            (long_name = 'Labor Disutility Level')
PSI     $\psi$              (long_name = 'Fisher Elasticity of Labor') 
RHO     $\rho$              (long_name = 'VAR Shock Self-Autogression')
TAU     $\tau$              (long_name = 'VAR Shock Spillover');

%% 3. Calibration
% We use the value provided from dynare tutorial, see following link
% https://www.dynare.org/assets/tutorial/guide.pdf
% Quarter (4 month) value with BETA  = 0.99
ALPHA = 0.36;
RHO   = 0.95;
TAU   = 0.025;
BETA  = 0.99;
DELTA = 0.025;
PSI   = 0;
THETA = 2.95;

PHI   = 0.1;

%% 4. Steady State Values
a_ss = 0;
b_ss = 0;
m_ss = BETA;
pc_ss = BETA/(1-BETA);
rc_ss = 1/BETA - 1 ;
rf_ss = 1/BETA - 1 ;
r_ss = 1/BETA - (1-DELTA);

% hk for h/k: labor to capital ratio
hk_ss = (1/(ALPHA*BETA) - (1-DELTA)/ALPHA)^(1/(1-ALPHA));

% ck for c/k: consumption to capital ratio
ck_ss =  1/(ALPHA*BETA) - (1-DELTA)/ALPHA - DELTA;
h_ss = ((1/THETA)*(hk_ss/ck_ss)*(1-ALPHA)*(hk_ss^(-ALPHA)))^(1/(1+PSI));
k_ss = h_ss/hk_ss;
c_ss = ck_ss*k_ss;
ii_ss = DELTA*k_ss;
y_ss = (k_ss^ALPHA)*(h_ss^(1-ALPHA));
w_ss = (1-ALPHA)*y_ss/h_ss;


%% 5. Model
model;
[name = '1. Consumption-labor trade-off']
THETA*(h^PSI) = w/c;

[name = '2. Capital Euler equation']
m(+1)*(exp(b)/exp(b(+1)))*(exp(b(+1))*r(+1)+1-DELTA)=1;

[name = '3. Consumption claim investment Euler equation']
m(+1)*((pc(+1)+1)/pc)*(c(+1)/c)=1;

[name = '4. Risk-free bond investment Euler equation']
m(+1)*(rf+1) = 1;

[name = '5. Definition of consumption claim return']
rc = (pc+1)*(c/c(-1))/pc(-1) - 1;

[name = '6. Definition of SDF']
m = BETA*c(-1)/c;

[name = '7. Capital dynamic']
k = exp(b)*ii+(1-DELTA)*k(-1);

[name = '8. Budget constraint']
c+ii = w*h+r*k(-1);

[name = '9. Production function']
y = exp(a)*(k(-1)^ALPHA)*(h^(1-ALPHA));

[name = '10. Optimal capital']
r = ALPHA*y/k(-1);

[name = '11. Optimal labor']
w = (1-ALPHA)*y/h;

[name = '12. Productivity shocks']
a = RHO*a(-1)+TAU*b(-1) + e;

[name = '13. Investment shocks']
b = TAU*a(-1)+RHO*b(-1) + u;
end;

%% 6. Initative Values
initval;
h = h_ss;
c = c_ss;
ii = ii_ss;
k = k_ss;
y = y_ss;
m = m_ss;
r = r_ss;
w = w_ss;
a = a_ss; 
b = b_ss;
pc = pc_ss;
rc = rc_ss;
rf = rf_ss;
end;

%% 7. Check steady-state
steady;
check;

%% 8. Exogenous shocks
shocks;
var e; stderr 0.009;
var u; stderr 0.009;
var e, u = PHI*0.009*0.009;
end;

%% 9. Simulation
stoch_simul(periods=200000, order = 2,pruning ,nograph); 

%% 10. Write LaTex File

write_latex_definitions;
write_latex_parameter_table;
write_latex_original_model;
write_latex_dynamic_model;
write_latex_static_model;
collect_latex_files;

if system(['pdflatex -halt-on-error -interaction=batchmode ' M_.fname '_TeX_binder.tex'])
    warning('TeX-File did not compile; you need to compile it manually')
end

%% 11. Calculate Moment
a_sd = diag(sqrt(oo_.var))*sqrt(4)*100; 
a_moment = [
    oo_.mean(11)*400 ...
    (oo_.mean(11)-DELTA)*400 ...
    a_sd(11) ...
    oo_.mean(12)*400 ...
    a_sd(12)...
    oo_.mean(13)*400 ...
    a_sd(13)]';

Labels =['E[r]              ';
         'E[r]-\delta       ';
         'Sd[r]             ';
         'E[rc]             ';
         'Sd[rc]            ';
         'E[rf]             ';
         'Sd[rf]            '];
[Labels num2str(a_moment,'%2.3f')] 
