close all; clear;

load house
floorMap = binaryOccupancyMap(flipud(floorplan));

% Create inflated map
dx = DistanceTransformPlanner(floorMap, inflate=6);
dx.plan(places.kitchen);
pathPoints = dx.query(places.br3);

%% Figure 5:floorplan-xform-inflated (a)
figure
dx.plot(pathPoints, "inflated", goalmarker={'MarkerFaceColor', 'white'});
axis equal;
ylim([0 400])

rvcprint("nogrid", "painters", subfig="_a")

%% Figure 5:floorplan-xform-inflated (b)
figure
dx.plot(pathPoints, goalmarker={'MarkerFaceColor', 'white'});
axis equal;
ylim([0 400])

rvcprint("nogrid", "painters", subfig="_b")