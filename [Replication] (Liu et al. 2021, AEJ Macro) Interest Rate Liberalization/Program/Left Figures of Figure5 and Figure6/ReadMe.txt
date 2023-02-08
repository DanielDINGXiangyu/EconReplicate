ReadMe: codes for counterfactual analysis: reducing SOE subsidies, replicates left columns in Figure 5 and Figure 6

1. RunTransition_tau.m computes the transition dynamics

2. RunPlotFig.m plots transition dynamics. Replicate left column in Figure 5

3. RunComputeWelfare.m compute the welfare implication of liberalization under different interest rate wedge \phi, replicates left panel in Figure 6

4. External functions: 
  a. Fun_ek, Fun_g define partial expectations
  b. TransPath_DRS_Tau.mod dynare file for transition dynamics
  c. SolveAllSteadyState_SOE_Heter.m and SolveSteadyState_SOE_Heter.m, solve steady states
  d. fminsearchbnd, optimizer
  e. CaliParaSet.mat contains parameter values after calibration.
