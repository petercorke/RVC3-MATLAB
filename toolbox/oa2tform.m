%OA2TFORM Convert orientation and approach vectors to homogeneous transformation
%
% T = OA2TFORM(O, A) is an SE(3) homogeneous tranformation (4x4) for the
% specified orientation and approach vectors (1x3) formed from 3 vectors
% such that R = [N O A] and N = O x A.
%
% Notes::
% - The rotation submatrix is guaranteed to be orthonormal so long as O and A 
%   are not parallel.
% - The vectors O and A are parallel to the Y- and Z-axes of the coordinate
%   frame respectively.
% - The translational part is zero.
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Chapter 2
%
% See also OA2ROTM.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function T = oa2tform(o, a)
    arguments
        o (3,1)
        a (3,1)
    end

	n = cross(o, a);
    o = cross(a, n);
	T = [unitvector(n) unitvector(o) unitvector(a) zeros(3,1); 0 0 0 1];
end
