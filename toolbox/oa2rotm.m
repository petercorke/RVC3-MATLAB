%OA2ROTM Convert orientation and approach vectors to rotation matrix
%
% R = OA2ROTM(O, A) is an SO(3) rotation matrix (3x3) for the specified
% orientation and approach vectors (3x1) formed from 3 vectors such that R
% = [N O A] and N = O x A.
%
% Notes:
% - The matrix is guaranteed to be orthonormal so long as O and A 
%   are not parallel.
% - The vectors O and A are parallel to the Y- and Z-axes of the coordinate
%   frame respectively.
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Chapter 2
%
% See also OA2TFORM.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function R = oa2rotm(o, a)
    arguments
        o (3,1)
        a (3,1)
    end

	n = cross(o, a);
    o = cross(a, n);
	R = [unitvector(n) unitvector(o) unitvector(a)];
end
