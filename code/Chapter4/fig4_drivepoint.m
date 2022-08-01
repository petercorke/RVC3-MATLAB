bdclose all; close all; clear;

sl_drivepoint

% Goal point
xg = [5 5];

% Start point
x0 = [8 5 pi/2];

% Simulate model and save figure
sim("sl_drivepoint")
rvcprint("simulink", "sl_drivepoint")