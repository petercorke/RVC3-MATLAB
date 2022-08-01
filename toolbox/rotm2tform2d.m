function T = rotm2tform2d(R)
%ROTM2TFORM2D Convert 2D rotation matrix to homogeneous transform
%   T = ROTM2TFORM2D(R) converts the 2D rotation matrix, R, into a homogeneous
%   transformation, T. T will have no translational components.
%   R is an 2-by-2-by-N matrix containing N rotation matrices.
%   Each rotation matrix has a size of 2-by-2 and is orthonormal.
%   The output, T, is an 3-by-3-by-N matrix of N homogeneous transformations.
%
%   Example:
%      % Convert a rotation matrix to a homogeneous transformation
%      R = [1 0; 0 -1]
%      T = rotm2tform2d(R)
%
%   See also tform2rotm2d, rotm2tform.

% Ortho-normality is not tested, since this validation is expensive
validateattributes(R, {'single','double'}, {'nonempty', ...
    'real','3d','size',[2 2 NaN]}, 'rotm2tform2d', 'R'); 

numMats = size(R,3);

% The rotational components of the homogeneous transformation matrix
% are located in elements T(1:2,1:2).
T = zeros(3,3,numMats,'like',R);
T(1:2,1:2,:) = R;
T(3,3,:) = ones(1,1,numMats,'like',R);

end

