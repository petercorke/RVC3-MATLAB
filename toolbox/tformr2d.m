%TFORM2D Create SE(2) matrix for pure rotation
%
% T = TFORM2D(THETA) is a homogeneous transformation (3x3) representing a
% pure rotation of THETA radians. The translational component is zero.
%
% T = TFORM2D(THETA, "deg") as above but THETA is in degrees.
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Chapter 2
%
% See also ROTM2D, ISHOMOG2, TFORMRX, TFORMRY, TFORMRZ, se2.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function T = tformr2d(theta, unit)
    arguments
        theta (1,1) = 0
        unit (1,1) string {mustBeMember(unit, ["rad", "deg"])} = "rad"
    end

    assert((isreal(theta) | isa(theta, "sym")), ...
        "RVC3:tform2d:badarg", "theta must be a real scalar or symbolic");
    
    if unit == "deg"
        theta = deg2rad(theta);
    end

	T = [rotm2d(theta) [0 0]'; 0 0 1];
end
