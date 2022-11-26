bdclose all; clear;
close all; clear;

sl_vloop_test
sim("sl_vloop_test")
rvcprint("simulink", "sl_vloop_test");