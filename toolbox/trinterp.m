%TRINTERP Interpolate SE(3) homogeneous transformations
%
% TRINTERP(T0, T1, S) is a homogeneous transform (4x4) interpolated
% between T0 when S=0 and T1 when S=1.  T0 and T1 are both homogeneous
% transforms (4x4).  If S (Nx1) then T (4x4xN) is a sequence of
% homogeneous transforms corresponding to the interpolation values in S.
%
% TRINTERP(T1, S) as above but interpolated between the identity matrix
% when S=0 to T1 when S=1.
%
% TRINTERP(T0, T1, M) as above but M is a positive integer and return a
% sequence (4x4xM) of homogeneous transforms linearly interpolating between
% T0 and T1 in M steps.
%
% TRINTERP(T1, M) as above but return a sequence (4x4xM) of
% homogeneous interpolating between identity matrix and T1 in M steps.
%
% Notes::
% - T0 or T1 can also be an SO(3) rotation matrix (3x3) in which case the
%   result is (3x3xN).
% - Rotation is interpolated using quaternion spherical linear interpolation (slerp).
% - To obtain smooth continuous motion S should also be smooth and continuous,
%   such as computed by tpoly or lspb.
%
% See also TRINTERP2, CTRAJ, SE3.interp, UnitQuaternion, TPOLY, LSPB.

%## 3d homogeneous trajectory

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function T = trinterp(A, B, C)

if nargin == 3
    %	TRINTERP(T0, T1, s)
    T0 = A; T1 = B; s = C(:)';
    
    if length(s) == 1 && s > 1 && (s == floor(s)) %#ok<BDSCI>
        % TRINTERP(T0, T1, M)
        s = linspace(0, 1, s);
    end
    assert(all(s>=0 & s<=1), 'SMTB:trinterp:badarg', 'values of S outside interval [0,1]');
    
    q0 = quaternion(t2r(T0), 'rotmat', 'point');
    q1 = quaternion(t2r(T1), 'rotmat', 'point');
    
    p0 = tform2trvec(T0);
    p1 = tform2trvec(T1);
    
    for i=1:length(s)
        qr = q0.slerp(q1, s(i));
        pr = p0 * (1 - s(i)) + s(i) * p1;
        T(:,:,i) = trvec2tform(pr) * rotm2tform(qr.rotmat('point')); %#ok<AGROW>
    end
elseif nargin == 2
    %	TRINTERP(T, s)
    T0 = A; s = B(:)';
    
    if length(s) == 1 && s > 1 && (s == floor(s)) %#ok<BDSCI>
        % TRINTERP(T0, T1, M)
        s = linspace(0, 1, s);
    elseif any(s<0 | s>1)
        error('SMTB:trinterp:badarg', 'values of S outside interval [0,1]');
    end
    
    q0 = quaternion(t2r(T0), 'rotmat', 'frame');
    p0 = tform2trvec(T0);
    q1 = quaternion([1 0 0 0]);
    for i=1:length(s)
        qr = q1.slerp(q0, s(i));
        pr = s(i) * p0;
        T(:,:,i) = trvec2tform(pr) * rotm2tform(qr.rotmat("point")); %#ok<AGROW>
    end
    
else
    error('SMTB:trinterp:badarg', 'must be 2 or 3 arguments');
end

end
