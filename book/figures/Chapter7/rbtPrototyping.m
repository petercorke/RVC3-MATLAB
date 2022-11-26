% >>> link1 = ELink2(ETS2.r(), name="link1")
% >>> link2 = ELink2(ETS2.tx(1) * ETS2.r(), name="link2", parent=link1)
% >>> link3 = ELink2(ETS2.tx(1), name="link3", parent=link2)

% Define all links and joints
link1 = rigidBody("link1");
link1.Joint = rigidBodyJoint("joint1", "revolute");

link2 = rigidBody("link2");
link2.Joint = rigidBodyJoint("joint2", "revolute");
link2.Joint.setFixedTransform(trvec2tform([1 0 0]));

link3 = rigidBody("link3");
link3.Joint.setFixedTransform(trvec2tform([1 0 0]));


% >>> robot = ERobot2([link1, link2, link3], name="my robot")
% ERobot2: my robot, 2 joints (RR)
% +---+--------+-------+--------+-----------------------------------+
% |id |  link  | joint | parent |                ETS                |
% +---+--------+-------+--------+-----------------------------------+
% | 1 | link1  |     0 | BASE   | {link1} = {BASE} * R(q0)          |
% | 2 | link2  |     1 | link1  | {link2} = {link1} * tx(1) * R(q1) |
% | 3 | @link3 |       | link2  | {link3} = {link2} * tx(1)         |
% +---+--------+-------+--------+-----------------------------------+

myRobot = rigidBodyTree(DataFormat="column");
myRobot.addBody(link1, myRobot.BaseName);
myRobot.addBody(link2, link1.Name);
myRobot.addBody(link3, link2.Name);

myRobot.getTransform(deg2rad([30,40]'), "link3")
printtform(se3(myRobot.getTransform(deg2rad([30,40]'), "link3")))

myRobot.showdetails

myRobot.show(deg2rad([30; 40]))
view(0,90); zlim("auto");

% >>> robot.fkine([30, 40], unit="deg").printline()
% t = 1.21, 1.44; 70°

