%HOMTRANS Apply a homogeneous transformation
%
% P2 = HOMTRANS(T, P) applies the homogeneous transformation T to the points
% stored rowwise in P.
%
% - If T is in SE(2) (3x3) and
%   - P is Nx2 (2D points) they are considered Euclidean (R^2)
%   - P is Nx3 (2D points) they are considered projective (P^2)
% - If T is in SE(3) (4x4) and
%   - P is Nx3 (3D points) they are considered Euclidean (R^3)
%   - P is Nx4 (3D points) they are considered projective (P^3)
%
% P2 and P have the same number of columns, ie. if Euclidean points are given
% then Euclidean points are returned, if projective points are given then
% projective points are returned.
%
% Notes::
% - If T is a homogeneous transformation defining the pose of {B} with
%   respect to {A}, then the points are defined with respect to frame {B}
%   and are transformed to be with respect to frame {A}.
%
% See also E2H, H2E.

% Copyright (C) 1993-2019 Peter I. Corke

function pt = homtrans(T, p)

if size(p,2) == size(T,1)
    if ndims(p) == 3
        % homtrans(T1, T2)
%         pt = [];
%         for i=1:size(p,3)
%             pt = cat(3, pt, T*p(:,:,i));
%         end
        error('this use case no longer supported, talk to Peter if you see this')
    else
        % points are in projective coordinate
        pt = p * T';  % pt = (T * p')'
    end
elseif (size(T,1)-size(p,2)) == 1
    % points are in Euclidean coordinates, promote to homogeneous
    % xxx, Remo, this is a bug:  pt = hom2cart( cart2hom(p') * T )';
    pt = h2e(e2h(p) * T');  % pt = h2e((T * e2h(p)')')
else
    error('SMTB:homtrans:badarg', 'matrices and point data do not conform')
end
