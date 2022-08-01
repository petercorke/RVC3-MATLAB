close all; clear;

load house
floorMap = binaryOccupancyMap(flipud(floorplan));
ds = DStarPlanner(floorMap);

ds.plan(places.kitchen, "noprogress");
ds.niter
p = ds.query(places.br3, "animate");
ds.plot(p, goalmarker={'MarkerFaceColor', 'white'})
axis equal;
ylim([0 400])

rvcprint("nogrid", "painters")