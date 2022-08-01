close all
clear

cobra = loadrvcrobot("cobra");
TE = se3(trvec2tform([0.4 -0.3 0.2])) * ...
    se3(eul2tform(deg2rad([170 0 30]), "xyz"));

ik = inverseKinematics(RigidBodyTree=cobra);
weights = [0 0 1 1 1 1];
qsol = ik("link4", TE.tform, weights, cobra.homeConfiguration);

figure
plotTransforms(TE, FrameColor="red", FrameAxisLabels="on", AxisLabels="on")
hold on
T4 = cobra.getTransform(qsol, "link4");
plotTransforms(se3(T4), FrameColor="blue", FrameAxisLabels="on")

view(75,12)
xlim([-0.5 1.5])
ylim([-1.5 0])
zlim([-1 0.5])

rvcprint("painters", thicken=2)
