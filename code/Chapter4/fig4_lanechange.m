bdclose all; close all; clear;

% Open Simulink model and simulate it
sl_lanechange
sim("sl_lanechange")

% Create PDF figure for model
rvcprint("simulink", "sl_lanechange")
