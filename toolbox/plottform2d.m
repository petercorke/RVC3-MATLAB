%PLOTTFORM2D Add a 3D coordinate frame to plot
%
% PLOTTFORM2D(T) draws a 2D coordinate frame represented by the
% SE(2) homogeneous transform T (3x3).
%
% PLOTTFORM2D(R) as above but the coordinate frame is rotated
% about the origin according to the SO(2) rotation matrix R (2x2).
%
% PLOTTFORM2D() creates a default frame EYE(2) at the origin.
%
% H = PLOTTFORM(...) as above but returns a handle that allows the frame
% to be animated.
%
% Options:
%
% handle            - Update the specified handle
% axhandle          - Draw in the MATLAB axes specified by the axis handle
% color             - The color to draw the axes, MATLAB ColorSpec
% axes              - Show the MATLAB axes, box and ticks (default true)
% axis              - Set dimensions of the MATLAB axes to A=[xmin xmax ymin ymax zmin zmax]
% frame             - The coordinate frame is named {F} and the subscript on the axis labels is F.
% labelstyle        - Frame axis labels are "none"; "axis" for labels given
%                     by labels option; or "axis_frame" (default) for labels given by
%                     labels option and subscript from frame label.
% framelabeloffset  - Offset O=[DX DY] frame labels in units of text box height
% text_options      - A struct of MATLAB text properties
% length            - Length of the coordinate frame arms (default 1)
% LineWidth         - Thickness of lines (default 0.5)
% text              - Enable display of X,Y,Z labels on the frame (default true)
% labels            - Label the X,Y,Z axes with the 1st, 2nd, 3rd character of the string L
% style             - Axis line and color style. "plain" drawn using color
%                     and LineWidth; "rgb" are colored red (x-axis), green (y-axis) and blue (z-axis).
%                     and LineWidth; "rviz" drawn in RVIZ style axes with thick axis lines,
%                     no arrows, and colored red (x-axis), green (y-axis) and blue (z-axis).
% arrow             - Use arrows rather than line segments for the axes
%
% Examples:
%    PLOTTFORM2D(T, frame="A")
%    PLOTTFORM2D(T, frame="A", color="b")
%    PLOTTFORM2D(T, frame="A", FontSize=10, FontWeight="bold")
%    PLOTTFORM2D(T, labels="NOA");
%    PLOTTFORM2D(T, anaglyph="rc"); % 3D anaglyph plot
%
% To animate a coordinate frame, firstly, create a plot, as per above, but
% keep the handle:
%    h = PLOTTFORM2D(T0);      % create the frame at its initial pose
%    PLOTTFORM(T, handle=h); % moves the frame to new pose T
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Chapter 2
%
% See also PLOTTFORM.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function hout = plottform2d(X, options)
    arguments
        X double = eye(3,3)
        options.color (1,1) string = "b"
        options.textcolor (1,1) string = ""
        options.axes = true;
        options.axis = [];
        options.axhandle = [];
        options.frame (1,1) string = ""
        options.labelstyle (1,1) string {mustBeMember(options.labelstyle, ["none", "axis", "axis_frame"])} = "axis_frame";
        options.arrow (1,1) logical = true
        options.length = 1;
        options.framelabeloffset (1,2) double = [0 0]
        options.handle (1,1)
        options.LineWidth (1,1) double = 0.5
        options.labels (1,2) char = 'XY'
        options.text_options = struct
    end

    % convert various forms to to hom transform
    if isrotm2d(X)
        T = r2t(X);
    elseif istform2d(X)
        T = X;
    elseif isa(X, "se2")
        T = X.tform();
    elseif isa(X, "rigidtform2d")
        T = X.T();
    elseif isa(X, "Twist2d")
        T = X.tform();
    elseif isa(X, "so2")
        T = rotm2tform2d(X.rotm());
    else
        error("RVC3:plottform2d:badarg", "argument must be 2x2 or 3x3 matrix, so2, se2, or Twist2d");
    end
    
    if size(T,3) > 1
        error("RVC3:plottform2d:badarg", "cannot operate on a sequence, see animtform2d");
    end
    
    % ensure it's SE(3)
    if isrotm(X)
        X = rotm2tform(X);
    end
    
    if isfield(options, "handle")
        options.handle.Matrix = SE2tSE3(T);
        % for the 3D case retrieve the right hgtransform and set it
        hg2 = options.handle.UserData;
        if ~isempty(hg2)
            hg2.Matrix = X;
        end
        if nargout > 0
            hout = options.handle;
        end
        return;
    end
    
    % sort out the colors of axes and text
    axcolors = [options.color options.color options.color];

    % figure the dimensions of the axes, if not given
    if isempty(options.axis)
        % determine some default axis dimensions
        
        % get the origin of the frame
        c = tform2trvec2d(T);
    
        d = 1.2;
        options.axis = [c(1)-d c(1)+d c(2)-d c(2)+d];
    end
    
    if ~isempty(options.axhandle)
        hax = options.axhandle;
        hold(hax, "on");
    else
        ih = ishold;
        if ~ih
            % if hold is not on, then clear the axes and set scaling
            cla
            if ~isempty(options.axis)
                axis(options.axis);
            end
            % daspect([1 1]);
            
            if options.axes
                xlabel(options.labels(1));
                ylabel(options.labels(2));
            end
        end
        % no idea why this fails: hax = gca;
        for c=gcf().Children'
            if isa(c, "matlab.graphics.axis.Axes")
                hax = c;
                break;
            end
        end
        hold on
    end
    % hax is the handle for the axis we will work with, either new or
    % passed by option 'handle'
    
    % convert text options from a struct to a cell array
    names = fieldnames(options.text_options);
    values = struct2cell(options.text_options);
    text_options_cell = {};
    for i=1:length(names)
        text_options_cell{end+1} = names{i};
        text_options_cell{end+1} = values{i};
    end
    
    hg = hgtransform(Parent=hax);    
    
    % create unit vectors
    o =  [0 0]';
    x1 = options.length*[1 0 1]';
    y1 = options.length*[0 1 1]';
    
    % draw the axes
    mstart = [o o];
    mend = [x1 y1];
    mend = mend(1:2, :);

    if options.arrow
        daspect([1,1,1])
        diff = mend - mstart;
        for i=1:2
            quiver(mstart(1,i), mstart(2,i), ...
                diff(1,i), diff(2,i), ...
                AutoScale=false, Color=axcolors(i), Parent=hg);
        end
    else
        for i=1:2
            plot([mstart(i,1) mend(i,1)], ...
                 [mstart(i,2) mend(i,2)], ...
                 Color=axcolor(i), ...
                 LineWidth=options.LineWidth, ...
                 Parent=hg);
        end
    end
    
    % label the axes
    if options.labelstyle ~= "none"
        if options.labelstyle == "axis"
            fmt = "%c";
        elseif options.labelstyle == "axis_frame"
            fmt = sprintf("%%c_{%s}", options.frame);
        end

        % add the labels to each axis
        text(x1(1), x1(2), sprintf(fmt, options.labels(1)), ...
            "Parent", hg, "Color", axcolors(1), text_options_cell{:});
        text(y1(1), y1(2), sprintf(fmt, options.labels(2)), ...
            "Parent", hg, "Color", axcolors(2), text_options_cell{:});
    end

    % label the frame
    if options.frame ~= ""
        h = text(o(1), o(2), ...
            "\{" + options.frame + "\}", ...
            "Parent", hg, ...
            "VerticalAlignment", "middle", ...
            "HorizontalAlignment", "center", ...
            "FontUnits", "normalized", ...
            text_options_cell{:});
        e = h.Extent;
        d = e(4); % use height of text box as a scale factor
        e(1:2) = e(1:2) - options.framelabeloffset * d;
        h.Position = e(1:2);
    end
    
    if ~options.axes
        gca.visible = "off";
    end

%     if isempty(options.handle) && ~ih
%         grid on
%         hold off
%     end
    
    % now place the frame in the desired pose
    set(hg, Matrix=SE2tSE3(T));
    
    % optionally return the handle, for later modification of pose
    if nargout > 0
        hout = hg;
    end
end

function T3 = SE2tSE3(T2)
    T3 = eye(4);
    T3(1:2,1:2) = T2(1:2,1:2);
    T3(1:2,4) = T2(1:2,3);
end


