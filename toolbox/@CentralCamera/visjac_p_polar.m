%CentralCamera.visjac_p_polar Visual motion Jacobian for point feature
%
% J = C.visjac_p_polar(RT, Z) is the image Jacobian (2Nx6) for the image plane 
% points RT (2xN) described in polar form, radius and theta.  The depth of the 
% points from the camera is given by Z which is a scalar for all point, or a 
% vector (Nx1) of depths for each point.
%
% The Jacobian gives the image-plane polar point coordinate velocity in terms 
% of camera spatial velocity. 
%
% Reference::
% "Combining Cartesian and polar coordinates in IBVS",
% P. I. Corke, F. Spindler, and F. Chaumette,
% in Proc. Int. Conf on Intelligent Robots and Systems (IROS), (St. Louis),
% pp. 5962-5967, Oct. 2009.
%
% See also CentralCamera.visjac_p, CentralCamera.visjac_l, CentralCamera.visjac_e.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function J = visjac_p_polar(cam, rt, Z)

    if numel(rt) > 2
        J = [];
        if length(Z) == 1
            % if depth is a scalar, assume same for all points
            Z = repmat(Z, 1, size(rt, 2));
        end
        % recurse for each point
        for i=1:size(rt, 2)
            J = [J; visjac_p_polar(cam, rt(:,i), Z(i))];
        end
        return;
    end
    
    r = rt(1); th = rt(2);
    f = cam.f;
    k = (f^2+r^2)/f;
    k2 = f/(r*Z);

    J = [
        -f/Z*cos(th) -f/Z*sin(th) r/Z  k*sin(th)    -k*cos(th)   0
        k2*sin(th) -k2*cos(th)   0    f/r*cos(th) f/r*sin(th) -1];

    if 0
    r = rt(1); theta = rt(2);

    % compute the mapping from uv-dot to r-theta dot 
    M = 1/r * [r*cos(theta) r*sin(theta); -sin(theta) cos(theta)];

    % convert r-theta form to uv form
    u = r * cos(theta); v = r * sin(theta);

    % compute the Jacobian
    J = M * cam.visjac_p([u; v], Z);
    end
