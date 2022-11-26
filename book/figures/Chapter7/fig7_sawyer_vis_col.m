close all
clear

sawyer = importrobot("sawyer.urdf");

%% Subfigure (a) - Visuals
figure;
sawyer.show;
camlight

xlim([-0.5 1.2])
ylim([-0.5 0.5])
zlim([-1 0.75])
set(gca, "CameraViewAngle", 10.9583)

rvcprint("opengl", subfig="_a")


%% Subfigure (b) - Collision Meshes
figure;
sawyer.show(Visuals="off", Collisions="on")

xlim([-0.5 1.2])
ylim([-0.5 0.5])
zlim([-1 0.75])
set(gca, "CameraViewAngle", 10.9583)

rvcprint("opengl", subfig="_b")
