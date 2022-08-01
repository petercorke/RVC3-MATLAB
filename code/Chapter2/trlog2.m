%TRLOG logarithm of SO(3) or SE(3) matrix
%
% S = trlog(R) is the matrix logarithm (3x3) of R (3x3)  which is a skew
% symmetric matrix corresponding to the vector theta*w where theta is the
% rotation angle and w (3x1) is a unit-vector indicating the rotation axis.
%
% [theta,w] = trlog(R) as above but returns directly theta the rotation
% angle and w (3x1) the unit-vector indicating the rotation axis.
%
% S = trlog(T) is the matrix logarithm (4x4) of T (4x4)  which has a (3x3)
% skew symmetric matrix upper left submatrix corresponding to the vector
% theta*w where theta is the rotation angle and w (3x1) is a unit-vector
% indicating the rotation axis, and a translation component.
%
% [theta,twist] = trlog(T) as above but returns directly theta the rotation
% angle and a twist vector (6x1) comprising [v w].
%
% Notes::
% - Efficient closed-form solution of the matrix logarithm for arguments that are
%   SO(3) or SE(3).
% - Special cases of rotation by odd multiples of pi are handled.
% - Angle is always in the interval [0,pi].
%
% References::
% - "Mechanics, planning and control"
%   Park & Lynch, Cambridge, 2016.

function [o1,o2] = trlog(T)
    
        
end

%     [th,w] = tr2angvec(R);
%     w = w'
%
%     d = dot(unit(w), transl(T))
%     h = d / th
%
%     q = (transl(T) - h*th*w ) * inv(eye(3,3) - R)
%
%     v =
%     rho = (eye(3,3) - R')*t / 2 / (1-cos(th));
%
%     v = cross(rho, w);
%
%     tw = [skew(unit(w)) v'; 0 0 0  0];