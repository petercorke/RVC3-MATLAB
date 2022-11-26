%% Initial Setup
format compact
bdclose all
close all
clear
clc

%% Section 4.1.1 - Car-Like Mobile Robots
sl_lanechange
out = sim("sl_lanechange")
t = out.get("t");
q = out.get("y");
stackedplot(t,q, ...
    DisplayLabels=["x","y","theta","psi"], ...
    GridVisible=1,XLabel="Time")
plot(q(:,1),q(:,2))

%% Section 4.1.1.1 - Driving to a Point

sl_drivepoint

xg = [5 5];

x0 = [8 5 pi/2];

r = sim("sl_drivepoint");

q = r.find("y");

plot(q(:,1),q(:,2));

%% Section 4.1.1.2 - Driving Along a Line

sl_driveline

L = [1 -2 4];

x0 = [8 5 pi/2];

r = sim("sl_driveline");

%% Section 4.1.1.3 - Driving Along a Path

sl_pursuit

r = sim("sl_pursuit")

openExample("nav/" + ...
    "PathFollowingWithObstacleAvoidanceInSimulinkExample")

%% Section 4.1.1.4 - Driving to a Configuration

sl_drivepose

xg = [5 5 pi/2];

x0 = [9 5 0];

r = sim("sl_drivepose");

q = r.find("y");
plot(q(:,1),q(:,2));

%% Section 4.2 - Aerial Robots

sl_quadrotor

mdl_quadrotor

r = sim("sl_quadrotor");


size(r.result)

plot(r.t,r.result(:,1:2))

%% Section 4.4.1 - Further Reading

veh = BicycleVehicle(MaxSpeed=1, MaxSteeringAngle=deg2rad(30));
veh.q'  % transpose for display

veh.step(0.3,0.2)
veh.q'  % transpose for display

deriv = veh.derivative(0,veh.q,[0.3 0.2]);
deriv'  % transpose for display


