%TRPRINT2 Compact display of SE(2) homogeneous transformation
%
% TRPRINT2(T, OPTIONS) displays the homogoneous transform (3x3) in a compact
% single-line format.  If T is a homogeneous transform sequence then each
% element is printed on a separate line.
%
% TRPRINT2(R, OPTIONS) as above but displays the SO(2) rotation matrix (3x3).
%
% S = TRPRINT2(T, OPTIONS) as above but returns the string.
%
% TRPRINT2 T  is the command line form of above, and displays in RPY format.
%
% Options::
% 'radian'     display angle in radians (default is degrees)
% 'fmt', f     use format string f for all numbers, (default %g)
% 'label',l    display the text before the transform
%
% Examples::
%        >> trprint2(T2)
%        t = (0,0), theta = -122.704 deg
%
%
% See also TRPRINT.

%## 2d homogeneous

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function out = trprint2(T, varargin)

if ischar(T)
    % command form: trprint T
    trprint( evalin('caller', T) );
    return;
end

opt.fmt = [];
opt.radian = false;
opt.label = '';

[opt,args] = tb_optparse(opt, varargin);

s = '';

if size(T,3) == 1
    if isempty(opt.fmt)
        opt.fmt = '%.3g';
    end
    s = tr2s(T, opt, args{:});
else
    if isempty(opt.fmt)
        opt.fmt = '%8.2g';
    end
    
    for i=1:size(T,3)
        % for each 4x4 transform in a possible 3D matrix
        s = char(s, tr2s(T(:,:,i), opt) );
    end
end

% if no output provided then display it
if nargout == 0
    disp(s);
else
    out = s;
end
end

function s = tr2s(T, opt)
% print the translational part if it exists
if ~isempty(opt.label)
    s = sprintf('%8s: ', opt.label);
else
    s = '';
end
if ~isrotm2d(T)
    s = strcat(s, sprintf('t = (%s),', vec2s(opt.fmt, tform2trvec(T))));
end

% print the angular part
ang = atan2(T(2,1), T(1,1));
if opt.radian
    s = strcat(s, ...
        sprintf(' %s rad', vec2s(opt.fmt, ang)) );
else
    s = strcat(s, ...
        sprintf(' %s deg', vec2s(opt.fmt, ang*180.0/pi)) );
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
