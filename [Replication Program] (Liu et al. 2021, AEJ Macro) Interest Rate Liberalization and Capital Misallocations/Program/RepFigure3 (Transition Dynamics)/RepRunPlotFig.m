%% plot transition path
phit  = [phi0; ones(1499,1)*phi1]; % interest rate control path
T=39;

subplot(4,2,1)
plot(-4:T-4,[rs_0*ones(5,1);rst(1:T-4)],'LineWidth',1,'color',[.2 .2 .2]);grid on; hold on
plot(-4:T-4,[(rs_0+phi0)*ones(5,1);rst(1:T-4)+phit(1:T-4)],'--','LineWidth',1,'color',[.2 .2 .2]);grid on; hold on
legend('Deposit','Loan')
title('Interest rates')
xlim([-4,T-4]);
ylim([0,0.06])

subplot(4,2,2)
plot(-4:T-4,[(Ks_0/K_0)*ones(5,1);Kst(1:T-4)./Kt(1:T-4)],'b-','LineWidth',1,'color',[.2 .2 .2]);grid on; hold on
title('SOE capital share')
xlim([-4,T-4]);
ylim([0.645 0.67])

subplot(4,2,3)
plot(-4:T-4,[As_0*ones(5,1);Ast(1:T-4)],'b-','LineWidth',1,'color',[.2 .2 .2]);grid on; hold on
title('SOE sector TFP')
xlim([-4,T-4]);
ylim([1.02 1.024])

subplot(4,2,4)
plot(-4:T-4,[Ap_0*ones(5,1);Apt(1:T-4)],'b-','LineWidth',1,'color',[.2 .2 .2]);grid on; hold on
title('POE sector TFP')
xlim([-4,T-4]);
ylim([1.35 1.365])

subplot(4,2,5)
plot(-4:T-4,[A_0*ones(5,1);At(1:T-4)],'LineWidth',1,'color',[.2 .2 .2]);grid on; hold on
title('Aggregate TFP')
xlim([-4,T-4]);
ylim([1.263 1.268])

subplot(4,2,6)
plot(-4:T-4,[Y_0*ones(5,1);Yt(1:T-4)],'LineWidth',1,'color',[.2 .2 .2]);grid on; hold on
title('Aggregate output')
xlim([-4,T-4]);
ylim([3.875 4])

subplot(4,2,7)
plot(-4:T-4,[W_0*ones(5,1);Wt(1:T-4)],'LineWidth',1,'color',[.2 .2 .2]);grid on; hold on
title('Wage rate')
xlim([-4,T-4]);
ylim([2.05 2.15])

subplot(4,2,8)
plot(-4:T-4,[C_0*ones(5,1);Ct(1:T-4)],'LineWidth',1,'color',[.2 .2 .2]);grid on; hold on
title('Consumption')
xlim([-4,T-4]);
ylim([2.38 2.55])

