%DECOMPOSECAM	Inverse camera calibration
%
%	c = DECOMPOSECAM(C)
%
% 	Decompose, or invert, a 3x4camera calibration matrix C.
%   The result is a camera object with the following parameters set:
%      f
%      sx, sy  (with sx=1)
%      (u0, v0)  principal point
%	   Tcam is the homog xform of the world origin wrt camera
%
% Since only f.sx and f.sy can be estimated we set sx = 1.
%
% REF:	Multiple View Geometry, Hartley&Zisserman, p 163-164
%
% SEE ALSO: camera

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function c = decomposeCam(C)

    if ~all(size(C) == [3 4])
        error('argument is not a 3x4 matrix');
    end
    [u,s,v] = svd(C);

    t = v(:,4);
    t = t / t(4);
    t = t(1:3);

    M = C(1:3,1:3);
    
    % M = K * R
    [K,R] = vgg_rq(M);

    % deal with K having negative elements on the diagonal
    
    % make a matrix to fix this, K*C has positive diagonal
    C = diag(sign(diag(K)));
    
    % now  K*R = (K*C) * (inv(C)*R), so we need to check C is a proper rotation
    % matrix.  If isn't then the situation is unfixable
    assert(det(C) == 1, 'MVTB:decomposeCam', 'cannot correct signs in the intrinsic matrix');
    
    % all good, let's fix it
    K = K * C;
    R = C' * R;
    
    % normalize K so that lower left is 1
    K = K/K(3,3);
    
    % pull out focal length and scale factors
    f = K(1,1);
    s = [1 K(2,2)/K(1,1)];

    % build an equivalent camera model
    c = CentralCamera( 'name', 'decomposeCam', ...
        'focal', f, ...
        'center', K(1:2,3), ...
        'pixel', s, ...
        'pose', [R' t; 0 0 0 1] );
