close all; clear;

load house
floorMap = binaryOccupancyMap(flipud(floorplan));

dx = DistanceTransformPlanner(floorMap);
dx.plan(places.kitchen);
pathPoints = dx.query(places.br3);
dx.plot(pathPoints, goalmarker={'MarkerFaceColor', 'white'});
axis equal;
ylim([0 400])

rvcprint("nogrid", "painters")