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
% See also SKEWA, VEX, Twist.


function s = skewa2vec(Omega)

if all(size(Omega) == [4 4])
    s = [skew2vec(Omega(1:3,1:3)) Omega(1:3,4)'];
elseif all(size(Omega) == [3 3 ])
    t = Omega(1:end-1,end,:);
    tr = permute(t,[3 1 2]);
    s = [skew2vec(Omega(1:2,1:2)) tr];
else
    error('SMTB:vexa:badarg', 'argument must be a 3x3 or 4x4 matrix');
end


end
