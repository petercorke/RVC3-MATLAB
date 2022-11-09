function I_frame = inertiaToBodyFrame(I_com, mass, com, R)
%INERTIATOBODYFRAME Convert inertia tensor relative to CoM to tensor relative to body's joint frame 
%   I_com is a 1x6 compact inertia tensor
%   com is a 1x3 vector describing the center of mass relative to the
%       body's joint frame (in m)
%   mass is the mass of the link (in kg)
%   R is the 3x3 rotation matrix that describes the rotational offset of
%   the com relative to the body frame.
%
%   This assumes that the frames are parallel, and don't have a rotation.
%   If there is a rotational offset, pass the R argument.
%
%   Based on post here: https://www.mathworks.com/matlabcentral/answers/1602190-why-the-robot-bodies-inertia-is-different-from-urdf

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

if nargin < 4
    R = eye(3);
end

ixx = I_com(1);
iyy = I_com(2);
izz = I_com(3);
ixy = I_com(4);
iyz = I_com(5);
ixz = I_com(6);

I = [ixx, ixy, ixz; ixy, iyy, iyz; ixz iyz izz];
Io = robotics.manip.internal.inertiaTransform(I, mass, R, com);
I_frame = robotics.manip.internal.flattenInertia(Io);

end

