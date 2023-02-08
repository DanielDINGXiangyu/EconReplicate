% Author: DING Xiangyu (dingxiangyu@pku.edu.cn)
% Function gives absolute value of RHS-LHS in equation (1.9)
% [res] = RepFun_SolveR(r, ParaSet)
% Output: res is the absolute value of RHS-LHS in equation (1.9)
% Input: ParaSet is a set of the parameter used set in RepRunOptimalPhi.m

function [res] = RepFun_SolveR(r, ParaSet)

% Define the input value in the ParaSet
zs   = ParaSet(1);
zp   = ParaSet(2);
sig  = ParaSet(3);
b    = ParaSet(4);
tau  = ParaSet(5);
mu   = ParaSet(6);
theta= ParaSet(7);
phi  = ParaSet(8);
Ee   = ParaSet(9);

% Compute the cutoff value of three types of firms in p(POE) and s(SOE)
% sectors using equation (1.19) and (1.20)

% POE
ep_h = ((r+phi)/zp);
ep_l = (r/zp);
% SOE
es_h = ((r+phi)/tau/zs);
es_l = (r/tau/zs);

% Compute the integral component of (1.22)

% POE
Fp_h = RepFun_g_through_int(0,ep_h,Ee,sig);
Fp_l = RepFun_g_through_int(0,ep_l,Ee,sig);
% SOE
Fs_h = RepFun_g_through_int(0,es_h,Ee,sig);
Fs_l = RepFun_g_through_int(0,es_l,Ee,sig);

% Aggregate all the component of (1.22) and get total capital demand in the
% economy
Ks = mu*(Fs_l+b*theta*Fs_h);
Kp = (1-mu)*(Fp_l+theta*Fp_h);

% RHS(rd) - LHS(rd) of market clearing condition (1.22) and then take
res = Ks+Kp-1;

% Take absolute value |RHS(rd) - LHS(rd)|
res = abs(res);

end

