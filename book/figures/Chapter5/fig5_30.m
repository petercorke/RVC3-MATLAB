close all; clear;

% Create map with obstacles
og = binaryOccupancyMap(false(11,11), GridOriginInLocal=[-5.5,-5.5]);
og.setOccupancy([-2.5,-2.5], true(1,5));
og.setOccupancy([-2.5,-1.5], true(1,3));
og.setOccupancy([1.5,-0.5], true(5,2));

% Run lattice planner on it
lp = LatticePlanner(og);
lp.plan

% Set start and goal pose
qs = [0 0 pi/2];
qg = [1 0 pi/2];
lp.query(qs,qg)

% Make the goal marker a bit bigger, so it stands out from 
% the lattice nodes
figure;
lp.plot(goalmarker={"MarkerSize", 28})

xlim([-5 5]);
ylim([-5 5]);

% Have to use output format PDF here, because path doesn't show up completely otherwise
rvcprint("painters", "format", "pdf")