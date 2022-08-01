load parkingMap
inflatedMap = parkingMap.copy;
inflatedMap.inflate(0.5, "world");

%%%
% This file contains some comments on how to tune the performance of
% plannerControlRRT after a discussion with Cameron.
%%%

% Start with bicycle to tune. Can switch to "ackermann" later if desired.
% Starting with ackermann makes tying harder.

% linearpursuit likely better for parking (since goal is in view, so more
% direct motions make sense).
% randomsamples might also work, since workspace is restricted. If using
% randomsamples, be sure to adjust
% SystemParameters.ControlPolicy.NumSamples to a larger number, e.g. 5
carModel = mobileRobotPropagator( ...
    KinematicModel="bicycle",...
    DistanceEstimator="reedsshepp", ...
    ControlPolicy="linearpursuit", ...
    Environment = inflatedMap);
carModel.SystemParameters.KinematicModel.WheelBase = 2;
%carModel.SystemParameters.KinematicModel.SpeedLimit = [-1 1];
%carModel.SystemParameters.ControlPolicy.NumSamples = 5

% Setting the state bounds is critical when providing an occupancy
% map. Otherwise, some states might get sampled outside the map and
% results are sub-optimal.
carModel.StateSpace.StateBounds(1:2,:) = ...
     [parkingMap.XWorldLimits; parkingMap.YWorldLimits];


% Propagate car model for 5 seconds. Longer propagation times lead
% to smoother paths through the tree.
carModel.ControlStepSize = 0.1;
carModel.MaxControlSteps = 50;

rrt = plannerControlRRT(carModel);
% More than 1 goal extension will ensure faster convergence on goal.
% Setting this number too large will create "overshoot" type behavior.
rrt.NumGoalExtension = 2;

% Can also try to find a more optimal path by setting maximum planning time
% Illustrates how to keep extending graph.
% rrt.MaxPlanningTime = 10;
% rrt.ContinueAfterGoalReached = true;

% Standard GoalReachedFcn isn't very good, since it treats angles and
% distances the same way. To achieve a better goal orientation, separate
% them and provide your own function handle.
rrt.GoalReachedFcn = @(planner, q, qTgt) abs(angdiff(q(3), qTgt(3))) < 0.25 && ...
norm(q(1:2) - qTgt(1:2)) < 0.75;

% Works for forward parking -  start = [2 4 0];
% Works for backward parking -  start = [9.5 4 0];
start = [9.5 4 0 0];
goal = [5.5 2 0 0];

rng("default");
[p, solnInfo] = rrt.plan(start, goal);
%close all; figure; 
showControlRRT(p, solnInfo, parkingMap, start, goal);

