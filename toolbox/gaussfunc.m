%GAUSSFUNC	Gaussian kernel
%
%	G = GAUSSFUNC(MEAN, VARIANCE, X) is the value of the normal
%	distribution (Gaussian) function with MEAN (1x1) and VARIANCE (1x1), at
%   the point X.
%
%	G = GAUSSFUNC(MEAN, COVARIANCE, X, Y) is the value of the bivariate
%	normal distribution (Gaussian) function with MEAN (1x2) and COVARIANCE
%	(2x2), at the point (X,Y).
%
%   G = GAUSSFUNC(MEAN, COVARIANCE, X) as above but X (NxM) and the result
%   is also (NxM).  X and Y values come from the column and row indices of
%   X.
%
% Notes::
% - X or Y can be row or column vectors, and the result will also be a vector.
% - The area or volume under the curve is unity.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function g = gaussfunc(mu, variance, x, y)

    if length(mu) == 1
        % 1D case
        assert(all(size(variance) == [1 1]), 'covariance must be a 1x1 matrix')
                
        g = 1/sqrt(2*pi*variance) * exp( -((x-mu).^2)/(2*variance) );
    elseif length(mu) == 2
        % 2D case
        assert(length(mu) == 2, 'mean must be a 2-vector');
        assert(all(size(variance) == [2 2]), 'covariance must be a 2x2 matrix')
        
        if nargin < 4
            [x,y] = imeshgrid(x);
        end
        xx = x(:)-mu(1); yy = y(:)-mu(2);
        ci = inv(variance);
        g = 1/(2*pi*sqrt(det(variance))) * exp( -0.5*(xx.^2*ci(1,1) + yy.^2*ci(2,2) + 2*xx.*yy*ci(1,2)));
        g = reshape(g, size(x));
    end
