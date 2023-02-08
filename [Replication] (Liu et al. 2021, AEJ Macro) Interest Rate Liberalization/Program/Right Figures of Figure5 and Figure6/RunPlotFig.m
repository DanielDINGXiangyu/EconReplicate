%% plot transition path
phit  = [phi0; ones(1499,1)*phi1]; % interest rate control path
T=39;

subplot(3,2,2)
plot(-4:T-4,[(Ks_0/K_0)*ones(5,1);Kst(1:T-4)./Kt(1:T-4)],'b-','LineWidth',3,'color',[.2 .2 .2]);grid on; hold on
%title('SOE Capital Share: K_{s}/K','FontSize',12)
title('Equal credit access (\theta^s=\theta^p)')
xlim([-4,T-4]);
ylim([0.635 0.645])

subplot(3,2,4)
plot(-4:T-4,[A_0*ones(5,1);At(1:T-4)],'LineWidth',3,'color',[.2 .2 .2]);grid on; hold on
%title('TFP: Aggregate','FontSize',12)
xlim([-4,T-4]);
ylim([1.272 1.282])
subplot(3,2,6)
plot(-4:T-4,[Y_0*ones(5,1);Yt(1:T-4)],'LineWidth',3,'color',[.2 .2 .2]);grid on; hold on
%title('Aggregate Output','FontSize',12)
xlim([-4,T-4]);
ylim([3.9 4.1])

% set(gcf,'PaperPositionMode','auto')
% print('Figure_Bench','-depsc2')
