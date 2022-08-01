close all; clear;

simplegrid = binaryOccupancyMap(zeros(7,7));
simplegrid.setOccupancy([3, 3], ones(2,3), "grid");
simplegrid.setOccupancy([5, 4], ones(1,2), "grid");

%% Figure 5:obstacle-xform (a)
invertedGrid = binaryOccupancyMap(~simplegrid.occupancyMatrix);

%% Figure 5:distance-xform (a)
figure;
invertedGrid.show("grid");
grid on;

title remove
xlabel x
ylabel y

xticks(1:6)
yticks(1:6)

rvcprint(subfig="_a");

%% Figure 5:obstacle-xform (b) - Distance transform with Euclidean distance
dx = DistanceTransformPlanner(simplegrid);
dx.plan([2 2]);
dx.query([4 6]);
figure;
% Have to artifically introduce start point and then make it very small to
% avoid bug on rvcprint (MarkerFaceColor for goal is ignored otherwise)
dx.plot(labelvalues=true, startmarker={"MarkerSize", 0.1}, goalmarker={"Marker", "p", 'MarkerFaceColor', 'white'});

% Save subfigure b
rvcprint("nogrid", "painters", subfig="_b");

%% Figure 5:obstacle-xform (c) - Plan with Manhattan distance
dx = DistanceTransformPlanner(simplegrid, metric="manhattan");
dx.plan([2 2]);
pathPoints = dx.query([4 6]);

% Use empty circles, so that the labelled values are visible as well.
figure;
dx.plot(pathPoints, labelvalues=true, pathmarker={"Marker", "o", ...
    "MarkerSize", 30, "LineWidth", 3}, goalmarker={'MarkerFaceColor', 'white'})

% Save subfigure c
rvcprint("nogrid", "painters", subfig="_c");
