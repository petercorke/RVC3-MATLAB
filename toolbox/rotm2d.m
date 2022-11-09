%ROTM2D Create SO(2) rotation matrix
%
% R = ROTM2D(THETA) is an SO(2) rotation matrix (2x2) representing a 
% rotation of THETA radians.
%
% R = ROTM2D(THETA, "deg") as above but THETA is in degrees.
%
% See also TROT2, ISROTM2D, TRPLOT2, ROTMX, ROTMY, ROTMZ, so2.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function R = rotm2d(theta, unit)
    arguments
        theta (1,1) = 0
        unit (1,1) string {mustBeMember(unit, ["rad", "deg"])} = "rad"
    end

    assert((isreal(theta) | isa(theta, "sym")), ...
        "RVC3:rotm2d:badarg", "theta must be a real scalar or symbolic");
    
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
        ct  -st
        st   ct
        ];
end