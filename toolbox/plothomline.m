%PLOTHOMLINE Draw a line in homogeneous form
%
% PLOTHOMLINE(L) draws a 2D line in the current plot defined in homogenous
% form ax + by + c = 0  where L (3x1) is L = [a b c].
% The current axis limits are used to determine the endpoints of
% the line.  If L (3xN) then N lines are drawn, one per column.
%
% PLOTHOMLINE(L, LS) as above but the MATLAB line specification LS is given.
%
% H = PLOTHOMLINE(...) as above but returns a vector of graphics handles for the lines.
%
% Notes::
% - The line(s) is added to the current plot.
% - The line(s) can be drawn in 3D axes but will always lie in the
%   xy-plane.
%
% Example::
%          L = homline([1 2]', [3 1]'); % homog line from (1,2) to (3,1)
%          plot_homline(L, 'k--'); % plot dashed black line
%
% See also PLOT_BOX, PLOTPOLY, HOMLINE.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function handles = plothomline(lines, varargin)

% get plot limits from current graph
xlim = get(gca, 'XLim');
ylim = get(gca, 'YLim');

ish = ishold;
hold on;

if min(size(lines)) == 1
    lines = lines(:);
end

assert(size(lines,1) == 3, 'SMTB:plot_homline:badarg', 'Input must be a 3-vector or 3xN matrix');

h = [];
% for all input lines (columns
for l=lines
    if abs(l(2)) > abs(l(1))
        y = (-l(3) - l(1)*xlim) / l(2);
        hh = plot(xlim, y, varargin{:});
    else
        x = (-l(3) - l(2)*ylim) / l(1);
        hh = plot(x, ylim, varargin{:});
    end
    h = [h; hh]; %#ok<AGROW>
end

if ~ish
    hold off
end

if nargout > 0
    handles = h;
end

end

