close all; bdclose all; clear;

sl_computed_torque;
set_param(gcs, "SimulationCommand", "update");
rvcprint("simulink", "sl_computed_torque");