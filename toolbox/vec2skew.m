%VEC2SKEW Create skew-symmetric matrix
%
% S = VEC2SKEW(V) is a skew-symmetric matrix formed from V.
%
% If V (1x1) then S =
%
%           | 0  -v |
%           | v   0 |
%
% and if V (1x3) then S =
%
%           |  0  -vz   vy |
%           | vz    0  -vx |
%           |-vy   vx    0 |
%
%
% Notes:
% - This is the inverse of the function SKEW2VEC().
% - These are the generator matrices for the Lie algebras so(2) and so(3).
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Chapter 2
%
% See also VEC2SKEWA, SKEW2VEC.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function S = vec2skew(v)
    arguments
        v double
    end

    switch numel(v)
        case 3
            % SO(3) case
            S = [
                  0      -v(3)  v(2)
                  v(3)    0    -v(1)
                 -v(2)    v(1)  0     ];
        case 1
            % SO(2) case
            S = [
                  0  -v
                  v   0]    ;
        otherwise
            error("RVC3:vec2skew:badarg", "argument must be a 1- or 3-vector");
    end
end
