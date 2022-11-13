%T2R Rotational submatrix
%
% R = T2R(T) is the orthonormal rotation matrix component of homogeneous
% transformation matrix T.  Works for T in SE(2) or SE(3)
% - If T is 4x4, then R is 3x3.
% - If T is 3x3, then R is 2x2.
%
% Notes::
% - For a homogeneous transform sequence (KxKxN) returns a rotation matrix
%   sequence (K-1xK-1xN).
% - The validity of rotational part is not checked
%
% See also R2T, TR2RT, RT2TR.

%## 2d 3d homogeneous

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function R = t2r(T)

assert(isfloat(T), 'SMTB:t2r:badarg', 'expecting real matrix argument');

% check dimensions: T is SE(2) or SE(3)
d = size(T);
assert(d(1) == d(2), 'SMTB:t2r:badarg', 'matrix must be square');
assert(any(d(1) == [3 4]), 'SMTB:t2r:badarg', 'argument is not a homogeneous transform (sequence)');

n = d(1);     % works for SE(2) or SE(3)

if numel(d) == 2
    % single matrix case
    R = T(1:n-1,1:n-1);
else
    %  matrix sequence case
    R = zeros(n-1,n-1,d(3));
    for i=1:d(3)
        R(:,:,i) = T(1:n-1,1:n-1,i);
    end
end

end
