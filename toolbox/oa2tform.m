%OA2TFORM Convert orientation and approach vectors to homogeneous transformation
%
% T = OA2TFORM(O, A) is an SE(3) homogeneous tranformation (4x4) for the
% specified orientation and approach vectors (3x1) formed from 3 vectors
% such that R = [N O A] and N = O x A.
%
% Notes::
% - The rotation submatrix is guaranteed to be orthonormal so long as O and A 
%   are not parallel.
% - The vectors O and A are parallel to the Y- and Z-axes of the coordinate
%   frame respectively.
% - The translational part is zero.
%
% References::
% - Robot manipulators: mathematics, programming and control
%   Richard Paul, MIT Press, 1981.
%
% See also eul2tform, SE3.OA.


function r = oa2tform(o, a)
    assert( nargin >= 2 && isvec(o) && isvec(a), 'SMTB:oa2tform:badarg', 'bad arguments');
    
	n = cross(o, a);
    o = cross(a, n);
	r = [unit(n(:)) unit(o(:)) unit(a(:)) zeros(3,1); 0 0 0 1];
end
