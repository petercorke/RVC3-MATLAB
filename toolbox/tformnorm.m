%TFORMNORM Normalize an SO(3) or SE(3) matrix
%
% TFORMNORM(R) is guaranteed to be a proper orthogonal matrix rotation
% matrix (3x3) which is "close" to the input matrix R (3x3). If R
% = [N,O,A] the O and A vectors are made unit length and the normal vector
% is formed from N = O x A, and then we ensure that O and A are orthogonal
% by O = A x N.
%
% TFORMNORM(T) as above but the rotational submatrix of the homogeneous
% transformation T (4x4) is normalised while the translational part is
% unchanged.
%
% If R (3x3xK) or T (4x4xK) representing a sequence then the normalisation
% is performed on each of the K planes.
%
% Notes::
% - Only the direction of A (the z-axis) is unchanged.
% - Used to prevent finite word length arithmetic causing transforms to
%   become `unnormalized'.
% - There is no Toolbox function for SO(2) or SE(2).
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Chapter 2

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function TR = tformnorm(X)

    if isa(X, "se3")
        T = X.tform();
    elseif isa(X, "so3")
        T = X.rotm;
    else
        T = X;
    end

    assert(istform(T) || isrotm(T), 'RVC3:tformnorm:badarg', 'expecting 3x3xN or 4x4xN matrices or se3 or so3');
    
    n = size(T,3);
    TN = T;
    for i=1:n
        o = T(1:3,2,i); a = T(1:3,3,i);
        n = cross(o, a);         % N = O x A
        o = cross(a, n);         % O = A x N
        R = [unitvector(n) unitvector(o) unitvector(a)];

        TN(1:3,1:3,i) = R;
    end

    if istform(X)
        TR = TN;
    elseif isrotm(X)
        TR = TN;
    elseif isa(X, "se3")
        TR = se3(TN);
    elseif isa(X, "so3")
        TR = so3(TN);
    end

end