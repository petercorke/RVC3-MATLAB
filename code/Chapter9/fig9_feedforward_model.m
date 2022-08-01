close all; bdclose all; clear;

sl_feedforward;
set_param(gcs, "SimulationCommand", "update");
rvcprint("simulink", "sl_feedforward");