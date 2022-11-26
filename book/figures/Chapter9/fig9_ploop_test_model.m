bdclose all; close all; clear;

open_system("sl_ploop_test")
sim("sl_ploop_test")

%% Subfigure (b) - Full test harness
rvcprint("simulink", "sl_ploop_test", subfig="_b");

%% Subfigure (a) - Actual position control loop
rvcprint("simulink", "Joint ploop", subfig="_a")