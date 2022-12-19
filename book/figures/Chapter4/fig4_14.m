bdclose all; close all; clear;

sl_drivepose
xg = [5 5 pi/2];
x0 = [8 5 pi/2];
sim("sl_drivepose")
rvcprint("simulink", "sl_drivepose")