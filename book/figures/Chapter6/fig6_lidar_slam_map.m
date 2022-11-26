close all; clear;

lidar_slam_run

%% Subfigure (a) - Raw scans and poses
figure
ax = slam.show;
xlabel("X [meters]")
ylabel("Y [meters]")
xlim(xl);
ylim(yl);

% Add a legend and make node markers a bit larger
legend(["Lidar points (aligned)", repmat("", 1, numScans-1), "Node poses (optimized)"], Location="northwest");
ax.Children(1).MarkerSize = 10;

rvcprint("painters", thicken=1.5, subfig="_a")

%% Subfigure (b) - Occupancy map
[scansAtPoses, optimizedPoses] = slam.scansAndPoses;
map = buildMap(scansAtPoses, optimizedPoses, mapResolution, maxLidarRange);

figure;
map.show;
title("")
xlim(xl);
ylim(yl);

rvcprint("painters", subfig="_b")