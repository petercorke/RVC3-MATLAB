function [hyper3d, conf] = loadHyper3DRobot(dataFormat, N)
%loadHyper3DRobot Creates a robot object of a hyper redundant manipulator
%
%   HYPER3D = loadHyper3DRobot returns a 10-joint robot which describes the kinematics 
%   of a serial link manipulator with 10 joints which moves in the xy-plane, 
%   using standard DH conventions. At zero angles it forms a straight line 
%   along the x-axis. 
% 
%   HYPER3D = loadHyper3DRobot(N) models a robot with N joints. 
%
%   [HYPER3D,CONF] = ___ also returns some robot configurations in
%   CONF:
%     qz         zero joint angle configuration
%
%   Notes::
%   - SI units of meters are used.
%
%   References:
%       "A divide and conquer articulated-body algorithm for parallel O(log(n))
%       calculation of rigid body dynamics, Part 2",
%       Int. J. Robotics Research, 18(9), pp 876-892. 

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

if nargin == 0
    N = 10;
end

a = 1/N;

hyper3d = rigidBodyTree(DataFormat=dataFormat);

for i = 1:N
    % DH parameters in setFixedTransform are specified as [a alpha d theta]
    link = rigidBody("link" + string(i));
    link.Joint = rigidBodyJoint("q" + string(i), "revolute");
    link.Joint.setFixedTransform([a pi/2 0 0], "dh");

    if i == 1
        parentName = "base";
    else
        parentName = hyper3d.Bodies{end}.Name;
    end

    hyper3d.addBody(link, parentName);
end

conf.qz = zeros(1,N);
if dataFormat == "column"
    conf.qz = conf.qz';
end

end