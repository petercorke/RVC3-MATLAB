function [puma, poses] = loadPuma560Robot(dataFormat)
%loadPuma560Robot Create rigidBodyTree for PUMA 560 robot
%   The robot is constructed from DH parameters.
%
%   DH Parameters for PUMA 560
%   +---+-----------+-----------+-----------+-----------+-----------+
%   | j |     theta |         d |         a |     alpha |    offset |
%   +---+-----------+-----------+-----------+-----------+-----------+
%   |  1|         q1|     0.6718|          0|     1.5708|          0|
%   |  2|         q2|          0|     0.4318|          0|          0|
%   |  3|         q3|    0.15005|     0.0203|    -1.5708|          0|
%   |  4|         q4|     0.4318|          0|     1.5708|          0|
%   |  5|         q5|          0|          0|    -1.5708|          0|
%   |  6|         q6|          0|          0|          0|          0|
%   +---+-----------+-----------+-----------+-----------+-----------+

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

puma = rigidBodyTree(DataFormat=dataFormat);

% Note that the baseHeight was not part of the original RVC2 MATLAB model,
% but is part of RVC3 Python
baseHeight = 26.45*0.0254;

% DH parameters in setFixedTransform are specified as [a alpha d theta]
link1 = rigidBody("link1");
link1.Joint = rigidBodyJoint("q1", "revolute");
link1.Joint.setFixedTransform([0 pi/2 baseHeight 0], "dh");
link1.Joint.PositionLimits = deg2rad([-160 160]);
% Inertial parameters are specified as [Ixx Iyy Izz Iyz Ixz Ixy]
link1.Mass = 0;
link1.Inertia = rvc.internal.inertiaToBodyFrame([0, 0.35, 0, 0, 0, 0], ...
    link1.Mass, link1.CenterOfMass);
% Jm=200e-6,    # actuator inertia
% G=-62.6111,   # gear ratio
% B=1.48e-3,    # actuator viscous friction coefficient (measured
%               # at the motor)
% Tc=[0.395, -0.435],
%   # actuator Coulomb friction coefficient for
%   # direction [-,+] (measured at the motor)

link2 = rigidBody("link2");
link2.Joint = rigidBodyJoint("q2", "revolute");
% DH parameters in setFixedTransform are specified as [a alpha d theta]
link2.Joint.setFixedTransform([0.4318 0 0 0], "dh");
link2.Joint.PositionLimits = deg2rad([-110 110]);
link2.CenterOfMass = [-0.3638, 0.006, 0.2275];
link2.Mass = 17.4;
link2.Inertia = rvc.internal.inertiaToBodyFrame([0.13, 0.524, 0.539, 0, 0, 0], ...
    link2.Mass, link2.CenterOfMass);
%                 Jm=200e-6,
%                 G=107.815,
%                 B=.817e-3,
%                 Tc=[0.126, -0.071],

link3 = rigidBody("link3");
link3.Joint = rigidBodyJoint("q3", "revolute");
% DH parameters in setFixedTransform are specified as [a alpha d theta]
link3.Joint.setFixedTransform([0.0203 -pi/2 0.15005 0], "dh");
link3.Joint.PositionLimits = deg2rad([-135 135]);
link3.CenterOfMass = [-0.0203, -0.0141, 0.070];
link3.Mass = 4.8;
link3.Inertia = rvc.internal.inertiaToBodyFrame([0.066, 0.086, 0.0125, 0, 0, 0], ...
    link3.Mass, link3.CenterOfMass);
%                 Jm=200e-6,
%                 G=-53.7063,
%                 B=1.38e-3,
%                 Tc=[0.132, -0.105],

link4 = rigidBody("link4");
link4.Joint = rigidBodyJoint("q4", "revolute");
% DH parameters in setFixedTransform are specified as [a alpha d theta]
link4.Joint.setFixedTransform([0 pi/2 0.4318 0], "dh");
link4.Joint.PositionLimits = deg2rad([-266 266]);
link4.CenterOfMass = [0, 0.019, 0];
link4.Mass = 0.82;
link4.Inertia = rvc.internal.inertiaToBodyFrame([1.8e-3, 1.3e-3, 1.8e-3, 0, 0, 0], ...
    link4.Mass, link4.CenterOfMass);

%                 Jm=33e-6,
%                 G=76.0364,
%                 B=71.2e-6,
%                 Tc=[11.2e-3, -16.9e-3],

link5 = rigidBody("link5");
link5.Joint = rigidBodyJoint("q5", "revolute");
% DH parameters in setFixedTransform are specified as [a alpha d theta]
link5.Joint.setFixedTransform([0 -pi/2 0 0], "dh");
link5.Joint.PositionLimits = deg2rad([-100 100]);
link5.CenterOfMass = [0, 0, 0];
link5.Mass = 0.34;
link5.Inertia = rvc.internal.inertiaToBodyFrame([0.3e-3, 0.4e-3, 0.3e-3, 0, 0, 0], ...
    link5.Mass, link5.CenterOfMass);
%                 Jm=33e-6,
%                 G=71.923,
%                 B=82.6e-6,
%                 Tc=[9.26e-3, -14.5e-3],

link6 = rigidBody("link6");
link6.Joint = rigidBodyJoint("q6", "revolute");
% DH parameters in setFixedTransform are specified as [a alpha d theta]
link6.Joint.setFixedTransform([0 0 0 0], "dh");
link6.Joint.PositionLimits = deg2rad([-266 266]);
link6.CenterOfMass = [0, 0, 0.032];
link6.Mass = 0.09;
link6.Inertia = rvc.internal.inertiaToBodyFrame([0.15e-3, 0.15e-3, 0.04e-3, 0, 0, 0], ...
    link6.Mass, link6.CenterOfMass);
%                 Jm=33e-6,
%                 G=76.686,
%                 B=36.7e-6,
%                 Tc=[3.96e-3, -10.5e-3],

% Add meshes
puma.Base.addVisual("Mesh", "puma_link0.stl", trvec2tform([0,0,baseHeight]))
link1.addVisual("Mesh", "puma_link1.stl")
link2.addVisual("Mesh", "puma_link2.stl")
link3.addVisual("Mesh", "puma_link3.stl")
link4.addVisual("Mesh", "puma_link4.stl")
link5.addVisual("Mesh", "puma_link5.stl")
link6.addVisual("Mesh", "puma_link6.stl")

% Assemble robot
puma.addBody(link1, "base");
puma.addBody(link2, link1.Name);
puma.addBody(link3, link2.Name);
puma.addBody(link4, link3.Name);
puma.addBody(link5, link4.Name);
puma.addBody(link6, link5.Name);

% Set default Earth gravity
puma.Gravity = [0 0 -9.81];

% Nominal pose (table top picking pose)
poses.qn = [0, pi/4, pi, 0, pi/4, 0];
% Ready pose. Arm up
poses.qr = [0, pi/2, -pi/2, 0, 0, 0];
% Straight and horizontal
poses.qs = [0, 0, -pi/2, 0, 0, 0];

if dataFormat == "column"
    poses.qn = poses.qn';
    poses.qr = poses.qr';
    poses.qs = poses.qs';
end

end