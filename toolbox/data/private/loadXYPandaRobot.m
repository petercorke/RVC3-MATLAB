function [xypanda, conf] = loadXYPandaRobot(dataFormat)
%loadXYPandaRobot Creates a robot object of a Panda robot carried by an XY base
%
% XYPANDA = loadXYPandaRobot returns a 9-axis robot comprising a
% Franka Emika Panda robot on an XY base.  Joints 1 and 2
% are the base, joints 3-9 are the robot arm.
%
% [XYPANDA,CONF] = loadXYPandaRobot also returns some robot configurations in
% CONF. For all configurations, the xy-joints have a value of 0:
%   qz         zero joint angle configuration
%   qr         vertical 'READY' configuration
%   qn         arm is at a home configuration
%
% Notes::
% - SI units of meters are used.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

xypanda = rigidBodyTree(DataFormat=dataFormat);

link0 = rigidBody("base_offset");
link0.Joint.setFixedTransform(rotm2tform(rotmy(pi/2)));

% Create the XY base
% DH parameters in setFixedTransform are specified as [a alpha d theta]
link1 = rigidBody("xy_link1");
link1.Joint = rigidBodyJoint("q1", "prismatic");
link1.Joint.setFixedTransform([0 -pi/2 0 0], "dh");
link1.Joint.PositionLimits = [-1 1];

link2 = rigidBody("xy_link2");
link2.Joint = rigidBodyJoint("q2", "prismatic");
link2.Joint.setFixedTransform([0 pi/2 0 -pi/2], "dh");
link2.Joint.PositionLimits = [-1 1];

% Load the standard Panda robot and remove the gripper
panda = loadrobot("frankaEmikaPanda", DataFormat="row");
panda.removeBody("panda_leftfinger");
panda.removeBody("panda_rightfinger");

% Compose the base and the Panda
xypanda.addBody(link0, "base");
xypanda.addBody(link1, link0.Name);
xypanda.addBody(link2, link1.Name);
xypanda.addSubtree(link2.Name, panda);

% Add some configurations for robot
conf.qr = [0, 0, 0, -0.3, 0, -2.2, 0, 2, pi/4];
conf.qn = [0 0 panda.homeConfiguration];
conf.qz = zeros(1,9);

if dataFormat == "column"
    conf.qr = conf.qr';
    conf.qn = conf.qn';
    conf.qz = conf.qz';
end

end