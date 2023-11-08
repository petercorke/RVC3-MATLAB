%PLOTCIRCLE Draw a circle
%
% PLOTCIRCLE(C, R, OPTIONS) draws a circle on the current plot with 
% center C=[X,Y] and radius R.  If C=[X,Y,Z] the circle is drawn in the
% XY-plane at height Z.
%
% If C (2xN) then N circles are drawn.  If R (1x1) then all
% circles have the same radius or else R (1xN) to specify the radius of
% each circle.
%
% H = PLOTCIRCLE(...) as above but return handles. For multiple
% circles H is a vector of handles, one per circle.
%
% Options::
% 'edgecolor'   the color of the circle's edge, Matlab color spec
% 'fillcolor'   the color of the circle's interior, Matlab color spec
% 'alpha'       transparency of the filled circle: 0=transparent, 1=solid
% 'alter',H     alter existing circles with handle H
%
% - For an unfilled circle:
%   - any standard MATLAB LineStyle such as 'r' or 'b---'.
%   - any MATLAB LineProperty options can be given such as 'LineWidth', 2.
% - For a filled circle any MATLAB PatchProperty options can be given.
%
% Example::
%
%          H = plotcircle([3 4]', 2, 'r');  % draw red circle
%          plotcircle([3 4]', 3, 'alter', H); % change the circle radius
%          plotcircle([3 4]', 3, 'alter', H, 'LineColor', 'k'); % change the color
%
% Notes::
% - The 'alter' option can be used to create a smooth animation.
% - The circle(s) is added to the current plot irrespective of hold status.
%
% See also PLOTELLIPSE, PLOT_BOX, PLOTPOLY.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function handles = plotcircle(center, rad, varargin)

    opt.fillcolor = [];
    opt.alpha = 1;
    opt.edgecolor = 'k';
    opt.alter = [];

    [opt,arglist] = tb_optparse(opt, varargin);
    
    if ~isempty(opt.alter) & ~ishandle(opt.alter)
        error('SMTB:plotcircle:badarg', 'argument to alter must be a valid graphic object handle');
    end

    holdon = ishold;
    hold on

	n = 50;
	th = [0:n]'/n*2*pi;
    
    if length(rad) == 1
        rad = rad*ones(size(center, 2),1);
    end
    if length(center) == 2 || length(center) == 3
        center = center(:);
    end

    for i=1:size(center, 2)
        x = rad(i)*cos(th) + center(1,i);
        y = rad(i)*sin(th) + center(2,i);
        if size(center, 1) > 2
            % plot 3D data
            z = ones(size(x))*center(3,i);
            if isempty(opt.alter)
                h(i) = plot3(x, y, z, varargin{:});
            else
                set(opt.alter(i), 'xdata', x, 'ydata', y, 'zdata', z, arglist{:});
            end
        else
            % plot 2D data
            if isempty(opt.fillcolor)
                if isempty(opt.alter)
                    h(i) = plot(x, y, arglist{:});
                else
                    set(opt.alter(i), 'xdata', x, 'ydata', y, arglist{:});
                end
            else
                if isempty(opt.alter)
                    h(i) = patch(x, y, 0*y, 'FaceColor', opt.fillcolor, ...
                        'FaceAlpha', opt.alpha, 'EdgeColor', opt.edgecolor, arglist{:});
                else
                    set(opt.alter(i), 'xdata', x, 'ydata', y, arglist{:});
                end
                
            end
        end
    end

    if holdon == 0
        hold off
    end
    
    if nargout > 0
        handles = h;
    end
