%SKEW2VEC Convert skew-symmetric matrix to vector
%
% V = SKEW2VEC(S) is the vector which has the corresponding skew-symmetric
% matrix S.
%
% V = SKEW2VEC(S, C) as above but checks that the matrix is skew symmetric,
% that norm(S+S') < C*eps.
%
% In the case that S (2x2) =
%
%           | 0  -v |
%           | v   0 |
%
% then V = [v].  In the case that S (3x3) =
%
%           |  0  -vz   vy |
%           | vz    0  -vx |
%           |-vy   vx    0 |
%
% then V = [vx vy vz].
%
% Notes:
% - This is the inverse of the function VEC2SKEW().
% - The function takes the mean of the two elements that correspond to
%   each unique element of the matrix.
% - The matrices are the generator matrices for so(2) and so(3).
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Chapter 2
%
% See also VEC2SKEW, SKEWA2VEC.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function v = skew2vec(S, check)
    arguments
        S double
        check (1,1) double = 0
    end

    if check > 0
        if norm(S+S') > check*eps
            error("RVC3:skew2vec:badarg", "argument is not skew symmetric");
        end
    end

    if all(size(S) == [3 3])
        v = 0.5*[S(3,2)-S(2,3) S(1,3)-S(3,1) S(2,1)-S(1,2)];
    elseif all(size(S) == [2 2])
        v = 0.5*(S(2,1)-S(1,2));
    else
        error("RVC3:skew2vec:badarg", "argument must be a 2x2 or 3x3 matrix");
    end
end