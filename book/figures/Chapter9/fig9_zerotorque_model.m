close all; bdclose all; clear;

sl_zerotorque;
sim("sl_zerotorque");
rvcprint("simulink", "sl_zerotorque");