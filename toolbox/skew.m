%SKEW Create skew-symmetric matrix
%
% S = SKEW(V) is a skew-symmetric matrix formed from V.
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
% Notes::
% - This is the inverse of the function skew2vec().
% - These are the generator matrices for the Lie algebras so(2) and so(3).
%
% References::
% - Robotics, Vision & Control: Second Edition, Chap 2,
%   P. Corke, Springer 2016.
%
% See also SKEWA, SKEW2VEC.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function S = skew(v)
    if isvec(v,3)
        % SO(3) case
        S = [  0   -v(3)  v(2)
              v(3)  0    -v(1)
             -v(2) v(1)   0];
    elseif isvec(v,1)
        % SO(2) case
        S = [0 -v; v 0];
    else
        error('argument must be a 1- or 3-vector');
    end
