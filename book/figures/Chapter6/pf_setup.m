rng("default")
V = diag([0.02, deg2rad(0.5)].^2);
W = diag([0.1, deg2rad(1)].^2);

map = LandmarkMap(20,10);

robot = BicycleVehicle(covar=V);
robot.addDriver( RandomDriver(10) );
sensor = LandmarkSensor(robot, map, covar=W);

Q = diag([0.1, 0.1, deg2rad(1)]).^2;
L = diag([0.1 0.1]);

pf = ParticleFilter(robot, sensor, Q, L, 1000);
