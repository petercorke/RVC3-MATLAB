%CentralCamera.visjac_l Visual motion Jacobian for line feature
%
% J = C.visjac_l(L, PL) is the image Jacobian (2Nx6) for the image plane 
% lines L (2xN).  Each column of L is a line in theta-rho format, and the 
% rows are theta and rho respectively.
%
% The lines all lie in the plane PL = (a,b,c,d) such that aX + bY + cZ + d = 0.
%
% The Jacobian gives the rates of change of the line parameters in 
% terms of camera spatial velocity. 
%
% Reference::
% B. Espiau, F. Chaumette, and P. Rives,
% "A New Approach to Visual Servoing in Robotics",
% IEEE Transactions on Robotics and Automation, 
% vol. 8, pp. 313-326, June 1992.
%
% See also CentralCamera.visjac_p, CentralCamera.visjac_p_polar, CentralCamera.visjac_e.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function L = visjac_l(cam, f, plane)

    if numcols(f) > 1
        L = [];
        % recurse for each point
        for i=1:numcols(f)
            L = [L; cam.visjac_l(f(:,i), plane(:,i))];
        end
        return;
    end
    
    theta = f(1); rho = f(2);
    sth = sin(theta); cth = cos(theta);

    a = plane(1); b = plane(2); c = plane(3); d = plane(4);

    lam_th = (-a*cth + b*sth ) / d;
    lam_rho = (a*rho*sth + b*rho*cth + c) / d;

    L = [
        lam_th*sth, lam_th*cth,  -rho*lam_th, rho*sth, rho*cth, 1 
        lam_rho*sth, lam_rho*cth, -lam_rho*rho, cth*(1 + rho^2), -sth*(1 + rho^2), 0
    ];



