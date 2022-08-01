%PRINTTFORM Compact display of SE(3) homogeneous transformation
%
% PRINTTFORM(T, OPTIONS) displays the homogoneous transform (4x4) in a compact
% single-line format.  If T is a homogeneous transform sequence then each
% element is printed on a separate line.  T can also be an object of type
% se3, rigidtform3d or Twist.
%
% PRINTTFORM(R, OPTIONS) as above but displays the SO(3) rotation matrix (3x3).
% R can also be an object of type so3.
%
% S = PRINTTFORM(T, OPTIONS) as above but returns the string.
%
% >> PRINTTFORM T OPTIONS is the command line form of above.
%
% Options::
% mode = 'rpy' | 'xyz' | 'zyx' | 'yxz' | 'eul' | 'euler' | 'axang'
% unit = 'rad' (default) | 'deg'
% fmt  format string f for all numbers, (default %8.2g)
% label    label to display the text before the transform
% fid      file identifier to write string to
%
% Examples::
%        >> T = se3(rotmx(0.3),[1 2 3])
%        >> printtform(T)
%        t = (1, 2, 3), RPY/zyx = (0, 0, 0.3) rad
%
%        >> printtform(T, label='A')
%               A: t = (1, 2, 3), RPY/zyx = (0, 0, 0.3) rad
%
%        >> printtform(T, mode='axang')
%        t = (1, 2, 3), R = (0.3rad | 1, 0, 0)
%
%
% See also ROTM2EUL, ROTM2AXANG.

%## 3d homogeneous

% Copyright (C) 1993-2019 Peter I. Corke
%


function out = printtform(X, varargin)

    opt.fmt = [];
    opt.mode = {'rpy', 'xyz', 'zyx', 'yxz', 'euler', 'eul', 'axang'};
    opt.unit = 'rad';
    opt.label = [];
    opt.fid = 1;

    [opt,args] = tb_optparse(opt, varargin);

    opt.mode = string(opt.mode);
    switch opt.mode
        case 'rpy'
            opt.mode = 'zyx';
            opt.orientation = "RPY/" + opt.mode;
        case {'eul', 'euler'}
            opt.mode = 'zyz';
            opt.orientation = "EUL";
        case {'xyz', 'zyx', 'yxz'}
            opt.orientation = "RPY/" + opt.mode;
        case 'axang'
        otherwise
            error('bad orientation specified')
    end

    % convert various object instances to a native matrix: 4x4 or 3x3
    if isa(X, 'se3')
        X = X.tform;
    elseif isa(X, 'so3')
        X = X.rotm;        
    elseif isa(X, 'Twist')
        X = X.tform;
    elseif isa(X, 'rigidtform3d')
        T = X.T();
    end

% Do not print the variable name. It's not very useful.
    if isempty(opt.label)
        opt.label = inputname(1);
    end

    s = '';

    if size(X,3) == 1
        % scalar value
        if isempty(opt.fmt)
            opt.fmt = '%.3g';
        end
        s = tr2s(X, opt, args{:});
    else
        % a sequence
        if isempty(opt.fmt)
            opt.fmt = '%8.2g';
        end
        
        for i=1:size(X,3)
            % for each matrix in a 3D array
            s = char(s, tr2s(X(:,:,i), opt, args{:}) );
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
    switch (opt.mode)
        case 'axang'
            % as a vector and angle
            aa = rotm2axang(R);
            th = aa(4); v = aa(1:3);
            if th == 0
                s = strcat(s, sprintf(' R = nil') );
            elseif strcmp(opt.unit, 'rad')
                s = strcat(s, sprintf(' R = (%srad | %s)', ...
                    sprintf(opt.fmt, th), vec2s(opt.fmt, v)) );
            elseif strcmp(opt.unit, 'deg')
                s = strcat(s, sprintf(' R = (%sdeg | %s)', ...
                    sprintf(opt.fmt, rad2deg(th)), vec2s(opt.fmt,v)) );
            end
        otherwise
            % angle as a 3-vector
            ang = rotm2eul(R, opt.mode);
            if strcmp(opt.mode, 'zyz') == 0
                % put RPY angles in RPY order
                ang = fliplr(ang);
            end

            if strcmp(opt.unit, 'rad')
                s = strcat(s, ...
                    sprintf(' %s = (%s) rad', opt.orientation, vec2s(opt.fmt, ang)));
            elseif strcmp(opt.unit, 'deg')
                s = strcat(s, ...
                    sprintf(' %s = (%s) deg', opt.orientation, vec2s(opt.fmt, rad2deg(ang))));
            end

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
