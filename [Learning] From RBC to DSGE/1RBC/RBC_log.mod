%% Macro Finance Homework 1: Solve asset prices in RBC Model
% Author: Xiangyu DING and Pantalfini Matteo
% Xiangyu DING <dingdxy@connect.hku.hk>; Pantalfini Matteo <panta@connect.hku.hk>

% The model is a modified version of https://www.dynare.org/assets/tutorial/guide.pdf

%% 1. Variables
var 
lh       $H$                 (long_name = 'Log Labor')
lc       $C$                 (long_name = 'Log Consumption')
li       $I$                 (long_name = 'Log Investment')
lk       $K$                 (long_name = 'Log Capital') 
ly       $Y$                 (long_name = 'Log Production')
lm       $M$                 (long_name = 'Log SDF') 
lw       $W$                 (long_name = 'Log Wage')
a        $a$                 (long_name = 'Log Productivity')
b        $b$                 (long_name = 'Log Investment Efficiency')
pc       $PC$                (long_name = 'Price to Consumption Ratio')
r        $R$                 (long_name = 'Return on Capital') 
rc       $R^c$               (long_name = 'Return on Consumption Claim')
rf       $R^f$               (long_name = 'Risk Free Return');

varexo 
e        $\varepsilon_t$     (long_name = 'Productivity Shocks')
u        $\nu_t$             (long_name = 'Investment Efficiency Shocks');

%% 2. Parameters
parameters 
BETA     $\beta$             (long_name = 'Discount Factor')
ALPHA    $\alpha$            (long_name = 'Capital Share')
DELTA    $\delta$            (long_name = 'Depreciation Rate')
THETA    $\theta$            (long_name = 'Labor Disutility Level')
PSI      $\psi$              (long_name = 'Fisher Elasticity of Labor') 
RHO      $\rho$              (long_name = 'VAR Shock Self-Autogression')
TAU      $\tau$              (long_name = 'VAR Shock Spillover');

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

% Define the log steady-state value:
lh_ss = log(h_ss);
lc_ss = log(c_ss);
li_ss = log(ii_ss);
lk_ss = log(k_ss); 
ly_ss = log(y_ss);
lm_ss = log(m_ss); 
lw_ss = log(w_ss);
%% 5. Model
model;
[name = '1. Consumption-labor trade-off']
THETA*(exp(lh)^PSI) = exp(lw)/exp(lc);

[name = '2. Capital Euler equation']
exp(lm(+1))*(exp(b)/exp(b(+1)))*(exp(b(+1))*r(+1)+1-DELTA)=1;

[name = '3. Consumption claim investment Euler equation']
exp(lm(+1))*((pc(+1)+1)/pc)*(exp(lc(+1))/exp(lc))=1;

[name = '4. Risk-free bond investment Euler equation']
exp(lm(+1))*(rf+1) = 1;

[name = '5. Definition of consumption claim return']
rc = (pc+1)*(exp(lc)/exp(lc(-1)))/pc(-1) - 1;

[name = '6. Definition of SDF']
exp(lm) = BETA*exp(lc(-1))/exp(lc);

[name = '7. Capital dynamic']
exp(lk) = exp(b)*exp(li)+(1-DELTA)*exp(lk(-1));

[name = '8. Budget constraint']
exp(lc)+exp(li) = exp(lw)*exp(lh)+r*exp(lk(-1));

[name = '9. Production function']
exp(ly) = exp(a)*(exp(lk(-1))^ALPHA)*(exp(lh)^(1-ALPHA));

[name = '10. Optimal capital']
r = ALPHA*exp(ly)/exp(lk(-1));

[name = '11. Optimal labor']
exp(lw) = (1-ALPHA)*exp(ly)/exp(lh);

[name = '12. Productivity shocks']
a = RHO*a(-1)+TAU*b(-1) + e;

[name = '13. Investment shocks']
b = TAU*a(-1)+RHO*b(-1) + u;
end;

%% 6. Initative Values
initval;
lh = lh_ss;
lc = lc_ss;
li = li_ss;
lk = lk_ss;
ly = ly_ss;
lm = lm_ss;
r = r_ss;
lw = lw_ss;
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
