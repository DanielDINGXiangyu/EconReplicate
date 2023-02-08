% The model is a (slightly) simplified model of Leduc and Liu (2016). 
% The model features a stylized search-and-matching framework with sticky price.
% HUANG Kenghua. Peking University, HSBC Business School. khhuang@pku.edu.cn. 
% DING Xiangyu. Peking University, HSBC Business School. dingxiangyu@pku.edu.cn 

% ------------------------------------------------------------------------------------
% vars & params 
var        C                       $C_t$                      (long_name = 'Consumption')
           Lambda                  $\Lambda$                  (long_name = 'Marginal Utility') 
         % P                       $P_t$                      (long_name = 'Nominal Aggregate Price')
           ppi                     $\pi$                      (long_name = 'Inflation')
           m                       $m_t$                      (long_name = 'Matching Technology')
           qu                      $q_{t}^u$                  (long_name = 'Worker Matching Probability') 
           qv                      $q_{t}^v$                  (long_name = 'Vacancy Filled Probability')
           N                       $N_t$                      (long_name = 'Aggregate Employment')
           u                       $u_t$                      (long_name = 'Number of Searching Unemployed')
           U                       $U_t$                      (long_name = 'Unemployment Rate')
           Y                       $Y_t$                      (long_name = 'Aggregate Output')
           R                       $R_t$                      (long_name = 'Nominal Interest Rate')
           r                       $r_t$                      (long_name = 'Real Interest Rate') 
           v                       $v_t$                      (long_name = 'Vacancies Posted')
           q                       $q_t$                      (long_name = 'Relative Price')
           JF                      $J_{t}^F$                  (long_name = 'Firm Value')
           JW                      $J_{t}^W$                  (long_name = 'Employed Value')
           JU                      $J_{t}^U$                  (long_name = 'Unemployed Value')
           wN                      $w_{t}^N$                  (long_name = 'Nash Bargaining Wage')
           w                       $w_t$                      (long_name = 'Sticky Wage')
           Z                       $Z_t$                      (long_name = 'Technology')
           sigma_zt                $\sigma_{zt}$              (long_name = 'Technology Shock')
         % B                       $B_t$                      (long_name = 'Nominal Bond')
           d                       $d_t$                      (long_name = 'Profit Income from Ownership')
           T                       $T_t$                      (long_name = 'Lump-sum Tax');

% trend_var(growth_factor=ppi) P;
% var (deflator = P(-1)) PP;

varexo     e_z                     $\varepsilon_t$            (long_name = 'technology shock')
           e_sigma_z               $e_t$                      (long_name = 'uncertainty shock');

parameters bbeta                   $\beta$                    (long_name = 'Discount Factor')
           cchi                    $\chi$                     (long_name = 'Disutility of Working')
           eeta                    $\eta$                     (long_name = 'Elasticity of Substitution between Differentiated Goods')
           aalpha                  $\alpha$                   (long_name = 'Share Parameter in Matching Function')
           mmu                     $\mu$                      (long_name = 'Matching Efficiency')
           rrho                    $\rho$                     (long_name = 'Job Separation Rate')
           pphi                    $\phi$                     (long_name = 'Flow Benefit of Unemployment')
           kkappa                  $\kappa$                   (long_name = 'Flow Cost of Vacancy')
           b                       $b$                        (long_name = 'Nash bargaining Weight')
           ggamma                  $\Lambda$                   (long_name = 'Real Wage Rigidity')
           Omega_p                 $\Omega_p$                 (long_name = 'Price Adjustment Cost')
           pi_ss                   $\pi_{SS}$                 (long_name = 'Steady-State/Targetted Inflation')
           phi_pi                  $\phi_\pi$                 (long_name = 'Taylor-Rule Coefficient for Inflation')
           phi_y                   $\phi_y$                   (long_name = 'Taylor-Rule Coefficient for Output')
           rho_z                   $\rho_z$                   (long_name = 'Persistence of Technology Level Shock')
           sigma_z                 $\sigma_z$                 (long_name = 'Mean Volatility of Technology Shock')
           rho_sigma_z             $\rho_{\sigma_z}$          (long_name = 'Persistence of Technology Uncertainty Shock')
           sigma_sigma_z           $\sigma_{\sigma_z}$        (long_name = 'Standard Deviation of Technology Uncertainty Shock')      
           Y_ss                    $Y_{SS}$                   (long_name = 'Steady-State Aggregate Output')
           R_ss                    $R_{SS}$                   (long_name = 'Steady-State Nominal Interest Rate')
           h                       $h$                        (long_name = 'Habit Persistence');

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
% model 
model; 
[name = '1. budg con']
% C + B/P/R = B(-1)/P + w*N + pphi*(1-N) + d - T;
C = w*N + pphi*(1-N) + d - T;

% [name = '2. def pi']
% ppi = PP/PP(-1);

[name = '3. Euler eqn']
1 = bbeta*Lambda(+1)/Lambda*R/ppi(+1);

[name = '4. MU']
Lambda = 1/(C-h*C(-1))-bbeta*h/(C(+1)-h*C);

[name = '5. optim price']
q = (eeta-1)/eeta + Omega_p/eeta*(ppi/pi_ss*(ppi/pi_ss-1) - bbeta*Lambda(+1)/Lambda*Y(+1)/Y*ppi(+1)/pi_ss*(ppi(+1)/pi_ss-1));

[name = '6. matching']
m = mmu*u^aalpha*v^(1-aalpha);

[name = '7. job found'] 
qu = m/u;

[name = '8. vacancy filled'] 
qv = m/v;

[name = '9. emp dyn'] 
N = (1-rrho)*N(-1) + m;

[name = '10. # of searching']
u = 1 - (1-rrho)*N(-1);

[name = '11. unemp']
U = 1 - N;

[name = '12. agg prod / intermediate mkt clear']
Y = Z*N;

[name = '13. agg tech shock']
log(Z) = rho_z*log(Z(-1)) + sigma_zt*e_z;

[name = '14. uncertainty shock']
log(sigma_zt) = (1-rho_sigma_z)*log(sigma_z) + rho_sigma_z*log(sigma_zt(-1)) + sigma_sigma_z*e_sigma_z;

[name = '15. firm value']
JF = q*Z - w + bbeta*Lambda(+1)/Lambda*(1-rrho)*JF(+1);

[name = '16. free entry']
JF = kkappa/qv;

[name = '17. employed value']
JW = w - cchi/Lambda + bbeta*Lambda(+1)/Lambda*((1-rrho*(1-qu(+1)))*JW(+1) + rrho*(1-qu(+1))*JU(+1));

[name = '18. unemployed value']
JU = pphi + bbeta*Lambda(+1)/Lambda*(qu(+1)*JW(+1) + (1-qu(+1))*JU(+1));

[name = '19. Nash bargaining wage']
% wN = (1-b)*(cchi/Lambda+pphi) + b*(q*Z + bbeta*(1-rrho)*bbeta*Lambda(+1)/Lambda*kkappa*v(+1)/u(+1));
wN = (1-b)*(cchi/Lambda+pphi) + b*(q*Z + bbeta*(1-rrho)*Lambda(+1)/Lambda*kkappa*v(+1)/u(+1));

[name = '20. sticky wage']
w = w(-1)^ggamma*wN^(1-ggamma);

[name = '21. Taylor rule']
R = R_ss/pi_ss*pi_ss*(ppi/pi_ss)^phi_pi*(Y/Y_ss)^phi_y;

% [name = '22. Bond mkt clear']
% B = 0;

[name = '23. final mkt clear']
C + kkappa*v + Omega_p/2*(ppi/pi_ss-1)^2*Y = Y;

[name = '24. real interest rate']
r = R/ppi(+1);
% riskless interest rate is predetermined

[name = '25. government budget balance']
pphi*(1-N) = T;

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
//use command to generate TeX-Files with dynamic and static model equations
options_.TeX=1;
write_latex_dynamic_model;
write_latex_static_model;
write_latex_definitions;
write_latex_parameter_table;

% -----------------------------------------------------------------------------------
stoch_simul(order=3,periods=2000,irf=40,nograph,pruning) Y C U v N ppi R r JF Z q sigma_zt; 

% -----------------------------------------------------------------------------------

y_pos      	 = strmatch('Y',M_.endo_names,'exact');
c_pos      	 = strmatch('C',M_.endo_names,'exact');
u_pos        = strmatch('U',M_.endo_names,'exact');
v_pos        = strmatch('v',M_.endo_names,'exact');
n_pos        = strmatch('N',M_.endo_names,'exact');
pi_pos       = strmatch('ppi',M_.endo_names,'exact');
R_pos      	 = strmatch('R',M_.endo_names,'exact');
r_pos      	 = strmatch('r',M_.endo_names,'exact');
jf_pos       = strmatch('JF',M_.endo_names,'exact');
Z_pos        = strmatch('Z',M_.endo_names,'exact');
q_pos        = strmatch('q',M_.endo_names,'exact');
sigma_zt_pos = strmatch('sigma_zt',M_.endo_names,'exact');

IRF_periods=20;
burnin = 0;
% no effect of burnin because we set all the burnin periods with zero
% shocks until the first after that

shock_mat               = zeros(burnin+IRF_periods,M_.exo_nbr); 
IRF_no_shock_mat        = simult_(M_,options_,oo_.dr.ys,oo_.dr,shock_mat,options_.order)'; 
% oo_.steady_state or oo_.dr.ys for ergodic mean
shock_mat(1+burnin,strmatch('e_sigma_z',M_.exo_names,'exact')) = 1;
IRF_mat   = simult_(M_,options_,oo_.dr.ys,oo_.dr,shock_mat,options_.order)';

% IRF_mat_percent_from_SSS = (IRF_mat(1+burnin+1:1+burnin+IRF_periods,:)-IRF_no_shock_mat(1+burnin+1:1+burnin+IRF_periods,:))./...
%                             IRF_no_shock_mat(1+burnin+1:1+burnin+IRF_periods,:);

IRF_mat_percent_from_SSS = log(IRF_mat(1+burnin+1:1+burnin+IRF_periods,:)./IRF_no_shock_mat(1+burnin+1:1+burnin+IRF_periods,:));

%scale IRFs as reqired
y_vola_IRF 	  	  = 100*IRF_mat_percent_from_SSS(:,y_pos);
c_vola_IRF 	  	  = 100*IRF_mat_percent_from_SSS(:,c_pos);
u_vola_IRF 	      = 100*IRF_mat_percent_from_SSS(:,u_pos);
v_vola_IRF 	      = 100*IRF_mat_percent_from_SSS(:,v_pos);
n_vola_IRF 	      = 100*IRF_mat_percent_from_SSS(:,n_pos);
pi_vola_IRF 	  = 100*IRF_mat_percent_from_SSS(:,pi_pos);
R_vola_IRF 		  = 100*IRF_mat_percent_from_SSS(:,R_pos);
r_vola_IRF 		  = 100*IRF_mat_percent_from_SSS(:,r_pos);
jf_vola_IRF 	  = 100*IRF_mat_percent_from_SSS(:,jf_pos);
Z_vola_IRF 		  = 100*IRF_mat_percent_from_SSS(:,Z_pos);
q_vola_IRF 	      = 100*IRF_mat_percent_from_SSS(:,q_pos);
sigma_zt_vola_IRF = 100*IRF_mat_percent_from_SSS(:,sigma_zt_pos);

IRF = {'y_vola_IRF', 'c_vola_IRF','u_vola_IRF','v_vola_IRF','n_vola_IRF',...
       'pi_vola_IRF','R_vola_IRF','r_vola_IRF','jf_vola_IRF','Z_vola_IRF',...
       'q_vola_IRF','sigma_zt_vola_IRF'};

% pos = {'y_pos','c_pos','u_pos','v_pos','n_pos','pi_pos','R_pos','r_pos',...
%       'jf_pos','Z_pos','q_pos','sigma_zt_pos'};

titlename = {'Y','C','Unemp Rate U','Vacancies v','N','Inflation \pi',...
             'Nominal R','Real r','Match Value JF','Tech Z','Rela Price q','Uncert shock \sigma_{zt}'};

hh=figure;
sgtitle(strcat('Impulse Response with h = ',num2str(h),', \phi = ',num2str(pphi),' and \Omega_p = ', num2str(Omega_p)),'FontSize',16);
for i = 1:length(IRF)
    figure(hh)   
    subplot(4,3,i)
    hold on
    eval(['irf = ',IRF{i},';']);
    plot(irf,'b-','LineWidth',1.5)
    plot(zeros(IRF_periods,1),'k--','HandleVisibility','off'); xlim([1 IRF_periods]);set(gca,'XTick',[4:4:IRF_periods],'FontSize',12);
    title(titlename{i},'FontSize',14);
    if i > 8
    	xlabel('Quarters','FontSize',12);
    end 
    if mod(i,3) == 1
        ylabel('Percent','FontSize',12);
    end
    tick = (max(irf)-min(irf))/20;
    if tick ~= 0
        ylim([min([-tick;irf]) max([tick;irf])]);
    end
end

if kkappa == 0.01 && rrho == 0.90
    save IRF_low_search_friction u_vola_IRF;
elseif Omega_p == 0
    save IRF_flexible u_vola_IRF;
elseif h == 0.6
    save IRF_habit u_vola_IRF;
else
    save IRF_benchmark u_vola_IRF;
end
