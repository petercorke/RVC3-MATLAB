function t = tform2trvec2d(T)
%TFORM2TRVEC2D Extract 2D translation vector from homogeneous transformation
%   t = TFORM2TRVEC2D(T) extracts the translation vector, t, from a 2D homogeneous
%   transformation, T, and returns it. The rotational components of T
%   will be ignored.
%   The input, T, is an 3-by-3-by-N matrix of N homogeneous transformations.
%   The output, t, is an N-by-2 matrix containing N translation vectors. Each
%   vector is of the form [x y].
%
%   Example:
%      % Extract translation vector from homogeneous transformation
%      T = [1 0 0.5; 0 -1 5; 0 0 1];
%      t = tform2trvec2d(T)
%
%   See also trvec2tform2d, tform2trvec.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

validateattributes(T, {'single','double','sym'}, {'nonempty','real','3d', ...
    'size',[3 3 NaN]}, 'tform2trvec2d', 'T'); 

% Also normalize by last element in matrix
tr = T(1:end-1,end,:) ./ repmat(T(end,end,:), [2 1 1]);
t = permute(tr,[3 1 2]);

end

