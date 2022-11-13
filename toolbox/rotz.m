%ROTZ Rotation about Z axis
%
% R = ROTZ(THETA) is an SO(3) rotation matrix (3x3) representing a rotation of THETA 
% radians about the z-axis.
%
% R = ROTZ(THETA, 'deg') as above but THETA is in degrees.
%
% See also ROTX, ROTY, ANGVEC2R, ROT2, SO3.Rx.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function R = rotz(t, deg)
    if nargin > 1 && strcmp(deg, 'deg')
        t = t *pi/180;
    end
    
    ct = cos(t);
    st = sin(t);
    R = [
        ct  -st  0
        st   ct  0
        0    0   1
        ];
