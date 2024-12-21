close all; clear;

ekf_slam_run

%% Subfigure (a) - True path
figure
map.plot;           % plot true map
robot.plotxy("b"); % plot true path
axis equal;
ylim([-10 10])
legend(["True landmark", "True path"])
xyzlabel
rvcprint("painters", subfig="_a", thicken=1.5)

%% Subfigure (b) - Estimated and rotated path
figure
ekf.plotmap("g");  % plot estimated landmarks + covariances
ekf.plotxy("r");   % plot estimated robot path
xyzlabel

% Transform true path into SLAM frame (from q0 to x0)
xDiff = x0 - q0;
xDiff(3) = wrapToPi(xDiff(3));
T = se2(tform2d(0,0,xDiff(3))) * se2(trvec2tform([xDiff(1),xDiff(2)]));
transformedTruePath = T.transform(robot.qhist(:,1:2)', IsCol=true);
transformedTrueLandmarks = T.transform(map.map, IsCol=true); 
plot(transformedTrueLandmarks(1,:)', transformedTrueLandmarks(2,:)', "kh");
plot(transformedTruePath(1,:)', transformedTruePath(2,:)', Color="b", LineStyle="--");
legend(["", "Estimated landmark", "Estimated landmark confidence", repmat("",1,37), ...
    "Estimated path", "", "True landmark in map frame", "True path in map frame"])

rvcprint("painters", subfig="_b", thicken=1.5)