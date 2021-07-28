%% Replicate Fig 6 of Leduc and Liu (2016)
u_vola_IRF_benchmark = load('IRF_benchmark.mat').u_vola_IRF;
u_vola_IRF_flexible = load('IRF_flexible.mat').u_vola_IRF;
u_vola_IRF_habit = load('IRF_habit.mat').u_vola_IRF;
u_vola_IRF_low_search_friction = load('IRF_low_search_friction.mat').u_vola_IRF;
t = 1:length(u_vola_IRF_benchmark);
plot(t,u_vola_IRF_habit);
hold on;
plot(t,u_vola_IRF_benchmark);
plot(t,u_vola_IRF_low_search_friction);
plot(t,u_vola_IRF_flexible);
legend(["Habit","Benchmark","Low Search Frictions","Flex Price"]);
plot(zeros(length(u_vola_IRF_benchmark),1),'k--','HandleVisibility','off');