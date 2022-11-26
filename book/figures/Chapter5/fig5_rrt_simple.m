close all; clear;

bicycleModel = mobileRobotPropagator(KinematicModel="bicycle");
bicycleModel.SystemParameters.KinematicModel.SteerLimit = [-0.5 0.5];
bicycleModel.SystemParameters.KinematicModel.SpeedLimit = [0 1];

rrt = plannerControlRRT(bicycleModel);

start = [0 0 pi/2];
goal = [8 2 0];

rng(0);
[p, solnInfo] = rrt.plan(start, goal);

figure;
plotPath = p.copy;
plotPath.interpolate;
showControlRRT(plotPath, solnInfo, [], start, goal);
axis equal
xlim([-0.5 9]);
ylim([-1 3]);

xlabel("x");
ylabel("y");

legend(["RRT tree nodes", "Path", "Start", "Goal"], Location="southeast")

rvcprint("painters")