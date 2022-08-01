q0 = [3,6,deg2rad(-45)];
rng("default")
map = LandmarkMap(20,10);
V = diag([0.1, deg2rad(1)].^2);
robot = BicycleVehicle(covar=V, q0=q0);
robot.addDriver( RandomDriver(map.dim) );
W = diag([0.1, deg2rad(1)].^2);
sensor = LandmarkSensor(robot, map, covar=W);
P0 = diag([.05, .05, deg2rad(0.5)].^2);
ekf = EKF(robot, V, P0, sensor, W, []);

x0 = [0 0 0];
ekf.run(500, "noplot", x_est0=x0);