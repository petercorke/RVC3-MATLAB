%[text] %[text:anchor:F4CCA683] # Robotics, Vision & Control 3e: for MATLAB
%[text] %[text:anchor:CAAB408D] # Chapter 4: Navigation
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%[text] Copyright 2022\-2023 Peter Corke, Witold Jachimczyk, Remo Pillat
bdclose all    % close all Simulink models
close all      % close all figures
clear          % clear all workspace variables
format compact % compact printout  
%[text] %[text:anchor:A4489A8D] ## 4\.1 Wheeled Mobile Robots
%[text] %[text:anchor:6E8232D8] ### 4\.1\.1 Car\-Like Mobile Robots
sl_lanechange
out = sim("sl_lanechange")
t = out.get("t");
q = out.get("y");
stackedplot(t,q, ...
  DisplayLabels=["x","y","theta","psi"], ...
  GridVisible=1,XLabel="Time")
plot(q(:,1),q(:,2))
%%
%[text] %[text:anchor:A2BCAAAE] #### 4\.1\.1\.1 Driving to a Point
sl_drivepoint
xg = [5 5];
x0 = [8 5 pi/2];
pause(1);
r = sim("sl_drivepoint");
q = r.find("y");
plot(q(:,1),q(:,2));
%%
%[text] %[text:anchor:32D37CA3] #### 4\.1\.1\.2 Driving Along a Line
sl_driveline
L = [1 -2 4];
xg = [5 5];
x0 = [8 5 pi/2];
pause(1);
r = sim("sl_driveline");
%%
%[text] %[text:anchor:9F844744] #### 4\.1\.1\.3 Driving Along a Path
sl_pursuit
r = sim("sl_pursuit");
%openExample("nav/" + ...
%  "PathFollowingWithObstacleAvoidanceInSimulinkExample");
%%
%[text] %[text:anchor:7DED6011] #### 4\.1\.1\.4 Driving to a Configuration
% sl_drivepose
% xg = [5 5 pi/2];
% x0 = [9 5 0];
% pause(1);
% r = sim("sl_drivepose");
% q = r.find("y");
% plot(q(:,1),q(:,2));
%%
%[text] %[text:anchor:00984E5B] ## 4\.2 Aerial Robots
sl_quadrotor
mdl_quadrotor
r = sim("sl_quadrotor");
size(r.result)
plot(r.t,r.result(:,1:2))
%%
%[text] %[text:anchor:FC916084] ## 4\.4 Wrapping Up
%[text] %[text:anchor:C037456C] ### 4\.4\.1 Further Reading
veh = BicycleVehicle(MaxSpeed=1,MaxSteeringAngle=deg2rad(30));
veh.q
veh.step(0.3,0.2)
veh.q
deriv = veh.derivative(0,veh.q,[0.3 0.2])
%[text] 
%[text] Suppress syntax warnings in this file
%#ok<*NASGU>
%#ok<*ASGLU>

%[appendix]
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
