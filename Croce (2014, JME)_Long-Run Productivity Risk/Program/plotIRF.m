%% Replication File of Croce(2014): Long_run Productivity Risk: A New Hope for Production Based Asset Pricing?
% Replication Author: Ding Xiangyu dingxiangyu01@pku.edu.cn
% Time: 2021-7-22 16:05:00

% Impluse Response Function(IRF)
%% Simuate The Model Using Dynare 用dynare++计算模型
dynare simulation_psi_2.mod;
save('oopsi2','oo_');

dynare simulation_psi_09.mod;
save('oopsi09','oo_');

load oopsi2.mat;
oo_psi_2 = oo_; 

load oopsi09.mat;
oo_psi_09 = oo_;


%% Plot the Impluse Response Function 
hh=figure;
figure(hh);

%------------------
subplot(7,2,1);
hold on;
plot([0,oo_psi_2.irfs.da_ea(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.da_ea(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);
ylabel('$\Delta a_t$','interpreter','latex');

subplot(7,2,2);
hold on;
plot([0,oo_psi_2.irfs.da_ex(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.da_ex(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);

%------------------
subplot(7,2,3);
hold on;
plot([0,oo_psi_2.irfs.dc_ea(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.dc_ea(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);
ylabel('$\Delta c_t$','interpreter','latex');

subplot(7,2,4);
hold on;
plot([0,oo_psi_2.irfs.dc_ex(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.dc_ex(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);

%------------------
subplot(7,2,5);
hold on;
plot([0,oo_psi_2.irfs.n_ea(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.n_ea(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);
ylabel('$\ln N_t$','interpreter','latex');

subplot(7,2,6);
hold on;
plot([0,oo_psi_2.irfs.n_ex(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.n_ex(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);

%------------------
subplot(7,2,7);
hold on;
plot([0,oo_psi_2.irfs.di_ea(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.di_ea(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);
ylabel('$\Delta i_t$','interpreter','latex');

subplot(7,2,8);
hold on;
plot([0,oo_psi_2.irfs.di_ex(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.di_ex(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);

%------------------
subplot(7,2,9);
hold on;
plot([0,oo_psi_2.irfs.m_ea(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.m_ea(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);
ylabel('$m_t$','interpreter','latex');

subplot(7,2,10);
hold on;
plot([0,oo_psi_2.irfs.m_ex(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.m_ex(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);

%------------------
subplot(7,2,11);
hold on;
plot([0,oo_psi_2.irfs.exr_ea(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.exr_ea(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);
ylabel('$r_{ex,t}$','interpreter','latex');

subplot(7,2,12);
hold on;
plot([0,oo_psi_2.irfs.exr_ex(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.exr_ex(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);

%------------------
subplot(7,2,13);
hold on;
plot([0,oo_psi_2.irfs.q_ea(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.q_ea(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);
ylabel('$q_t$','interpreter','latex');

subplot(7,2,14);
hold on;
plot([0,oo_psi_2.irfs.q_ex(1:14)],'b-','LineWidth',1.5) % IRF for IES = 2
plot([0,oo_psi_09.irfs.q_ex(1:14)],'r--','LineWidth',1.5) % IRF for IES = 0.9
plot(zeros(15,1),'k--','HandleVisibility','off'); xlim([1 15]);set(gca,'XTick',[4:4:15],'FontSize',12);
set(gca,'xtick',0:5:15);


