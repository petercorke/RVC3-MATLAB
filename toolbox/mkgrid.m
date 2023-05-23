%MKGRID Create grid of points
%
% P = MKGRID(D, S, OPTIONS) is a set of 3D points (D^2x3) that define a DxD
% planar grid of points with side length S.  The points are the rows of
% P. If D is a 2-vector the grid is D(1)xD(2) points.  If S is a 2-vector
% the side lengths are S(1)xS(2).
%
% By default the grid lies in the XY plane, symmetric about the origin.
%
% Options::
% 'pose',T   The pose of the grid coordinate frame is defined by the 
%            homogeneous transform T, allowing all points in the plane 
%            to be translated or rotated.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function p = mkgrid(N, s, varargin)
    
    opt.pose = [];

    [opt,args] = tb_optparse(opt, varargin);
    
    if ~isempty(args) && istform(args{1})
        % compatible with legacy call
        opt.pose = args{1};
    end
    if length(s) == 1
        sx = s; sy = s;
    else
        sx = s(1); sy = s(2);
    end

    if length(N) == 1
        nx = N; ny = N;
    else
        nx = N(1); ny = N(2);
    end

    if any(N<=1)
        error('RVCtoolbox: number of points must be > 1');
    end

    if N == 2
        % special case, we want the points in specific order
        p = [-sx -sy 0
             -sx  sy 0
              sx  sy 0
              sx -sy 0]/2;
    else
        [X, Y] = meshgrid(1:nx, 1:ny);
        X = ( (X-1) / (nx-1) - 0.5 ) * sx;
        Y = ( (Y-1) / (ny-1) - 0.5 ) * sy;
        Z = zeros(size(X));
        p = [X(:) Y(:) Z(:)];
    end
    
    % optionally transform the points
    if ~isempty(opt.pose)
        pose = se3(opt.pose);
        % WJ: this call was stripping the translation p = SE3.check(opt.pose) * p;
        p = pose.transform(p);
    end
