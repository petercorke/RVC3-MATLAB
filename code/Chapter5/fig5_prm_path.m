close all; clear;
load house
floorMap = binaryOccupancyMap(flipud(floorplan));

rng(10)
prm = mobileRobotPRM(floorMap);

% Go through same cycle of first creating road map with 50
% and then with 300 nodes (as in fig5_prm_graph), so we have
% repeatable results.
f = figure;
ax = prm.show;
prm.NumNodes = 300;
p = prm.findpath(places.br3, places.kitchen);

%% Subfigure (a) - Path with 300 nodes
ax = prm.show;
% Make nodes bigger
graphNodes = ax.Children(2);
pathNodes = ax.Children(1);
graphNodes.LineWidth = 2;
hold on

plotStartGoal(places.br3, places.kitchen, 10, 14);

xlabel("x"); ylabel("y"); title("");
legend(["Roadmap connection", "Roadmap node", "Path", "Start", "Goal"], Location="eastoutside");
f.Position =[717 918 843 420];

rvcprint("subfig", "_a", "nogrid", "painters");


%% Subfigure (b) - Graph with 300 nodes
xlim([275, 360])
ylim([150, 215])
graphNodes.LineWidth = 10;
pathNodes.LineWidth = 3;
goalmarker =  {'bp', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k', 'MarkerSize', 32};
plot(places.kitchen(1), places.kitchen(2), goalmarker{:});
legend off

rvcprint("subfig", "_b", "nogrid", "painters");
