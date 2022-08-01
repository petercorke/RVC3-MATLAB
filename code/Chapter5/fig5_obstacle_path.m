close all; clear;

simplegrid = binaryOccupancyMap(zeros(7,7));
simplegrid.setOccupancy([3, 3], ones(2,3), "grid");
simplegrid.setOccupancy([5, 4], ones(1,2), "grid");

%% Figure 5: obstacle-path (a)
dx = DistanceTransformPlanner(simplegrid, metric="manhattan");
dx.plan([2 2]);
pathPoints = dx.query([6 5]);
figure;
dx.plot3d(pathPoints)
view(-60.9, 36);
rvcprint("painters", subfig="_a");

%% Figure 5: obstacle-path (b)
figure;
dx.plot(pathPoints, pathmarker={"MarkerSize", 30}, ...
    goalmarker={'MarkerFaceColor', 'white'})
rvcprint("nogrid", "painters", subfig="_b");