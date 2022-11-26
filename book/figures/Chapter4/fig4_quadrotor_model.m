bdclose all; close all; clear;

sl_quadrotor
mdl_quadrotor

sim("sl_quadrotor");
rvcprint("simulink", "sl_quadrotor")
