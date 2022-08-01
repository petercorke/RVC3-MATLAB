%BOUNDMATCH Match boundary profiles
%
% X = BOUNDMATCH(R1, R2) is the correlation of the two boundary profiles
% R1 and R2.  Each is an Nx1 vector of distances from the centroid of
% an object to points on its perimeter at equal angular increments spanning
% 2pi radians.  X is also Nx1 and is a correlation whose peak indicates the
% relative orientation of one profile with respect to the other.
%
% [X,S] = BOUNDMATCH(R1, R2) as above but also returns the relative scale
% S which is the size of object 2 with respect to object 1.
%
% Notes::
% - Can be considered as matching two functions defined over S(1).
%
% See also RegionFeature.boundary, XCORR.


% Copyright (C) 1993-2011, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
%
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
%
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function [s,kk] = boundmatch(r1, r2, varargin)




assert(size(r1,1) == size(r2,1), 'r1 and r2 must have same number of rows');

opt.normalize = true;
opt = tb_optparse(opt, varargin);
if opt.normalize
    r1 = r1/sum(r1);
    r2 = bsxfun(@times, r2, 1./sum(r2));
end
r1 = r1 - mean(r1);
r2 = bsxfun(@minus, r2, mean(r2));

ss1 = sum(r1.^2);


for i=1:size(r2,2)
    r = r2(:,i);
    ss2 = sum(r.^2);
    denom = sqrt(ss1 * ss2);
    z = zeros(size(r1));

    for j=1:length(r1)
        rs = circshift(r, j-1);
        z(j) = (r1' * rs) / denom;
    end

    [s(i),idx(i)] = max(z);
end
if nargout > 1
    kk = idx;
end
end
