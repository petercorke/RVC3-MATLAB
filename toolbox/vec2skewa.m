%VEC2SKEWA Create augmented skew-symmetric matrix
%
% S = VEC2SKEWA(V) is an augmented skew-symmetric matrix formed from V.
%
% If V (1x3) then S =
%
%               |  0  -v1  v2 |
%               | v1    0  v3 |
%               |  0    0   0 |
%
% and if V (1x6) then S =
%
%               |  0  -v3   v2  v4 |
%               | v3    0  -v1  v5 |
%               |-v2   v1    0  v6 |
%               |  0    0    0   0 |
%
% Notes:
% - This is the inverse of the function SCEW2VECA().
% - These are the generator matrices for the Lie algebras se(2) and se(3).
% - Map twist vectors in 2D and 3D space to se(2) and se(3).
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Chapter 2
%
% See also VEC2SKEW, SKEWA2VEC, Twist.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function Omega = vec2skewa(s)
    arguments
        s double
    end
    
    s = s(:);
    switch length(s)
        case 3
            Omega = [vec2skew(s(1)) s(2:3); 0 0 0];
            
        case 6
            Omega = [vec2skew(s(1:3)) s(4:6); 0 0 0 0];
            
        otherwise
            error("RVC3:vec2skewa:badarg", "expecting a 3- or 6-vector");
    end
end
