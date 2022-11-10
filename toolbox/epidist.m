%EPIDIST Distance of point from epipolar line
%
% D = EPIDIST(F, P1, P2) is the distance of the points P2 (2xM) from the 
% epipolar lines due to points P1 (2xN) where F (3x3) is a fundamental matrix
% relating the views containing image points P1 and P2.
%
% D (NxM) is the distance matrix where element D(i,j) is the distance 
% from the point P2(j) to the epipolar line due to point P1(i).
%
% Author::
% Based on fmatrix code by,
% Nuno Alexandre Cid Martins,
% Coimbra, Oct 27, 1998,
% I.S.R.
%
% See also EPILINE, FMATRIX.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function d = epidist(F, p1, p2)

    l = F*e2h(p1)';
    for i=1:size(p1,1),
        for j=1:size(p2,1),
            d(i,j) = abs(l(1,i)*p2(j,1) + l(2,i)*p2(j,2) + l(3,i)) ./ sqrt(l(1,i)^2 + l(2,i)^2);
        end
    end
