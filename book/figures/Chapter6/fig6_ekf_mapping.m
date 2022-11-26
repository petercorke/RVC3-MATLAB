% EKF map making
close all; clear;

rng("default")
map = LandmarkMap(20,10);
robot = BicycleVehicle; % error free vehicle
robot.addDriver( RandomDriver(map.dim) );
W = diag([0.1, deg2rad(1)].^2);
sensor = LandmarkSensor(robot, map, covar=W);
ekf = EKF(robot, [], [], sensor, W, []);

ekf.run(1000, "noplot");

%% Subfigure (a) - Whole map
figure;
map.plot();
ekf.plotmap("g");
robot.plotxy("b");
xyzlabel
xlim([-12 13]);
legend(["Landmark", "95% confidence", "Estimated landmark", repmat("",1,19*2), "True path"])

rvcprint("painters", subfig="_a", thicken=1.5)

%% Subfigure (b) - Zoom in on one landmark
figure;
map.plot();
ekf.plotmap("g");
robot.plotxy("b");
xyzlabel
axis equal;
xlim([-4.4977   -4.3884]);
ylim([-9.1124   -9.0250]);
legend(["Landmark", "Confidence", "Estimated landmark"])

% Make the landmark a bit bigger, so it's easier to see
landmarkID = 17;
stateIdx = ekf.landmarks(1,landmarkID);
landmarkState = ekf.x_est(stateIdx:stateIdx+1);
plot(landmarkState(1), landmarkState(2), "k.", MarkerSize=16)
legend(["Landmark", "95% confidence", "", repmat("",1,19*2), "", "Estimated landmark"])

rvcprint("painters", subfig="_b", thicken=1.5)

%% Subfigure (c) - Covariance matrix
figure;
ekf.show_P
rvcprint("painters", subfig="_c")
