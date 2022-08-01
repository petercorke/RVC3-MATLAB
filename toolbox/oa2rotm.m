%OA2ROTM Convert orientation and approach vectors to rotation matrix
%
% R = OA2ROTM(O, A) is an SO(3) rotation matrix (3x3) for the specified
% orientation and approach vectors (3x1) formed from 3 vectors such that R
% = [N O A] and N = O x A.
%
% Notes::
% - The matrix is guaranteed to be orthonormal so long as O and A 
%   are not parallel.
% - The vectors O and A are parallel to the Y- and Z-axes of the coordinate
%   frame respectively.
%
% References::
% - Robot manipulators: mathematics, programming and control
%   Richard Paul, MIT Press, 1981.
%
% See also eul2rotm.


function R = oa2rotm(o, a)

    assert( nargin >= 2 && isvec(o) && isvec(a), 'SMTB:oa2rotm:badarg', 'bad arguments');

    o = o(:); a = a(:);
	n = cross(o, a);
    o = cross(a, n);
	R = [unit(n(:)) unit(o(:)) unit(a(:))];
end
