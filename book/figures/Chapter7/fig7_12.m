close all
clear

panda = loadrobot("frankaEmikaPanda", DataFormat="row");
qr = [0, -0.3, 0, -2.2, 0, 2, 0.7854, 0, 0];

qvis = [1.1449 1.7628 -2.3428 -1.9738 1.9004 3.7525 0.9123 0 0.0400];

intPlot = interactiveRigidBodyTree(panda, Configuration=qvis);
view(-123.4292, 24.9028);

% Set axes limits and zoom level
xlim([-0.5 0.5])
ylim([-0.5 0.5])
zlim([0 1.2])
set(gca, "CameraViewAngle", 9.868)

% Add some additional light
camlight left

% Subfigure (a) - interactive marker with IK
rvcprint("opengl", subfig="_a")

% Subfigure (b) - adjust joint angle directly
qvis2 = [1.1449 1.7628 -2.3428 -2.7596 1.9004 3.7525 0.9123 0 0.0400];

intPlot.MarkerControlMethod = "JointControl";
intPlot.MarkerBodyName = "panda_link4";
intPlot.Configuration = qvis2;

rvcprint("opengl", subfig="_b")