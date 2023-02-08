%% Replication File of Croce(2014): Long_run Productivity Risk: A New Hope for Production Based Asset Pricing?
% Replication Author: Ding Xiangyu dingxiangyu01@pku.edu.cn
% Time: 2021-7-22 16:05:00

% Solved in dynare++

%% Endogenous Varaibles 内生变量

var 		
    
    x               $x_t$                   (long_name = 'Long-run Productivity Risk: x_t')
    
    % Detrended variables: 去趋势变量
    ya              ${ya}_t$                (long_name = 'Log Detrended Output: ln(Y_t/A_{t-1})')
    ca              ${ca}_t$                (long_name = 'Log Detrended Consumption: ln(C_t/A_{t-1})') 
    tca             $\tilde{ca}_t$          (long_name = 'Log Detrended Tilde Consumption: ln(\tilde{C}_t/A_{t-1})')
    ia              ${ia}_t$                (long_name = 'Log Detrended Investment: ln(I_t/A_{t-1})') 
    ka              ${ka}_t$                (long_name = 'Log Detrended Capital: ln(K_t/A_{t-1})') 
    
    % Log Variable Growth: 对数增长率
    dy              $\delta y_t$            (long_name = 'Log Output Growth: ln(Y_t/Y_{t-1})')
    da              $\delta a_t$            (long_name = 'Log Productivity Growth: ln(A_t/A_{t-1})') 
    dc              $\delta c_t$            (long_name = 'Log Consumption Growth: ln(C_t/C_{t-1})')
    dtc             $\delta \tilde{c}_t$    (long_name = 'Log Tilde Consumption Growth: ln(\tilde{C}_t/\tilde{C}_{t-1})')
    dtca            $\delta \tilde{ca}_t$   (long_name = 'Log Detrended Tilde Consumption Growth: ln(\tilde{ca}_t/\tilde{ca}_{t-1})')
    di              $\delta i_t$            (long_name = 'Log Investment Growth: ln(I_t/I_{t-1})')
    
    % Other Firm Related Varaibles 其他厂商变量
    uc              ${uc}_t$                (long_name = 'Log Utility Consumption Ratio: ln(U_t/\tilde{C}_t)')
    newk            $\tilde{i}_t$           (long_name = 'Log Efficient Capital Investment: ln(I_t/K_t-G_t)')
    G               $G_t$                   (long_name = 'Adjustment Cost: G(I_t/K_t)')
    GP              ${GP}_t$                (long_name = 'Adjustment Cost Derivative: dG(I_t/K_t)/d(I_t/K_t)')
    Q               $Q_t$                   (long_name = 'Expected Utility-Consumption Ratio: (E_t(U_{t+1})/ \tilde{C}_t)^{1-\gamma} ')
    logQ            ${logQ}_t$              (long_name = 'Log Expected Utility-Consumption Ratio: ln(Q_t) ')
    
    % Labor and Leisure 劳动和消费
    n               $n_t$                   (long_name = 'Log Labor: ln(N)')
    l               $l_t$                   (long_name = 'Log Leisure: ln(L)')
    
    % Stock Price and Dividend 股价与利率
    d               $d$                     (long_name = 'Log Dividend: ln(D_t)') 
    q               $q_t$                   (long_name = 'Log Tobin q: ln(q_t) ') 
    pd              ${pd}_t$                (long_name = 'Log Price to Dividend Ratio: ln(Q_t/D_t)') 
    
    % SDF, Rate 随机折现因子，利率
    m               $m_t$                   (long_name = 'Log SDF: ln(m_t)') 
    r               $r_t$                   (long_name = 'Log Capital Return: ln(R_t)')
    rf              $r_{f,t}$               (long_name = 'Log Risk Free Return: ln(R_{f,t})')
    exr             ${rp}_t$                (long_name = 'Risk Premium: r_t-rf_{t-1}')
    rlev            $r^{LEV}_{ex,t}$        (long_name = 'Leverged Risk Premium: \phi_{lev}*exr + ed');

    
%% Exogenous Varaibles 外生变量
varexo 		
    ea              $\epsilon_{x,t}$        (long_name = 'Short-run Productivity Shock')
    ex              $\epsilon_{x,t}$        (long_name = 'Long-run Productivity Shock')
    ed              $\epsilon_{d,t}$        (long_name = 'Excess Return Shock');       

%% Parameters 参数
parameters	
    % Adjustment Cost Paramaters 投资调整成本参数
    xi              $\xi$                   (long_name = 'Adjustment Cost Coefficient xi')
    a1              $\alpha_1$              (long_name = 'Adjustment Cost Coefficient 1')
    a0              $\alpha_0$              (long_name = 'Adjustment Cost Coefficient 0')
    
    
    % Production Paramaters 生产函数参数
    alpha           $\alpha$                (long_name = 'Production Function Exponent')
    beta            $\beta$                 (long_name = 'Subjective Discount Factor')
    delta           $\delta$                (long_name = 'Depreciation Rate of Capital')
    
    % Production Process Parameter 生产率过程参数
    mu              $\mu$                   (long_name = 'Long Run Mean of Productivity') 
    rho             $\rho$                  (long_name = 'Persistence of Long-run Shock') 
    
    % Preference Paramaters 偏好参数
    f               $\xi_l$                 (long_name = 'Consumption Labor Elasticity')
    varphi          $o$                     (long_name = 'Consumption Labor CES Weight')                   
    gam             $\gamma$                (long_name = 'Coefficient of Risk Aversion')
    psi             $\psi$                  (long_name = 'Intertemporal Elasticity of Substitution')
    theta           $\theta$                (long_name = 'Relative RES IES')
    
    % Leverge 杠杆
    philev          $\phi_{LEV}$            (long_name = 'Leverge Ratio')
    
    % Key Steady State Paramaters (Other Steady State See initval) 关键稳态值(其他稳态值根据本部分在initval部分计算)
    Gbar           $\bar_{G}$               (long_name = 'Steady State Adjustment Cost')     
    kbar            $\bar_{k}$              (long_name = 'Steady State Log Detrended Capital')    
    ybar            $\bar_{y}$              (long_name = 'Steady State Log Detrended Output')
    ibar            $\bar_{i}$              (long_name = 'Steady State Log Detrended Investment')
    Nbar            $\bar_{N}$              (long_name = 'Steady State Labor')
    ucbar           $\bar_{uc}$             (long_name = 'Steady State Log Utility Consumption Ratio');
    
    % 
    alpha     = 0.34;                           % Production Function Exponent 生产函数弹性(Capital Share =0.34; See Table 3 Panel A)
    beta      = 0.95^(1/12);                    % Subjective Discount Factor 效用折现率(Beta^12 = 0.95; See Table 3 Panel A)
    delta     = 0.06/12;                        % Depreciation Rate of Capital 折旧(12*delta =0.06; See Table 3 Panel A)
    f         = 1;                              % Consumption-labor Elasticity \xi_l = 1 劳动消费弹性 (Therefore CD Consumption-labor Aggregation Function; See Table 3 Panel A)
    gam       = 10;                             % Risk Aversion 风险厌恶系数(Risk Aversion Coefficient \gamma =10; See Table 3 Panel A)
    mu        = 1.8/100/12;                     % Long Run Mean of Productivity 长期生产率增长均值 (12*\mu=1.8%; See Table 3 Panel A)
    Nbar      = 0.18;                           % Steady State Time Worked 稳态劳动占总时间比(See P.9 Line 333)
    psi       = 2;                            % Intertemporal Elasticity of Substitution 跨期替代弹性(\psi = 2 or 0.9; See Table 3)
    rho       = 0.8^(1/12);                     % Persistence of Long Run Risk (\rho^12 = 0.8; See Table 3 Panel A)
    theta     = (1-1/psi)/(1-gam);              % Relative RES IES \theta = (1-1/psi)/(1-gam)
    philev    = 2;                              % Leverge 杠杆率 (\phi_{LEV}=2; See P19, Line 345)       
    varphi    = 0.204786351767522;              % Consumption-leisure CES weight 消费消遣CES权重(Follow the Original Code)
    
    
    % Key Steady State Variables 关键稳态值
    Gbar     = 0;                               
        % G steady state 稳态调整成本 (Gbar=0; See P 17. Line 302)
        
	kbar   = log((alpha/(exp(mu/psi)/beta-1+delta+Gbar))^(1/(1-alpha)))+mu+log(Nbar);       
        % Steady State Detrend k 稳态对数去趋势资本存量 
        % (From Consumption Euler Equation: 由跨期消费欧拉函数计算)
        
    ybar   = (mu + log(Nbar))*(1-alpha) + kbar*alpha;
        % Steady State Detrend y 稳态对数去趋势产出
        % (From Production Function based on kbar 基于稳态资本计算)
        
    ibar   = log(exp(kbar)*(exp(mu)+delta-1));                                              
        % Steady State Detrend i 稳态对数去趋势投资
        % (From Capital Dynamic Function 由资本动态函数计算)
        
    ucbar  = log(((1-beta)/(1-beta*exp((1-1/psi)*mu)))^(psi/(psi-1)));
        % Steady State Steady State Log Utility Consumption Ratio 稳态效用消费比
        % (Combine Utility Function and Consumption Leisure Aggregator 结合EZ效用函数和消费休闲加总函数)
    
    % Adjustment Cost Parameters 调整成本参数
    xi        = 7;                              % Adjustment Cost Coefficient \xi 调整成本弹性参数 (\xi = 7;See Table 3 Panel A)
    a1        = 1/(exp((kbar-ibar)/xi));        
        % Adjustment Cost Coefficent \alpha_1 调整成本常数alpha_1 (Calibration using G'(I/K)=0 at Steady State)
        
    a0        = exp(ibar-kbar) - (a1/(1-1/xi))*exp((ibar-kbar)*(1-1/xi)); 
        % Adjustment Cost Coefficent \alpha_0 调整成本常数alpha_0 (Calibration using G(I/K)=0 at Steady State)

%% Model 模型
model;

%-------------------------------
% Equation 1-2: Productivity 

    % Equation 1: Process of Productivity
		da = mu+x(-1)+ea;
        
    % Equation 2: Process of Long Run Risk
		x  = rho*x(-1)+ex;

%-------------------------------
% Equation 3-6: Utility  

    % Equation 3: Expected Utility-consumption Ratio
		Q 				  = exp((uc(+1)+dtc(+1))*(1-gam));
        
    % Equation 4: Log Expected Utility-consumption Ratio:
		logQ 			  = log(Q);
        
    % Equation 5: Utility Function:
		exp((1-1/psi)*uc) = (1-beta)+beta*(Q^theta);
        
    % Equation 6: Consumption Leisure Aggregation
        tca     = varphi*ca+(1-varphi)*(l);
        
%-------------------------------
% Equation 7-9: Production  

    % Equation 7: Production Function
		exp(ya) = exp(alpha*ka)*exp((da+n)*(1-alpha));

    % Equation 8: Resources Constraint
		exp(ya) = exp(ca)+exp(ia);
        
    % Equation 9 : Time Constraint
       1 = exp(n)+exp(l);

%-------------------------------
% Equation 10-13: Investment  

    % Equation 10: Effective Investment
        exp(newk)      = exp(ia-ka)-G;

    % Equation 11: Capital Dynamics
		exp(ka+da(-1)) = (1-delta + exp(newk(-1)))*exp(ka(-1)); 

    % Equation 12: Adjustment Cost
        G 	           = exp(ia-ka)-((a1/(1-1/xi))*exp((ia-ka)*(1-1/xi)) + a0);
        
    % Equation 13: Adjustment Cost Derivative
		GP 	           = 1-a1*exp((ka-ia)/xi);
        
%-------------------------------
% Equation 14-23: SDF, Equilibrium Condition and Returns

    % Equation 14: Stochastic Discount Factor
        exp(m)            = beta*exp(dc*(-1/f))*exp(dtc*(1/f-1/psi))*exp((uc+dtc)*(1/psi-gam))/exp(logQ(-1)*(1-theta));

    % Equation 15: Labor Maket Equilibrium Condition 
        (1-alpha)*exp(ya-n)  = (1/varphi-1)*exp((1/f)*(ca-l));

    % Equation 16: Log Dividend
		exp(d) 	  = alpha*exp(ya-ka) + (exp(newk) - delta)*exp(q) - exp(ia-ka);

    % Equation 17: Capital Maket Equilibrium Condition 
		exp(q) 	  = 1/(1-GP);

    % Equation 18: Log Price to Dividend Ratio
		pd 		  = q-d;

    % Equation 19: Log Market Capital Return
		exp(r)    = (exp(q)+exp(d))/exp(q(-1));

    % Equation 20: Fundamental Theorem of Asset Pricing
		1 		  = exp(r(+1)+m(+1));

    % Equation 21: Risk Free Return
		1/exp(rf) = exp(m(+1));

    % Equation 22: Risk Premium
		exr 	  = r-rf(-1);

    % Equation 23: Leveraged Risk Premium
        rlev      = philev*exr + ed;
 
%-------------------------------
% Equation 24-28: Definition of Growth Rate
    % Equation 24: Definition of Log Output Growth
		dy   = ya-ya(-1)+da(-1);
        
    % Equation 25: Definition of Detrended Log Tilde Consumption Growth
        dtca = tca-tca(-1);
    
    % Equation 26: Definition of Log Tilde Consumption Growth
        dtc  = dtca+da(-1);
    
    % Equation 27: Definition of Log Consumption Growth
		dc   = ca-ca(-1)+da(-1);
        
    % Equation 28: Definition of Log Investment Growth
		di   = ia-ia(-1)+da(-1);
end; 

%% Initital Value 稳态初值变量
initval;
	x    = 0;
	da   = mu;
	dy   = mu;
	dc   = mu;
   dtc  = mu;
   dtca = 0;
   n    = log(Nbar);
	di   = mu;
	uc   = ucbar;
	m    = log(beta)-mu/psi;
	Q    = exp((uc+mu)*(1-gam));
	logQ = log(Q);
	G    = 0;
	GP   = 0;
	ka   = kbar;
	ia   = ibar;
	ya   = ybar;
	ca   = log(exp(ya)-exp(ia));
   l    = log(1-Nbar);
   tca     = varphi*ca+(1-varphi)*(l);
	q    = 0;
	q    = 0;
	d    = log(alpha*exp(ya-ka)-delta-G);
    newk = ia-ka;
	pd   = q-d;
	r    = -m;
	rf   = r;
	exr  = 0;
    rlev = 0;
end; 

%% Calculate Steady State 计算稳态
steady;

%% 
shocks;
var ea = 0.0335^2/12;            %Short Run Productivity Shock Variance: sqrt(var ea*12)=3.35% (See Table 3; Panel A)
var ex = (0.0335^2/12)*0.01;     %Long Run Productivity Shock Variance:  std ex = std ea * 0.1 (See Table 3; Panel A)
var ed = 0.065^2/12;             %Excess Return Shock Variance: std ed * sqrt(12) = 6.5% (See P.19; Line 340)
end;

%% Stochastic Simulation 随机模拟
stoch_simul(order=2,periods=840,irf=15,nograph,pruning) da dc n di m exr q;
% order = 2: Second order approximation 
% periods = 840: simulate the model for 840 month
% irf = 15: Plot 15 month inpulse response function 
% pruning: exclude extreme values
