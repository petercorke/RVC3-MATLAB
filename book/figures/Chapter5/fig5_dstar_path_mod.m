close all; clear;

load house
floorMap = binaryOccupancyMap(flipud(floorplan));
ds = DStarPlanner(floorMap);
ds.plan(places.kitchen, "noprogress");

% Modify cost and replan
ds.modifyCost( [290,335;100,125], 5 );
tic
ds.plan("noprogress"); % replan
toc
ds.niter
p = ds.query(places.br3);

figure;
ds.plot(p, goalmarker={'MarkerFaceColor', 'white'})

hold on
plot_box([290 335; 100 125], 'y:', 'LineWidth', 3)
axis equal;
ylim([0 400])

rvcprint("nogrid", "painters")