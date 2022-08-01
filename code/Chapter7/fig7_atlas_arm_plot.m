close all
clear

atlas = loadrobot("atlas", DataFormat="row");

xlim([-1 1])
ylim([-1 1])
zlim([-1 1.25])

rightArm = atlas.subtree("r_clav");
figure; rightArm.show;

view(40.8342, 29.8211)
set(gca, "CameraViewAngle", 2.2628)
set(gca, "CameraPosition", [14.5745  -17.2557   12.8885])
set(gca, "CameraTarget", [-0.1640   -0.2015   -0.0317]);
set(gcf, "Position", [1000   918  414 420]);

camlight

% Add text for pertinent frames
utorsoPos = tform2trvec(rightArm.getTransform(rightArm.homeConfiguration, "utorso"));
rClavPos = tform2trvec(rightArm.getTransform(rightArm.homeConfiguration, "r_clav"));
rToolPos = tform2trvec(rightArm.getTransform(rightArm.homeConfiguration, "r_hand_force_torque"));

utorsoText = text(utorsoPos(1) + 0.06, utorsoPos(2) + 0.06, utorsoPos(3), "utorso", FontSize=14);
lClavText = text(rClavPos(1) + 0.03, rClavPos(2) + 0.03, rClavPos(3) + 0.1, "r\_clav", FontSize=14, Color=[0,0,1]);
lToolText = text(rToolPos(1) - 0.2, rToolPos(2) - 0.2, rToolPos(3)- 0.1, "r\_hand\_force\_torque", FontSize=14, Color=[1,0,1]);

rvcprint("opengl")