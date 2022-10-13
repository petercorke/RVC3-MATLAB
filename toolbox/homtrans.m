%HOMTRANS Apply a homogeneous transformation to points
%
% Q = HOMTRANS(T, P) applies the homogeneous transformation T to the
% coordinate vectors stored rowwise in P.
%
% * If T is in SE(2) (3x3) and
%   - P is Nx2 (2D points) they are considered Euclidean (R^2)
%   - P is Nx3 (2D points) they are considered projective (P^2)
% * If T is in SE(3) (4x4) and
%   - P is Nx3 (3D points) they are considered Euclidean (R^3)
%   - P is Nx4 (3D points) they are considered projective (P^3)
%
% Q and P have the same number of columns, ie. if Euclidean coordinate
% vectors are given then Euclidean coordinate vectors are returned, if
% projective coordinate vectors are given then projective coordinate
% vectors are returned.
%
% Notes:
% - If T is a homogeneous transformation defining the pose of {B} with
%   respect to {A}, then the points P are defined with respect to frame {B}
%   and are transformed Q to be with respect to frame {A}.
%
% See also E2H, H2E.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function pt = homtrans(T, pts)
    arguments
        T double
        pts double
    end

    if size(pts,2) == size(T,1)
        % points are in projective coordinate
        pt = pts * T';  % pt = (T * p')'
    elseif (size(T,1)-size(pts,2)) == 1
        % points are in Euclidean coordinates, promote to homogeneous
        % xxx, Remo, this is a bug:  pt = hom2cart( cart2hom(p') * T )';
        pt = h2e(e2h(pts) * T');  % pt = h2e((T * e2h(p)')')
    else
        error('RVC3:homtrans:badarg', 'matrices and point data do not conform')
    end
end
