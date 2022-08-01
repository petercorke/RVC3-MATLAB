function T = trvec2tform2d(t)
%TRVEC2TFORM2D Convert translation vector to homogeneous transformation
%   T= TRVEC2TFORM2D(t) converts the Cartesian representation of a 3D translation 
%   vector, t, into the corresponding homogeneous transformation, T.
%   The input, t, is an N-by-2 matrix containing N translation vectors. Each
%   vector is of the form [x y]. The output, T, is a 3-by-3-by-N matrix 
%   of N homogeneous transformations.
%
%   Example:
%      % Create homogeneous transformation from translation vector
%      t = [0.5 6];
%      T = trvec2tform2d(t)
%
%   See also tform2trvec2d, trvec2tform.

robotics.internal.validation.validateNumericMatrix(t, 'trvec2tform2d', 't', ...
    'ncols', 2);

numTransl = size(t, 1);

T = repmat(eye(3,'like',t),[1,1,numTransl]);
T(1:end-1,end,:) = t.';

end

