%%%% Replication File of Croce(2014): Long_run Productivity Risk: A New Hope for Production Based Asset Pricing?
% Replication Author: Ding Xiangyu dingxiangyu01@pku.edu.cn
% Time: 2021-7-22 16:05:00 

% Main Replication File

clear;
%% Replication of Table 3
    
run moments_psi_2; % Moment_psi_2.xls store result of IES = 2 (Table 3, Panel B Column 2)
run moments_psi_09; % Moment_psi_09.xls store result of IES = 0.9 (Table 3, Panel B Column 3)
run moments_no_lrr; % Moment_no_lrr.xls store result of No Long-run Risk (Table 3, Panel B Column 4)


%% Replication of Figure 2

run plotIRF % Plot the Impluse Response Function

