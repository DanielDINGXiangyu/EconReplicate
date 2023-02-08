function [ek]=Fun_ek(e,kk)

ek = min(e^(-kk),1e3);