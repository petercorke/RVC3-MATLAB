%EUL2JAC Euler angle rate Jacobian
%
% J = EUL2JAC(PHI, THETA, PSI) is a Jacobian matrix (3x3) that maps ZYZ
% Euler angle rates to angular velocity at the operating point specified by
% the Euler angles PHI, THETA, PSI.
%
% J = EUL2JAC(EUL)  as above but the Euler angles are passed as a vector
% EUL=[PHI, THETA, PSI].
%
% Notes:: - Used in the creation of an analytical Jacobian. - Angles in
% radians, rates in radians/sec.
%
% Reference:: - Robotics, Vision & Control: Second Edition, P. Corke,
% Springer 2016; p232-3.
%
% See also rpy2jac, eul2r, SerialLink.jacobe.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function J = eul2jac(phi, theta, psi)

if length(phi) == 3
    % eul2jac([phi theta psi])
    theta = phi(2);
    psi = phi(3);
    phi = phi(1);
elseif nargin ~= 3
    error('RVC3:eul2jac:badarg', 'bad arguments');
end
J = [ 0, -sin(phi), cos(phi)*sin(theta)
    0,  cos(phi), sin(phi)*sin(theta)
    1,        0,           cos(theta) ];

end

