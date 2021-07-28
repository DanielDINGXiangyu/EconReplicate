%% Replicate code for the Liu et al. (2021, AEJ Macro): Static Model
% Replicator: DING Xiangyu 
% This replication is based on the original code provided by Liu et al.(2021)
% See https://www.aeaweb.org/articles?id=10.1257/mac.20180045 for reference

%% Parameters Setup
zs   = .01; % Aggregate component of productivity in SOE sector
zp   = .02; % Aggregate component of productivity in POE sector
Ee   = 1;   % Mean of lognormal distribution
sig  = .3;  % Standard deviation of log-normal distribution
b    = 2;   % SOE has greater borrowing capacity
tau  = 2;   % Subsidy parameter for SOE
mu   = .5;  % Measure of SOE
theta_vec = 0.2:0.1:0.4; % Vector of theta
phi_vec   = 0:.0005:.01;    % Interest rate wedge parameter (x axis of the Figure 1)
rini      = .02;            % Initial guess of equilibrium interest rate


%% Compute output in two policy regimes: before and after liberalization

% The first loop loop along all the theta
for jj = 1:length(theta_vec)
    theta = theta_vec(jj);
    
    % For each value of theta, iterate along each phi
    for j=1:length(phi_vec)
        phi0 = phi_vec(j);
        ParaSet0 =[zs zp sig b tau mu theta phi0 Ee]';
        rlow = 0;  rupp = .2;
        
        % Solve equilibrium interest rate r0 which is the number that clear slove equation (1.9) 
        [r0, fval] = fminbnd(@(x)RepFun_SolveR(x,ParaSet0),rlow,rupp,optimset('TolX',1e-8,'Display','off'));
        
        % Given the equilibirum interest rate r0 solve the output, TFP, etc.  
        [Ys,Yp,Y,Ks,Kp,As,Ap,ep_l,es_l]=RepFun_SolveY(r0,ParaSet0);
        Yvec(jj,j) =Y;
        Avec(jj,j) =Y/(Ks+Kp);
    end
end

%% plot relationship between aggregate output and phi
figure(1)
for jj=1:length(theta_vec)
    plot(phi_vec,Yvec(jj,:),'color',[.2 .2 .2],'LineWidth',3);hold on
end
ylabel('Aggregate Output')
xlabel('Interest Rate Control (\phi)')

%% plot relationship between aggregate TFP and phi
figure(2)
for jj=1:length(theta_vec)
    plot(phi_vec,Avec(jj,:),'color',[.2 .2 .2],'LineWidth',3);hold on
end

ylabel('Aggregate TFP')
xlabel('Interest Rate Control (\phi)')