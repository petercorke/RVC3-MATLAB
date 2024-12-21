close all
clear

abb = loadrobot("abbIrb1600", DataFormat="row");

aIK = analyticalInverseKinematics(abb);

ikFcn = aIK.generateIKFunction("ikIRB1600");

% Find all possible target configurations
tgtPose = trvec2tform([0.93 0 0.5]) * eul2tform([0 pi/2 0]);
tgtConfig = ikFcn(tgtPose, false);

% Visualize result
% Start with the result that's also returned with joint limits
figure
set(gcf, "Position", [1000 700 900 650]);
plotConfs = [3,2,4,6]; 
for i = 1:4
    subplot(2,2,i); abb.show(tgtConfig(plotConfs(i),:));
    xlim([-0.5 1]);
    ylim([-0.5 0.5]);
    zlim([-0.1 1]);
    set(gca, "CameraViewAngle", 6.5);
    camlight left
end

delete("ikIRB1600.m");

rvcprint("opengl")