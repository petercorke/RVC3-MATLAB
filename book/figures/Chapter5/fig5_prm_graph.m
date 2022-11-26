close all; clear;

load house
floorMap = binaryOccupancyMap(flipud(floorplan));

rng(10)
prm = mobileRobotPRM(floorMap);

%% Subfigure (a) - Graph with 50 nodes
figure;
ax = prm.show;
% Make nodes bigger
ax.Children(1).LineWidth = 2;

xlabel("x"); ylabel("y"); title("");
rvcprint("subfig", "_a", "nogrid", "painters");


%% Subfigure (b) - Graph with 300 nodes
figure;
prm.NumNodes = 300;
ax = prm.show;
ax.Children(1).LineWidth = 2;

xlabel("x"); ylabel("y"); title("");
rvcprint("subfig", "_b", "nogrid", "painters");
