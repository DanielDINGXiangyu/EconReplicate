function [P_Rouw, z_Rouw] = rouwen(rho_Rouw, mu_uncond, sig_uncond, n_R)
% Rouwenhorst Method of Approximation AR(1)
% DING Xiangyu (1901212474@pku.edu.cn)
% 
% Input:
%       rho_Rouw: persistent parameter 
%       mu_uncond: unconditional mean
%       sig_uncond: unconditional std 
%       n_R: number of grid
% Output:
%       P_Rouw: transition matrix
%       z_Rouw: grid point

% setup grid
step_R = sig_uncond*sqrt(n_R - 1); 
z_Rouw=[-1:2/(n_R-1):1]';
z_Rouw=mu_uncond+step_R*z_Rouw;

% transition matrix
p=(rho_Rouw + 1)/2;
q=p;

P_Rouw=[ p  (1-p);
        (1-q) q];
    
    for i_R=2:n_R-1
    a1R=[P_Rouw zeros(i_R, 1); zeros(1, i_R+1)];
    a2R=[zeros(i_R, 1) P_Rouw; zeros(1, i_R+1)];
    a3R=[zeros(1,i_R+1); P_Rouw zeros(i_R,1)];
    a4R=[zeros(1,i_R+1); zeros(i_R,1) P_Rouw];
    P_Rouw=p*a1R+(1-p)*a2R+(1-q)*a3R+q*a4R;
    P_Rouw(2:i_R, :) = P_Rouw(2:i_R, :)/2;
    end
    
P_Rouw=P_Rouw';

for i_R = 1:n_R
    P_Rouw(:,i_R) = P_Rouw(:,i_R)/sum(P_Rouw(:,i_R));
end
