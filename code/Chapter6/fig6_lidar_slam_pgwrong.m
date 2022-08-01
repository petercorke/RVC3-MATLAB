close all; clear;

lidar_slam_run

fromNodeID = 59;
toNodeID = 44;

pgwrong = slam.PoseGraph.copy;
pgwrong.addRelativePose([0 0 0], [1 0 0 1 0 1], fromNodeID, toNodeID);
pgwrongopt = optimizePoseGraph(pgwrong);

%% Subfigure (a) - Pose graph
figure
pgwrongopt.show(IDs="off");
hold on;
nodePoses = pgwrongopt.nodeEstimates;
plot(nodePoses([fromNodeID; toNodeID],1), nodePoses([fromNodeID; toNodeID],2), ...
    Color="white", LineStyle="-");
plot(nodePoses([fromNodeID; toNodeID],1), nodePoses([fromNodeID; toNodeID],2), ...
    Color="k", LineStyle=":", LineWidth=2);
plot(nodePoses([fromNodeID; toNodeID],1), nodePoses([fromNodeID; toNodeID],2), ".", ...
    Color="k", MarkerSize=14);
text(nodePoses(fromNodeID,1) + 0.15, nodePoses(fromNodeID,2), num2str(fromNodeID), ...
    Color="k", FontWeight="bold", FontSize=11);
text(nodePoses(toNodeID,1)-0.2, nodePoses(toNodeID,2)-0.35, num2str(toNodeID), ...
    Color="k", FontWeight="bold", FontSize=11);

xlabel("X [meters]")
ylabel("Y [meters]")
xlim(xlpg);
ylim([-4 5]);

% Add a legend and make node markers a bit larger
legend(["Edge", "Node", "Correct loop closure", "", "Incorrect loop closure"], Location="northwest");

rvcprint("painters", subfig="_a")

%% Subfigure (b) - Edge residuals
figure;
plot(pgwrongopt.edgeResidualErrors)
xlabel("Edge ID")
ylabel("Edge residual error")

rvcprint("painters", thicken=2, subfig="_b")