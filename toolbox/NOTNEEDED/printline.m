%PRINTLINE Compact display of SE(3) homogeneous transformation
%
% PRINTLINE(T, OPTIONS) displays the homogoneous transform (4x4) in a compact
% single-line format.  If T is a homogeneous transform sequence then each
% element is printed on a separate line.
%
% PRINTLINE(R, OPTIONS) as above but displays the SO(3) rotation matrix (3x3).
%
% S = PRINTLINE(T, OPTIONS) as above but returns the string.
%
% PRINTLINE T OPTIONS is the command line form of above.
%
% Options::
% 'rpy'        display with rotation in ZYX roll/pitch/yaw angles (default)
% 'xyz'        change RPY angle sequence to XYZ
% 'yxz'        change RPY angle sequence to YXZ
% 'euler'      display with rotation in ZYZ Euler angles
% 'axang'     display with rotation in angle/vector format
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

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function out = printline(X, options)
    arguments
        X
        options.mode (1,1) string = "rpy";
        options.fmt (1,1) string = ""
        options.unit (1,1) string {mustBeMember(options.unit, ["rad", "deg"])} = "rad"
        options.fid (1,1) {mustBeInteger} = 1
        options.label (1,1) string = ""
    end
    
    opt.fmt = [];
    opt.mode = {'rpy', 'euler', 'axang'};
    opt.unit = 'rad';
    opt.label = [];
    opt.fid = 1;
    opt.dim = 3;

    if isa(X,'se2') || isa(X,'so2')
        opt.dim = 2;
    end    

    [opt,args] = tb_optparse(opt, varargin);

    if isa(X, 'se3') || isa(X,'se2')
        X = X.tform;
    elseif isa(X, 'so3') || isa(X,'so2')
        X = X.rotm;        
    elseif isa(X, 'Twist')
        X = X.tform;
    end

% Do not print the variable name. It's not very useful.
%     if isempty(opt.label)
%         opt.label = inputname(1);
%     end

    s = '';

    if size(X,3) == 1
        if isempty(opt.fmt)
            opt.fmt = '%.3g';
        end
        if opt.dim == 2
            s = tr2s2d(X, opt, args{:});
        else
            s = tr2s(X, opt, args{:});
        end
    else
        if isempty(opt.fmt)
            opt.fmt = '%8.2g';
        end
        
        for i=1:size(X,3)
            % for each matrix in a 3D array
            if opt.dim == 2
                s = char(s, tr2s2d(X(:,:,i), opt, args{:}) );
            else
                s = char(s, tr2s(X(:,:,i), opt, args{:}) );
            end
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

function s = tr2s(T, opt, varargin)
    % print the translational part if it exists
    if ~isempty(opt.label)
        s = sprintf('%8s: ', opt.label);
    else
        s = '';
    end
    if all(size(T) == [4 4])
        % tform
        s = [s, sprintf('t = (%s),', vec2s(opt.fmt, tform2trvec(T)))];
        R = tform2rotm(T);
    else
        R = T;
    end

    % print the angular part in various representations
    if strcmp(opt.mode, 'axang')
        % as a vector and angle
        axang = rotm2axang(R);
        if axang(4) == 0
            s = strcat(s, sprintf(' R = nil') );
        elseif strcmp(opt.unit, 'deg')
            s = strcat(s, sprintf(' R = (%sdeg | %s)', ...
                sprintf(opt.fmt, axang(4)*180.0/pi), vec2s(opt.fmt, axang(1:3))) );
        else
            s = strcat(s, sprintf(' R = (%srad | %s)', ...
                sprintf(opt.fmt, axang(4)), vec2s(opt.fmt, axang(1:3))) );
        end
    else
        % angle as a 3-vector
        ang = rotm2eul(R);
        label = opt.mode;

        if strcmp(opt.unit, 'deg')
            s = strcat(s, ...
                sprintf(' %s = (%s) deg', label, vec2s(opt.fmt, ang*180.0/pi)) );
        else
            s = strcat(s, ...
                sprintf(' %s = (%s) rad', label, vec2s(opt.fmt, ang)) );
        end
    end
end

function s = vec2s(fmt, v)
    s = '';
    for i=1:length(v)
        if abs(v(i)) < 1000*eps
            v(i) = 0;
        end
        s = [s, sprintf(fmt, v(i))]; %#ok<AGROW>
        if i ~= length(v)
            s = [s, ', ']; %#ok<AGROW> % don't use strcat, removes trailing spaces
        end
    end
end
