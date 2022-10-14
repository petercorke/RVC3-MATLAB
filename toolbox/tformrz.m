%TFORMRZ Create SE(3) matrix for pure rotation about Z axis
%
% T = TFORMRZ(THETA) is a homogeneous transformation (4x4) representing a
% pure rotation of THETA radians about the z-axis. The translational
% component is zero.
%
% T = TFORMRZ(THETA, "deg") as above but THETA is in degrees.
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Chapter 2
%
% See also ROTMZ, TFORMRX, TFORMRY, TFORM2D, se3.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function T = tformrz(theta, unit)
    arguments
        theta (1,1) = 0
        unit (1,1) string {mustBeMember(unit, ["rad", "deg"])} = "rad"
    end

    assert((isreal(theta) | isa(theta, "sym")), ...
        "RVC3:tformrz:badarg", "theta must be a real scalar or symbolic");
    
    if unit == "deg"
        theta = deg2rad(theta);
    end

	T = [rotmz(theta) [0 0 0]'; 0 0 0 1];
end