% Author: DING Xiangyu (dingxiangyu@pku.edu.cn)
% Function gives calculate the aggregate output, capital, TFP, and cutoff
% [Ys,Yp,Y,Ks,Kp,As,Ap,ep_l,es_l]=Fun_SolveY(r,ParaSet)
% Input: 
%       r is the market clearing rate of deposit
%       ParaSet is a set of the parameter used set in RepRunOptimalPhi.m
% Output: 
%       Ys,Yp,Y are outputs;
%       Ks,Kp are capital;
%       As,Ap are TFP;
%       ep_l,es_l are production cutoff 


function [Ys,Yp,Y,Ks,Kp,As,Ap,ep_l,es_l]=Fun_SolveY(r,ParaSet)

zs   = ParaSet(1);
zp   = ParaSet(2);
sig  = ParaSet(3);
b    = ParaSet(4);
tau  = ParaSet(5);
mu   = ParaSet(6);
theta= ParaSet(7);
phi  = ParaSet(8);
Ee   = ParaSet(9);

% Calculate the cutoff value of productivity of lending and borrowing
ep_h = ((r+phi)/zp);
ep_l = (r/zp);
es_h = ((r+phi)/tau/zs);
es_l = (r/tau/zs);

% Calculate the integral in numerator of (1.24)
Fp_h = RepFun_g_through_int(0,ep_h,Ee,sig);
Fp_l = RepFun_g_through_int(0,ep_l,Ee,sig);
Fs_h = RepFun_g_through_int(0,es_h,Ee,sig);
Fs_l = RepFun_g_through_int(0,es_l,Ee,sig);

% Calculate the integral in denominator of (1.24)
Ep_h = RepFun_g_through_int(1,ep_h,Ee,sig);
Ep_l = RepFun_g_through_int(1,ep_l,Ee,sig);
Es_h = RepFun_g_through_int(1,es_h,Ee,sig);
Es_l = RepFun_g_through_int(1,es_l,Ee,sig);

% Calculate aggregate output
Ys = mu*(Es_l+b*theta*Es_h)*zs;
Yp = (1-mu)*(Ep_l+theta*Ep_h)*zp;
Y  = Ys+Yp;

% Sector specific capital using equation (1.22)
Ks = mu*(Fs_l+b*theta*Fs_h);
Kp = (1-mu)*(Fp_l+theta*Fp_h);

% Calculate TFP using (1.24)
As = Ys/Ks;
Ap = Yp/Kp;
