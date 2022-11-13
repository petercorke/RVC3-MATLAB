%boundary2polar Boundary in polar form
%
% [D,TH] = boundary2polar(b, r) is a polar representation of the boundary
% with respect to the centroid.  D(i) and TH(i) are the distance to the
% boundary point and the angle respectively.  These vectors have 400
% elements irrespective of region size.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function [ri,thi] = boundary2polar(b, R)
% xxx parse inputs


ri = []; thi = [];

numBlobs = size(b,1);

for i = 1:numBlobs
    rc2xyBoundary = fliplr(b{i});
    dxy =  rc2xyBoundary - R(i).Centroid;

    dxy = dxy';

    r = sqrt(sum(dxy.^2))';
    th = -atan2(dxy(2,:), dxy(1,:));

    s = linspace(1, length(r), 400)';
    ri = [ri interp1(1:length(r), r, s, 'spline')];
    if nargout > 1
        thi = [thi interp1(1:length(th), th, s, 'spline')];
    end
end
end
