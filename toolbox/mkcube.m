%MKCUBE Create cube
%
% P = MKCUBE(S, OPTIONS) is a set of points (3x8) that define the 
% vertices of a cube of side length S and centered at the origin.
%
% [X,Y,Z] = MKCUBE(S, OPTIONS) as above but return the rows of P as three 
% vectors.
%
% [X,Y,Z] = MKCUBE(S, 'edge', OPTIONS) is a mesh that defines the edges of
% a cube.
%
% Options::
% 'facepoint'    Add an extra point in the middle of each face, in this case
%                the returned value is 3x14 (8 vertices + 6 face centers).
% 'center',C     The cube is centered at C (3x1) not the origin
% 'pose',T       The pose of the cube coordinate frame is defined by the homogeneous transform T,
%                allowing all points in the cube to be translated or rotated.
% 'edge'         Return a set of cube edges in MATLAB mesh format rather
%                than points.
%
% See also CYLINDER, SPHERE.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function [o1,o2,o3] = mkcube(s, varargin)
    
    opt.center = [];
    opt.pose = [];
    opt.edge = false;
    opt.facepoint = false;

    [opt,args] = tb_optparse(opt, varargin);
    if ~isempty(args) && istform(args{1})
        % compatible with legacy call
        opt.pose = args{1};
    end
 
    % offset it
    if ~isempty(opt.center)
        assert(isvec(opt.center,3), 'Center must be a 3-vector');
        assert(isempty(opt.pose), 'Cannot specify center and pose options');
        opt.pose = se3(trvec2tform(opt.center(:)'));
    end

    % vertices of a unit cube with one corner at origin
    cube = [
       -1    -1     1     1    -1    -1     1     1
       -1     1     1    -1    -1     1     1    -1
       -1    -1    -1    -1     1     1     1     1 ]';

    if opt.facepoint
        % append face center points if required
        faces = [
          1    -1     0     0     0     0
          0     0     1    -1     0     0
          0     0     0     0     1    -1 ]';
        cube = [cube; faces];
    end

    % vertices of cube about the origin
    if isvec(s,3)
        s = diag(s);
    end
    cube = s * cube / 2;


    % optionally transform the vertices
    if ~isempty(opt.pose)
        cube = homtrans(opt.pose.tform, cube);
    end

    if opt.edge == false
        % point model, return the vertices
        if nargout <= 1
            o1 = cube;
        elseif nargout == 3
            o1 = cube(1,:);
            o2 = cube(2,:);
            o3 = cube(3,:);
        end
    else
        % edge model, return plaid matrices
        cube = cube([1:4 1 5:8 5], :);
        o1 = reshape(cube(:,1)', 5, 2)';
        o2 = reshape(cube(:,2)', 5, 2)';
        o3 = reshape(cube(:,3)', 5, 2)';
    end
