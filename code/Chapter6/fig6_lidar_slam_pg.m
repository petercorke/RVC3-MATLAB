close all; clear;

lidar_slam_run

pg = slam.PoseGraph;

%% Subfigure (a) - Pose graph
figure
pg.show(IDs="off");
xlabel("X [meters]")
ylabel("Y [meters]")
xlim(xlpg);
ylim(ylpg);

% Add a legend and make node markers a bit larger
legend(["Edge", "Node", "Loop closure"], Location="northwest");

rvcprint("painters", thicken=1.5, subfig="_a")

%% Subfigure (b) - Edge residuals
figure;
plot(pg.edgeResidualErrors)
xlabel("Edge ID")
ylabel("Edge residual error")

rvcprint("painters", thicken=2, subfig="_b")