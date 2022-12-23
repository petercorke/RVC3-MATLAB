close all; clear;

floorplan = zeros(5,5);
floorplan(3,2) = 1;
occMap = binaryOccupancyMap(~floorplan);

%% Figure 5:distance-xform (a)
figure;
occMap.show("grid");
grid on;

title remove
xlabel x
ylabel y

xticks(1:5)
yticks(1:5)

rvcprint(subfig="_a");

%% Figure 5:distance-xform (b) - Euclidean
floorplan = zeros(5,5);
dx = DistanceTransformPlanner(floorplan, metric="euclidean");
dx.plan([2,3]);

figure;
dx.plot("nogoal", labelvalues=true);

xticks(1:5)
yticks(1:5)

% Save subfigure b
rvcprint("nogrid", "painters", subfig="_b");

%% Figure 5:distance-xform (c)
dx = DistanceTransformPlanner(floorplan, metric="cityblock");
dx.plan([2,3]);

figure;
dx.plot("nogoal", labelvalues=true);

xticks(1:5)
yticks(1:5)

% Save subfigure c
rvcprint("nogrid", "painters", subfig="_c");
