%ROTMZ Create SO(3) matrix for rotation about Z axis
%
% R = ROTMZ(THETA) is an SO(3) rotation matrix (3x3) representing a 
% rotation of THETA radians about the z-axis.
%
% R = ROTMZ(THETA, "deg") as above but THETA is in degrees.
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Chapter 2
%
% See also TFORMRZ, ROTMX, ROTMY, ROTM2D, so3.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function R = rotmz(theta, unit)
    arguments
        theta (1,1) = 0
        unit (1,1) string {mustBeMember(unit, ["rad", "deg"])} = "rad"
    end

    assert((isreal(theta) | isa(theta, "sym")), ...
        "RVC3:rotmz:badarg", "theta must be a real scalar or symbolic");
    
    if unit == "deg"
        theta = deg2rad(theta);
    end
    
    ct = cos(theta);
    st = sin(theta);
    
    % make almost zero elements exactly zero
    if ~isa(theta, "sym")
        if abs(st) < eps
            st = 0;
        end
        if abs(ct) < eps
            ct = 0;
        end
    end
    
    % create the rotation matrix
    R = [
        ct  -st  0
        st   ct  0
        0    0   1
        ];
end
