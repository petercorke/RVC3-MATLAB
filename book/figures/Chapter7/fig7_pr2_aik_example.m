close all
clear

% This code is mostly from a shipping example
% openExample("robotics/SolveAnalyticalIKForLargeDOFRobotExample")

robot = loadrobot('willowgaragePR2','DataFormat','row');
aik = analyticalInverseKinematics(robot);
opts = showdetails(aik);
aik.KinematicGroup = opts(1).KinematicGroup;
generateIKFunction(aik,'willowRobotIK');

rng(0);
expConfig = randomConfiguration(robot);

eeBodyName = aik.KinematicGroup.EndEffectorBodyName;
baseName = aik.KinematicGroup.BaseName;
expEEPose = getTransform(robot,expConfig,eeBodyName,baseName);

ikConfig = willowRobotIK(expEEPose,false);

eeWorldPose = getTransform(robot,expConfig,eeBodyName);

generatedConfig = repmat(expConfig, size(ikConfig,1), 1);
generatedConfig(:,aik.KinematicGroupConfigIdx) = ikConfig;

% Only show solution 4
for i = 4
    figure;
    ax = show(robot,generatedConfig(i,:), Frames="off");
    hold all;
    plotTransforms(tform2trvec(eeWorldPose),tform2quat(eeWorldPose),'Parent',ax);
%     title(['Solution ' num2str(i)]);
end

xlim([-0.5 1.5]);
ylim([-0.5 0.5]);
zlim([0 2]);

view(47.6319, 14.1006);
set(gca, "CameraViewAngle", 7.2022)

rvcprint("opengl", thicken=2)