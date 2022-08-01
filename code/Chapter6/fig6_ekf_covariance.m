close all; clear;

V = diag([0.02, 0.5*pi/180].^2);
P0 = diag([.05, .05, deg2rad(0.5)].^2);
W = diag([0.1, 1*pi/180].^2);


rng("default")
map = LandmarkMap(20,10);
robot = BicycleVehicle(Coveriance=V);
robot.addDriver( RandomDriver(map.dim) );
sensor = LandmarkSensor(robot, map, covar=W, angle=[-pi/2 pi/2], range=4);
ekf = EKF(robot, V, P0, sensor, W, map);

numSteps = 400;
ekf.run(numSteps, "noplot");

%% Subfigure (a) - Overall uncertainty
figure;
ekf.plotP
xlabel("Time step");
ylabel("(det P)^{0.5}")
grid on

rvcprint("painters", subfig="_a", thicken=2);

%% Subfigure (b) - Pose estimation error
fig = figure;
ekf.ploterror(confidence=0.95, nplots=4)

% Remove the time step xlabels from the first 3 subplots, since the 4th one
% is already showing it.
fig.Children(2).XTick = [];
fig.Children(2).XLabel.String = "";
fig.Children(3).XTick = [];
fig.Children(4).XTick = [];

plot(1:400, sensor.landmarklog, ".", Color=[0 0.4470 0.7410])
xlabel("Time step")
ylabel("Landmarks")
grid on

rvcprint("painters", subfig="_b", thicken=1.5);
