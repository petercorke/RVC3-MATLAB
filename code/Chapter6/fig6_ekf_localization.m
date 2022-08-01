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
ekf.run(numSteps,"noplot");

%% Subfigure (a) - Full map and EKF results
figure;
map.plot
ekf.plotellipse(fillcolor=[177 254 177]/255)
robot.plotxy("b");
ekf.plotxy("r");
xyzlabel

% Draw rectangle that is used for closeup
closeupXLim = [-8.5 -5.5];
closeupYLim = [-4 -1];
plot_box(closeupXLim(1), closeupYLim(1), closeupXLim(2), closeupYLim(2), ...
    Color="black", LineWidth=1, LineStyle="--")

% Add legend
legend(["Landmark", "95% confidence", repmat("", 1, numSteps/20-1), "Ground truth", ...
    "EKF estimate", "", "Area of detail"]);

rvcprint("painters", subfig="_a", thicken=1.5)

%% Subfigure (b) - Update step zoom in
figure
axis equal
map.plot
ekf.plotellipse(fillcolor=[177 254 177]/255, interval=10)
robot.plotxy("b");
ekf.plotxy("r");
xlim(closeupXLim)
ylim(closeupYLim)

xyzlabel
legend([repmat("", 1, numSteps/10), "95% confidence", "Ground truth", ...
    "EKF estimate"], Location = "northwest");

rvcprint("painters", subfig="_b", thicken=1.5)
