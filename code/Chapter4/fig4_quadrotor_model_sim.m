bdclose all; close all; clear;

sl_quadrotor
mdl_quadrotor

bdclose all
close all

sim("sl_quadrotor");

% Make sure that the UAV Animation block figure is not hidden, 
% so rvcprint can grab it through gcf.
figureHandle = findall(groot, Type="Figure", Tag= ...
    uav.sluav.internal.util.Scope.getUniqueTag("sl_quadrotor/UAV Animation", ...
    uav.sluav.internal.system.UAVAnimation.BlockType));
figureHandle.HandleVisibility = 'on';

rvcprint("painters", "format", "pdf")
