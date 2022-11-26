close all; clear;

load parkingMap
inflatedMap = parkingMap.copy;
inflatedMap.inflate(0.5, "world");

carModel = mobileRobotPropagator( ...
    KinematicModel="bicycle",...
    DistanceEstimator="reedsshepp", ...
    ControlPolicy="linearpursuit", ...
    Environment = inflatedMap);
carModel.SystemParameters.KinematicModel.WheelBase = 2;
carModel.StateSpace.StateBounds(1:2,:) = ...
     [parkingMap.XWorldLimits; parkingMap.YWorldLimits];

% Propagate car model for 5 seconds
carModel.ControlStepSize = 0.1;
carModel.MaxControlSteps = 50;

rrt = plannerControlRRT(carModel);
rrt.NumGoalExtension = 2;

rrt.GoalReachedFcn = @(planner, q, qTgt) abs(angdiff(q(3), qTgt(3))) < 0.25 && ...
norm(q(1:2) - qTgt(1:2)) < 0.75;

%% Subfigure (a) - Backwards parking with intermediate states
start = [9.5 4 0];
goal = [5.5 2 0];
rng(0);
[p, solnInfo] = rrt.plan(start, goal);
figure;
showControlRRT(p, solnInfo, parkingMap, start, goal);

% Plot some intermediate states as well
hold on
plotPath = p.copy;
plotPath.interpolate;
for i = 1:10:size(plotPath.States,1)
    plotvehicle(plotPath.States(i,:), "box", "scale", 1/25, "edgecolor", [0.5 0.5 0.5], "linewidth", 1);
end

l = legend(["RRT tree nodes", "Path", "Start", "Goal"], Location="west");
l.Position(2) = l.Position(2) + 0.16;

hold off

xlabel("x");
ylabel("y");

rvcprint("painters", subfig="_a")

%% Subfigure (b) - Forward parking scenario
start = [2 4 0];
rng("default");
[p, solnInfo] = rrt.plan(start, goal);
figure;
showControlRRT(p, solnInfo, parkingMap, start, goal);

xlabel("x");
ylabel("y");

rvcprint("painters", subfig="_b")

% Works for forward parking -  start = [2 4 0];
% % Works for backward parking -  start = [9.5 4 0];
% start = [9.5 4 0];
% goal = [5.5 2 0];
% 
% rng("default");
% [p, solnInfo] = rrt.plan(start, goal);
% %close all; figure; 
% parkingMap.show; hold on; showControlRRT(p, solnInfo, start, goal);
% 
