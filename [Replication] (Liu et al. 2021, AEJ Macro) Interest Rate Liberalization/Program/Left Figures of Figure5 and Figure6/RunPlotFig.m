%% plot transition path
phit  = [phi0; ones(1499,1)*phi1]; % interest rate control path
T=39;

subplot(3,2,1)
plot(-4:T-4,[(Ks_0/K_0)*ones(5,1);Kst(1:T-4)./Kt(1:T-4)],'b-','LineWidth',3,'color',[.2 .2 .2]);grid on; hold on
title('No subsidies to SOE')
ylabel('SOE capital share')
xlim([-4,T-4]);
ylim([0.14 0.155])

subplot(3,2,3)
plot(-4:T-4,[A_0*ones(5,1);At(1:T-4)],'LineWidth',3,'color',[.2 .2 .2]);grid on; hold on
ylabel('Aggregate TFP')
xlim([-4,T-4]);
ylim([1.375 1.38])

subplot(3,2,5)
plot(-4:T-4,[Y_0*ones(5,1);Yt(1:T-4)],'LineWidth',3,'color',[.2 .2 .2]);grid on; hold on
ylabel('Aggregate output')
xlim([-4,T-4]);
ylim([3.83 3.95])

% set(gcf,'PaperPositionMode','auto')
% print('Figure_Bench','-depsc2')
