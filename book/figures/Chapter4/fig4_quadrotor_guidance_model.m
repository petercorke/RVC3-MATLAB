bdclose all; close all; clear;

sl_quadrotor_guidance
mdl_quadrotor

sim("sl_quadrotor_guidance");
rvcprint("simulink", "sl_quadrotor_guidance")
