%PLOTPOINT Draw a point
%
% PLOTPOINT(P, OPTIONS) adds point markers and optional annotation text
% to the current plot, where P (2xN) and each column is a point coordinate.
%
% H = PLOTPOINT(...) as above but return handles to the points.
%
% Options::
%  'textcolor', colspec     Specify color of text
%  'textsize', size         Specify size of text
%  'bold'                   Text in bold font.
%  'printf', {fmt, data}    Label points according to printf format
%                           string and corresponding element of data
%  'sequence'               Label points sequentially
%  'label',L                Label for point
%
% Additional options to PLOT can be used: 
% - standard MATLAB LineStyle such as 'r' or 'b---'
% - any MATLAB LineProperty options can be given such as 'LineWidth', 2.
%
% Notes::
% - The point(s) and annotations are added to the current plot.
% - Points can be drawn in 3D axes but will always lie in the
%   xy-plane.
% - Handles are to the points but not the annotations.
%
% Examples::
%   Simple point plot with two markers
%        P = rand(2,4);
%        plot_point(P);
%
%   Plot points with markers
%        plot_point(P, '*');
%
%   Plot points with solid blue circular markers
%        plot_point(P, 'bo', 'MarkerFaceColor', 'b');
%
%   Plot points with square markers and labelled 1 to 4
%        plot_point(P, 'sequence', 's');
%
%   Plot points with circles and labelled P1, P2, P4 and P8
%        data = [1 2 4 8];
%        plot_point(P, 'printf', {' P%d', data}, 'o');
%
%
% See also PLOTSPHERE, PLOT, TEXT.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function ho = plotpoint(p, varargin)

    opt.textcolor = 'k';
    opt.textsize = 12;
    opt.printf = [];
    opt.sequence = false;
    opt.bold = false;
    opt.label = [];
    opt.solid = false;
    [opt,arglist,ls] = tb_optparse(opt, varargin);

    % label is a cell array, one per point (column)
    if ~isempty(opt.label) && size(p, 1) == 1
        % if single point, convert single label to a cell array
        opt.label = {opt.label};
    end
    
    % default marker style
    if isempty(ls)
        ls = {'bs'};    % blue square
    end

    % add stuff to pull .u and .v out of a vector of objects
    if ~isnumeric(p) && any(strcmp('u_', properties(p)))
        % p is an object with u_ and v_ properties
        p = [[p.u_]; [p.v_]];
    end

    if ~size(p, 2) == 2
        error('p must have 2 columns, one row per 2D point')
    end
    holdon = ishold();
	hold on
    h = zeros(size(p, 1), 1);
    
	for i=1:size(p, 1)
        if opt.solid 
        arglist = [ 'MarkerFaceColor', ls{1}(1), arglist]; %#ok<AGROW>
        end
		h(i) = plot(p(i,1), p(i,2), ls{:}, arglist{:});
        if opt.sequence
            show(p(i,:), '   %d', i, opt);
        end

        if ~isempty(opt.label)
            show(p(i, :), opt.label{i}, [], opt);
        elseif ~isempty(opt.printf)
            show(p(i,:), opt.printf{1}, opt.printf{2}(i), opt);
        end

	end
    if ~holdon
        hold off
    end
    figure(gcf)
    if nargout > 0
        ho = h;
    end
end

function show(p, fmt, val, opt)
    if opt.bold
        fw = 'bold';
    else
        fw = 'normal';
    end
    text(p(1), p(2), sprintf([' ' fmt], val), ...
        'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'middle', ...
        'FontUnits', 'pixels', ...
        'FontSize', opt.textsize, ...
        'FontWeight', fw, ...
        'Color', opt.textcolor);
end
