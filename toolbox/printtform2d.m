%PRINTTFORM2D Compact display of SE(2) homogeneous transformation
%
% PRINTTFORM2D(T, OPTIONS) displays the homogoneous transform (4x4) in a compact
% single-line format.  If T is a homogeneous transform sequence then each
% element is printed on a separate line.  T can also be an object of type
% se3, rigidtform3d or Twist.
%
% PRINTTFORM2D(R, OPTIONS) as above but displays the SO(3) rotation matrix (3x3).
% R can also be an object of type so3.
%
% S = PRINTTFORM2D(T, OPTIONS) as above but returns the string.
%
% >> PRINTTFORM2D T OPTIONS is the command line form of above.
%
% Options::
% 'radian'     display angle in radians (default is degrees)
% 'fmt', f     use format string f for all numbers, (default %g)
% 'label',l    display the text before the transform
% 'fid',F      send text to the file with file identifier F
%
% Examples::
%        >> trprint(T2)
%        t = (0,0,0), RPY/zyx = (-122.704,65.4084,-8.11266) deg
%
%        >> trprint(T1, 'label', 'A')
%               A:t = (0,0,0), RPY/zyx = (-0,0,-0) deg
%
%       >> trprint B euler
%       t = (0.629, 0.812, -0.746), EUL = (125, 71.5, 85.7) deg
%
% Notes::
% - If the 'rpy' option is selected, then the particular angle sequence can be
%   specified with the options 'xyz' or 'yxz' which are passed through to TR2RPY.
%  'zyx' is the default.
%
% See also TR2EUL, TR2RPY, TR2ANGVEC.

%## 3d homogeneous

% Copyright (C) 1993-2019 Peter I. Corke


function out = printtform2d(X, varargin)

    opt.fmt = [];
    opt.mode = {'rpy', 'euler', 'axang'};
    opt.unit = 'rad';
    opt.label = [];
    opt.fid = 1;


    opt.dim = 2;


    [opt,args] = tb_optparse(opt, varargin);

    if isa(X,'se2')
        X = X.tform;
    elseif isa(X,'so2')
        X = X.rotm;        
    elseif isa(X, 'Twist2')
        X = X.tform;
    end

% Do not print the variable name. It's not very useful.
    if isempty(opt.label)
        opt.label = inputname(1);
    end

    s = '';

    if size(X,3) == 1
        if isempty(opt.fmt)
            opt.fmt = '%.3g';
        end
        s = tr2s2d(X, opt, args{:});

    else
        if isempty(opt.fmt)
            opt.fmt = '%8.2g';
        end
        
        for i=1:size(X,3)
            % for each matrix in a 3D array
            s = char(s, tr2s2d(X(:,:,i), opt, args{:}) );
        end
    end

    % if no output provided then display it
    if nargout == 0
        for row=s'
            fprintf(opt.fid, '%s\n', row);
        end
    else
        out = s;
    end
end

function s = tr2s2d(T, opt, varargin)
    % print the translational part if it exists
    if ~isempty(opt.label)
        s = sprintf('%8s: ', opt.label);
    else
        s = '';
    end
    if all(size(T) == [3 3])
        % tform
        s = [s, sprintf('t = (%s),', vec2s(opt.fmt, [T(1,3);T(2,3)]))];
        R = T(1:2,1:2);
    else
        R = T;
    end

    % print just the angle
    ang = atan2(R(2,1), R(1,1));

    if strcmp(opt.unit, 'deg')
        s = strcat(s, ...
            sprintf(' %s deg', vec2s(opt.fmt, ang*180.0/pi)) );
    else
        s = strcat(s, ...
            sprintf(' %s rad', vec2s(opt.fmt, ang)) );
    end
end


function s = vec2s(fmt, v)
    s = '';
    for i=1:length(v)
        if abs(v(i)) < 1e-12
            v(i) = 0;
        end
        s = [s, sprintf(fmt, v(i))]; %#ok<AGROW>
        if i ~= length(v)
            s = [s, ', ']; %#ok<AGROW> % don't use strcat, removes trailing spaces
        end
    end
end
