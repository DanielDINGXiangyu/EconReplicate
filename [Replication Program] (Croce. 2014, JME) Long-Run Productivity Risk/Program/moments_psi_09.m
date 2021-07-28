%%%% Replication File of Croce(2014): Long_run Productivity Risk: A New Hope for Production Based Asset Pricing?
% Replication Author: Ding Xiangyu dingxiangyu01@pku.edu.cn
% Time: 2021-7-22 16:05:00 

% Calculate the Moments and Plot The IRF


clear;
%% Siumlate the model for 100 Times

dynare simulation_psi_09.mod
% Find the location of variables
dy_pos      	 = strmatch('dy',M_.endo_names,'exact');
dc_pos      	 = strmatch('dc',M_.endo_names,'exact');
di_pos           = strmatch('di',M_.endo_names,'exact');
ia_pos      	 = strmatch('ia',M_.endo_names,'exact');
ya_pos           = strmatch('ya',M_.endo_names,'exact');
rlev_pos         = strmatch('rlev',M_.endo_names,'exact');
q_pos      	     = strmatch('q',M_.endo_names,'exact');
rf_pos           = strmatch('rf',M_.endo_names,'exact');

% Initialize seven matrix to save annualized number
    % 100 rows for 100 simulation 
    % 70 columns for 70 years or 840 month
    % See Table 3: the author conduct 840 months simulation for 100 times

simnum = 100; % Simulate 100 different path of economy

annual_dy = zeros(simnum,70);
annual_dc = zeros(simnum,70);
annual_di = zeros(simnum,70);
annual_iyRatio = zeros(simnum,70);
annual_rlev = zeros(simnum,70);
annual_q  = zeros(simnum,70);
annual_rf = zeros(simnum,70);

for jj=1:simnum
    % Random shock generator
    Ea_rand = normrnd(0,sqrt(0.0335^2/12),[840,1]);
    Ex_rand = normrnd(0,sqrt(0.0335^2/12*0.01),[840,1]);
    Ed_rand = normrnd(0,sqrt(0.065^2/12),[840,1]);

    Mat_rand = [Ea_rand, Ex_rand, Ed_rand];

    % Dynare Simulation
    Shock_origin_mat = simult_(M_,options_,oo_.dr.ys,oo_.dr,Mat_rand,options_.order)'; 

    dy_array = Shock_origin_mat(2:841,dy_pos);
    dy_matrix = reshape(dy_array,12,70);
    annual_dy(jj,:) = sum(dy_matrix); % Annualized dy: sum of 12 months

    dc_array = Shock_origin_mat(2:841,dc_pos);
    dc_matrix = reshape(dc_array,12,70);
    annual_dc(jj,:) = sum(dc_matrix); % Annualized dc: sum of 12 months

    di_array = Shock_origin_mat(2:841,di_pos);
    di_matrix = reshape(di_array,12,70); 
    annual_di(jj,:) = sum(di_matrix); % Annualized di: sum of 12 months

    iy_array = Shock_origin_mat(2:841,ia_pos)-Shock_origin_mat(2:841,ya_pos);
    iy_matrix = reshape(iy_array,12,70); 
    annual_iyRatio(jj,:) = mean(exp(iy_matrix)); % Annualized investment ratio: average of 12 months

    rlev_array = Shock_origin_mat(2:841,rlev_pos);
    rlev_matrix = reshape(rlev_array,12,70); 
    annual_rlev(jj,:) = sum(rlev_matrix); % Annualized rlev: sum of 12 months

    q_array = Shock_origin_mat(2:841,q_pos);
    q_matrix = reshape(q_array,12,70); 
    annual_q(jj,:) = mean(q_matrix); % Annualized q: average of 12 months

    rf_array = Shock_origin_mat(2:841,rf_pos);
    rf_matrix = reshape(rf_array,12,70); 
    annual_rf(jj,:) = sum(rf_matrix); % Annualized rf: sum of 12 months
end

%% Calculate Each Result
result_std_dy = 100*mean(std(annual_dy,0,2)); % Standard Deviation (Std) of dy
result_std_dcdy = mean(std(annual_dc,0,2))/mean(std(annual_dy,0,2)); % Std of dc/ Std of dy
result_std_didy = mean(std(annual_di,0,2))/mean(std(annual_dy,0,2)); % Std of di/ Std of dy
result_mean_IY = 100*mean(annual_iyRatio,'all'); % Mean of Investment/Output

% Correlation Coefficient (Corr) of dc and di;
sample_corr_dcdi = zeros(simnum,1);
for ii=1:simnum
    corr_matrix = corrcoef(annual_dc(ii,:)',annual_di(ii,:)');
    sample_corr_dcdi(ii,1) = corr_matrix(1,2);
end
result_corr_dcdi = mean(sample_corr_dcdi); 

% Correlation Coefficient (Corr) of dc and rlev;
sample_corr_dcrlev = zeros(simnum,1);
for ii=1:simnum
    corr_matrix = corrcoef(annual_dc(ii,:)',annual_rlev(ii,:)');
    sample_corr_dcrlev(ii,1) = corr_matrix(1,2);
end
result_corr_dcrlev = mean(sample_corr_dcrlev); 

result_mean_rlev = 100*mean(annual_rlev,'all');
result_std_rlev = 100*mean(std(annual_rlev,0,2));
result_std_q = mean(std(annual_q,0,2));
result_mean_rf = 100*mean(annual_rf,'all');
result_std_rf = 100*mean(std(annual_rf,0,2));

sample_acf_rlev = zeros(simnum,1);
for ii=1:simnum
    corr_matrix = corrcoef(annual_rlev(ii,1:69)',annual_rlev(ii,2:70)');
    sample_acf_rlev(ii,1) = corr_matrix(1,2);
end
result_acf_rlev = mean(sample_acf_rlev); 


sample_acf_rf = zeros(simnum,1);
for ii=1:simnum
    corr_matrix = corrcoef(annual_rf(ii,1:69)',annual_rf(ii,2:70)');
    sample_acf_rf(ii,1) = corr_matrix(1,2);
end
result_acf_rf = mean(sample_acf_rf); 

sample_acf_q = zeros(simnum,1);
for ii=1:simnum
    corr_matrix = corrcoef(annual_q(ii,1:69)',annual_q(ii,2:70)');
    sample_acf_q(ii,1) = corr_matrix(1,2);
end
result_acf_q = mean(sample_acf_q); 

sample_acf_dc = zeros(simnum,1);
for ii=1:simnum
    corr_matrix = corrcoef(annual_dc(ii,1:69)',annual_dc(ii,2:70)');
    sample_acf_dc(ii,1) = corr_matrix(1,2);
end
result_acf_dc = mean(sample_acf_dc); 

result_name = {'std_dy', 'std_dcdy', 'std_didy', 'mean_IY', 'corr_dcdi',...
    'corr_dcrlev', 'mean_rlev', 'std_rlev', 'std_q', 'mean_rf',...
    'std_rf', 'acf_rlev', 'acf_rf', 'acf_q', 'acf_dc'}';

result_value = {result_std_dy, result_std_dcdy, result_std_didy, result_mean_IY, result_corr_dcdi,...
    result_corr_dcrlev, result_mean_rlev, result_std_rlev, result_std_q, result_mean_rf,...
    result_std_rf, result_acf_rlev, result_acf_rf, result_acf_q, result_acf_dc}';

% Write the moments into a xls file
xlswrite('Moment_psi_09.xls',[result_name,result_value])