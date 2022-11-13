%MPQ_POINT Compute moments of image points
%
% M = MPQ_POINT(POINTS, P, Q) is the PQ'th moment of the set of points POINTS.
% That is, the sum of x^P y^Q where (x,y) are the rows of POINTS.
%
% See also MPQ.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function m = mpq_point(points, p, q)

    x = points(1,:);
    y = points(2,:);

    m = sum(x.^p .* y.^q);
    
