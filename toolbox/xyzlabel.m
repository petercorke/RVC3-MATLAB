%XYZLABEL Label X, Y and Z axes
%
% XYZLABEL() label the x-, y- and z-axes with 'X', 'Y', and 'Z'
% respectiveley.
%
% XYZLABEL(FMT) as above but pass in a format string where %s is substituted
% for the axis label, eg.
%
%          xyzlabel('This is the %s axis')
%
% See also xlabel, ylabel, zlabel, sprintf.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function xyzlabel(fmt)
if nargin < 1
    fmt = '%s';
end
xlabel(sprintf(fmt, 'X'));
ylabel(sprintf(fmt, 'Y'));
zlabel(sprintf(fmt, 'Z'));
end
