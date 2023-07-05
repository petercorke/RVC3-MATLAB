%PLOTTFORM Plot a 3D coordinate frame
%
% PLOTTFORM(T) plots a 3D coordinate frame represented by T which can be:
%  * a 4x4 SE(3) matrix representing 3D pose
%  * an se3 object representing 3D pose
%  * a rigidtform3d object representing 3D pose
%  * a Twist3 object representing 3D pose
%  * a 3x3 SO(3) matrix representing 3D orientation
%  * an so3 object representing 3D orientation
%  * a quaternion object representing 3D orientation
%
% Multiple frames can be added to a plot by using HOLD ON.
%
% H = PLOTTFORM(...) as above but returns a handle that allows the frame
% to be animated.
%
% Options:
%
% handle           - Update the specified handle
% axhandle         - Draw in the MATLAB axes specified by the axis handle
% color            - The color to draw the axes, MATLAB ColorSpec
% axes             - Show the MATLAB axes, box and ticks (default true)
% axis             - Set dimensions of the MATLAB axes to A=[xmin xmax ymin ymax zmin zmax]
% frame            - The coordinate frame is named {F} and the subscript on the axis labels is F.
% labelstyle       - Frame axis labels are "none"; "axis" for labels given
%                    by labels option; or "axis_frame" (default) for labels given by
%                    labels option and subscript from frame label.
% framelabeloffset - Offset O=[DX DY] frame labels in units of text box height
% text_options     - A struct of MATLAB text properties
% length           - Length of the coordinate frame arms (default 1)
% LineWidth        - Thickness of lines (default 0.5)
% text             - Enable display of X,Y,Z labels on the frame (default true)
% labels           - Label the X,Y,Z axes with the 1st, 2nd, 3rd character of the string L
% style            - Axis line and color style. "plain" drawn using color
%                    and LineWidth; "rgb" are colored red (x-axis), green (y-axis) and blue (z-axis).
%                    and LineWidth; "rviz" drawn in RVIZ style axes with thick axis lines,
%                    no arrows, and colored red (x-axis), green (y-axis) and blue (z-axis).
% arrow            - Use arrows rather than line segments for the axes
% projection       - Set the 3D projection to either "orthographic" (default) or "perspective".
% anaglyph         - Create an analglyph where the left and right
%                    images are drawn using single-letter color codes in the string LR
%                    chosen from r)ed, g)reen, b)lue, c)yan, m)agenta.
% disparity        - Disparity for 3d display (default 0.1)
% view               set the view parameters azimuth and
%                    elevation, as returned by the VIEW command.
%
% Examples:
%    PLOTTFORM(T, frame="A")
%    PLOTTFORM(T, frame="A", color="b")
%    PLOTTFORM(T, frame="A", FontSize=10, FontWeight="bold")
%    PLOTTFORM(T, labels="NOA");
%    PLOTTFORM(T, anaglyph="rc"); % 3D anaglyph plot
%
% To animate a coordinate frame, firstly, create a plot, as per above, but
% keep the handle:
%    h = PLOTTFORM(T0);      % create the frame at its initial pose
%    PLOTTFORM(T, handle=h); % moves the frame to new pose T
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Chapter 2
%
% See also PLOTTFORM2D.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function hout = plottform(X, options)
    arguments
        X = eye(3,3)
        options.color = "b"
        options.textcolor (1,1) string = ""
        options.axes = true;
        options.axis = [];
        options.axhandle = [];
        options.frame (1,1) string = ""
        options.labelstyle (1,1) string {mustBeMember(options.labelstyle, ["none", "axis", "axis_frame"])} = "axis_frame";
        options.style (1,1) string {mustBeMember(options.style, ["plain", "rgb", "rviz"])} = "rgb";
        options.arrow (1,1) logical = true
        options.length = 1;
        options.framelabeloffset (1,3) double = [0 0 0]
        options.handle (1,1)
        options.LineWidth (1,1) double = 0.5
        options.labels (1,3) char = 'XYZ'
        options.text_options = struct
        options.projection (1,1) string {mustBeMember(options.projection, ["perspective", "orthographic"])} = "perspective";
        options.anaglyph (1,1) string = ""
        options.view = "auto"
        options.disparity (1,1) double = 0.1
    end

    % convert various forms to to hom transform
    if istform(X)
        T = X;
    elseif isrotm(X)
        T = rotm2tform(X);
    elseif isa(X, "se3")
        T = X.tform();
    elseif isa(X, "rigidtform3d")
        T = X.T();
    elseif isa(X, "Twist")
        T = X.tform();
    elseif isa(X, "so3")
        T = rotm2tform(X.rotm());
    elseif isa(X, "quaternion")
        T = rotm2tform(X.rotmat("point"));
    else
        error("RVC3:plottform:badarg", "argument must be 3x3 or 4x4 matrix, so3, se3, quaternion or Twist");
    end
    
    if size(T,3) > 1
        error("RVC3:plottform:badarg", "cannot operate on a sequence, see animtform");
    end
    
    if isfield(options, "handle")
        % animate a previously created transform

        options.handle.Matrix = T;
        % for the anaglyph case retrieve the right hgtransform and set it
        hg2 = options.handle.UserData;
        if ~isempty(hg2)
            hg2.Matrix = T;
        end
        if nargout > 0
            hout = options.handle;
        end
        return;
    end
    
    % sort out the colors of axes and text
    if options.anaglyph == ""
        % no anaglyph
        switch options.style
            case "plain"
                axcolors = [options.color options.color options.color];
            case "rgb"
                axcolors = ["r" "g" "b"];
            case "rviz"
                options.LineWidth = 5;
                options.arrow = false;
        end
    else
        % anaglyph, color choice overrides
        color = options.anaglyph.extractBetween(1,1);
        axcolors = [color color color];
    end
        
    % figure the dimensions of the axes, if not given
    if isempty(options.axis)
        % determine some default axis dimensions
        
        % get the origin of the frame
        c = tform2trvec(T);
        d = 1.2;
        options.axis = [c(1)-d c(1)+d c(2)-d c(2)+d c(3)-d c(3)+d];
    end
    
    hax = newplot();
    if strcmp(hax.NextPlot, 'replace') 
        axis(options.axis);
        daspect([1 1 1]);
        
        if options.axes
            xlabel(options.labels(1));
            ylabel(options.labels(2));
            zlabel(options.labels(3));
            rotate3d on
        end
    end
    hax = gca;
    hold on
    % hax is the handle for the axis we will work with, either new or
    % passed by option 'handle'
    
    % convert text options from a struct to a cell array
    names = fieldnames(options.text_options);
    values = struct2cell(options.text_options);
    text_options_cell = {};
    for i=1:length(names)
        text_options_cell{end+1} = names{i}; %#ok<AGROW> 
        text_options_cell{end+1} = values{i}; %#ok<AGROW> 
    end
    
    hax.Projection = options.projection;
    hg = hgtransform('Parent', hax);    
    
    % create unit vectors
    o =  [0 0 0]';
    x1 = options.length*[1 0 0 1]';
    y1 = options.length*[0 1 0 1]';
    z1 = options.length*[0 0 1 1]';
    
    % draw the axes
    mstart = [o o o];
    mend = [x1 y1 z1];
    mend = mend(1:3, :);

    if options.arrow
        daspect([1,1,1])
        diff = mend - mstart;
        for i=1:3
            quiver3(mstart(1,i), mstart(2,i), mstart(3,i), ...
                diff(1,i), diff(2,i), diff(3,i), ...
                AutoScale=false, MaxHeadSize=options.LineWidth, LineWidth=options.LineWidth, Color=axcolors(i), Parent=hg);
        end
    else
        for i=1:3
            plot3([mstart(i,1) mend(i,1)], ...
                 [mstart(i,2) mend(i,2)], ...
                 [mstart(i,3) mend(i,3)], ...
                 Color=axcolor(i), ...
                 LineWidth=options.LineWidth, ...
                 Parent=hg);
        end
    end
    
    % label the axes
    if options.labelstyle ~= "none"
        if options.labelstyle == "axis"
            fmt = '%c';
        elseif options.labelstyle == "axis_frame"
            fmt = sprintf('%%c_{%s}', options.frame);
        end

        % add the labels to each axis
        text(x1(1), x1(2), x1(3), sprintf(fmt, options.labels(1)), ...
            "Parent", hg, "Color", axcolors(1), text_options_cell{:});
        text(y1(1), y1(2), y1(3), sprintf(fmt, options.labels(2)), ...
            "Parent", hg, "Color", axcolors(2), text_options_cell{:});
        text(z1(1), z1(2), z1(3), sprintf(fmt, options.labels(3)), ...
            "Parent", hg, "Color", axcolors(3), text_options_cell{:});
    end


    % label the frame
    if ~isempty(options.frame)
        h = text(o(1), o(2), o(3), ...
            "\{" + options.frame + "\}", ...
            "Parent", hg, ...
            "VerticalAlignment", "middle", ...
            "HorizontalAlignment", "center", ...
            "FontUnits", "normalized", ...
            text_options_cell{:});
        e = h.Extent;
        d = e(4); % use height of text box as a scale factor
        e(1:3) = e(1:3) - options.framelabeloffset * d;
        h.Position = e(1:3);
    end
    
    if ~options.axes
        set(gca, 'visible', 'off');
    end
    if (ischar(options.view) || isstring(options.view)) && options.view == "auto"
        cam = x1+y1+z1;
        view(cam(1:3));
    elseif ~isempty(options.view)
        view(options.view);
    end
    
    % now place the frame in the desired pose
    set(hg, 'Matrix', T);
    
    
    if options.anaglyph ~= ""
        % 3D display.  The original axes are for the left eye, and we add
        % another set of axes to the figure for the right eye view and
        % displace its camera to the right of that of that for the left eye.
        % Then we recursively call tformplot() to create the right eye view.
        
        left = hax;
        right = axes();
        axis(right, axis(left));
        
        % compute the offset in world coordinates
        off = -tform2rotm(view(left))'*[options.disparity 0 0]';
        off = off(:)';
        pos = left.CameraPosition;
        
        right.CameraPosition = pos+off;
        right.CameraViewAngle =  left.CameraViewAngle;
        right.CameraUpVector = left.CameraUpVector;

        target = left.CameraTarget;
        right.CameraTarget = target+off;
        
        % set perspective projections
        left.Projection = "perspective";
        right.Projection = "perspective";
        
        % turn off axes for right view
        right.Visible = "Off";
        
        % set color for right view
        hg2 = plottform(X, axhandle=right, color=options.anaglyph.extractBetween(2,2));
        
        % the hgtransform for the right view is user data for the left
        % view hgtransform, we need to change both when we rotate the
        % frame.
        hg.UserData = hg2;
    end
    
    % optionally return the handle, for later modification of pose
    if nargout > 0
        hout = hg;
    end
end
