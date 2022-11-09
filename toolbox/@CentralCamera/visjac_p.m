%CentralCamera.visjac_p Visual motion Jacobian for point feature
%
% J = C.visjac_p(UV, Z) is the image Jacobian (2Nx6) for the image plane 
% points UV (2xN).  The depth of the points from the camera is given by Z
% which is a scalar for all points, or a vector (Nx1) of depth for each point.
%
% The Jacobian gives the image-plane point velocity in terms of camera spatial
% velocity. 
%
% Reference::
% "A tutorial on Visual Servo Control",
% Hutchinson, Hager & Corke,
% IEEE Trans. R&A, Vol 12(5),
% Oct, 1996, pp 651-670.
%
% See also CentralCamera.visjac_p_polar, CentralCamera.visjac_l, CentralCamera.visjac_e.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function L = visjac_p(cam, uv, Z)

    if size(uv,1) > 1
        L = [];
        if length(Z) == 1
            % if depth is a scalar, assume same for all points
            Z = repmat(Z, 1, size(uv,1));
        end
        % recurse for each point
        for i=1:size(uv,1)
            L = [L; cam.visjac_p(uv(i,:), Z(i))];
        end
        return;
    end
    
    % convert to normalized image-plane coordinates
    x = (uv(1) - cam.u0) * cam.rho(1) / cam.f;
    y = (uv(2) - cam.v0) * cam.rho(2) / cam.f;

    L = [
        -x*y, (1+x^2), -y, 1/Z, 0, -x/Z
        -(1+y^2), x*y, x, 0, 1/Z, -y/Z, 
        ];

    L = -cam.f * diag(1./cam.rho) * L;
