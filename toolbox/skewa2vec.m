%SKEWA2VEC Convert augmented skew-symmetric matrix to vector
%
% V = SKEWA2VEC(S) is the vector which has the corresponding augmented skew-symmetric
% matrix S.
%
% In the case that S (3x3) =
%
%               |  0  -v1  v2 |
%               | v1    0  v3 |
%               |  0    0   0 |
%
% then V = [v1 v2 v3].  In the case that S (6x6) =
%
%
%               |  0  -v3   v2  v4 |
%               | v3    0  -v1  v5 |
%               |-v2   v1    0  v6 |
%               |  0    0    0   0 |
%
% then V = [v1 v2 v3 v4 v5 v6].
%
% Notes::
% - This is the inverse of the function VEC2SKEWA().
% - The matrices are the generator matrices for se(2) and se(3).  The elements
%   comprise the equivalent twist vector.
%
% References::
% - Robotics, Vision & Control: Second Edition, Chap 2,
%   P. Corke, Springer 2016.
%
% See also VEC2SKEWA, SKEW2VEC, Twist.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function s = skewa2vec(Omega, check)
    arguments
        Omega double {mustBeReal}
        check (1,1) double = 0
    end

    dims = size(Omega);
    if dims(1) ~= dims(2) || ~any(dims(1) == [3 4])
        error("RVC3:skewa2vec:badarg", "argument must be a 3x3 or 4x4 matrix");
    end

    ss = Omega(1:end-1,1:end-1);  % skew symmetric part
    t = Omega(1:end-1,end);       % translation part
    s = [skew2vec(ss, check) t'];
end
