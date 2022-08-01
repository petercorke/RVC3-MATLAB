bdclose all; close all; clear;

sl_driveline

% Line parameters
L = [1 -2 4];

% Start pose
x0 = [2 5 pi/2];

% Simulate model and save as PDF
sim("sl_driveline")
rvcprint("simulink", "sl_driveline")