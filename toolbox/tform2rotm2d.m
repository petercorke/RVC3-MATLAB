function R = tform2rotm2d(T)
%TFORM2ROTM2D Extract rotation matrix from 2D homogeneous transformation
%   R = TFORM2ROTM2D(T) extracts the rotational component from a 2D homogeneous
%   transformation, T, and returns it as an orthonormal rotation matrix, R.
%   The translational components of T will be ignored.
%   The input, T, is an 3-by-3-by-N matrix of N homogeneous transformations.
%   The output, R, is an 2-by-2-by-N matrix containing N rotation matrices.
%
%   Example:
%      % Convert a homogeneous transformation in a rotation matrix
%      T = [1 0 0; 0 -1 0; 0 0 1];
%      R = tform2rotm(T)
%
%   See also rotm2tform2d, tform2rotm.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

validateattributes(T, {'single','double'}, {'nonempty','real','3d', ...
    'size', [3 3 NaN]}, 'tform2rotm2d', 'T'); 

R = T(1:2,1:2,:);

end

