function [cobra, poses] = loadCobra600Robot(dataFormat)
%loadCobra600Robot Create rigidBodyTree for Omron eCobra 600 robot
%   The robot is constructed from DH parameters.
%
%   DH Table for eCobra 600
%   +--------+--------+-------+---------+---------+--------+
%   |  theta |   d    |   a   |  alpha  |  qlim-  | qlim+  |
%   +--------+--------+-------+---------+---------+--------+
%   |   q1   | 0.387  | 0.325 |   0.0°  | -105.0° | 105.0° |
%   |   q2   |     0  | 0.275 | 180.0°  | -157.5° | 157.5° |
%   |  0.0°  |    q3  |     0 |   0.0°  |     0.0 |   0.21 |
%   |   q4   |     0  |     0 |   0.0°  | -180.0° | 180.0° |
%   +--------+--------+-------+---------+---------+--------+

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

cobra = rigidBodyTree(DataFormat=dataFormat);

% Create first two revolute joints
% DH parameters in setFixedTransform are specified as [a alpha d theta]
link1 = rigidBody("link1");
link1.Joint = rigidBodyJoint("joint1", "revolute");
link1.Joint.setFixedTransform([0.325 0 0.387 0], "dh");
link1.Joint.PositionLimits = deg2rad([-105 105]);

link2 = rigidBody("link2");
link2.Joint = rigidBodyJoint("joint2", "revolute");
link2.Joint.setFixedTransform([0.275 pi 0 0], "dh");
link2.Joint.PositionLimits = deg2rad([-157.5 157.5]);

% Create prismatic joint
link3 = rigidBody("link3");
link3.Joint = rigidBodyJoint("joint3", "prismatic");
link3.Joint.setFixedTransform([0 0 0 0], "dh");
link3.Joint.PositionLimits = [0 0.21];

% Create last revolute joint. It's freely rotating, so no position limits
% are needed.
link4 = rigidBody("link4");
link4.Joint = rigidBodyJoint("joint4", "revolute");
link4.Joint.setFixedTransform([0 0 0 0], "dh");

% Assemble robot
cobra.addBody(link1, "base");
cobra.addBody(link2, link1.Name);
cobra.addBody(link3, link2.Name);
cobra.addBody(link4, link3.Name);

% Set default Earth gravity
cobra.Gravity = [0 0 -9.81];

poses.qz = zeros(1,4);
if dataFormat == "column"
    poses.qz = poses.qz';
end

end