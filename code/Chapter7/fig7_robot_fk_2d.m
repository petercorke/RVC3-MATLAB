close all
clear

link1 = rigidBody("link1");
link1.Joint = rigidBodyJoint("joint1", "revolute");
link2 = rigidBody("link2");
link2.Joint = rigidBodyJoint("joint2", "revolute");
link2.Joint.setFixedTransform(trvec2tform([1 0 0]));
link3 = rigidBody("link3");
link3.Joint.setFixedTransform(trvec2tform([1 0 0]));

myRobot = rigidBodyTree(DataFormat="row");
myRobot.addBody(link1, myRobot.BaseName);
myRobot.addBody(link2, link1.Name);
myRobot.addBody(link3, link2.Name);

% Save figure
figure
myRobot.show(deg2rad([30,40]));
view(0,90);
axis equal
xlim([-0.5, 1.5])
ylim([-0.5, 2])

% Make sure that the z-axis is showed as flat
zlim("auto");

% Set window position to ensure that X-axis is fully visible
set(gcf, "Position", [1364, 644, 420, 521]);

% Remove gizmo, since it doesn't help much in this 2D view
axArray = findall(gcf, Type="Axes", Tag="CornerCoordinateFrame");
delete(axArray);

rvcprint("painters", thicken=4)