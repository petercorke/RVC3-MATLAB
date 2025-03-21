%Camera  Camera superclass
%
% An abstract superclass for Toolbox camera classes.
%
% Methods::
%
% plot           plot projection of world point to image plane
% hold           control figure hold for image plane window
% ishold         test figure hold for image plane
% clf            clear image plane
% figure         figure holding the image plane
% mesh           draw shape represented as a mesh
% point          draw homogeneous points on image plane
% homline        draw homogeneous lines on image plane
% lineseg        draw line segment defined by points
% plot_camera    draw camera in world view
%-
% rpy            set camera attitude
% move           clone Camera after motion
% center         get world coordinate of camera center
%-
% delete         object destructor
% char           convert camera parameters to string
% display        display camera parameters
%-
% Properties (read/write)::
% npix    image dimensions (1x2)
% pp      principal point (1x2)
% rho     pixel dimensions (1x2) in metres
% T       camera pose as homogeneous transformation
%
% Properties (read only)::
% nu    number of pixels in u-direction
% nv    number of pixels in v-direction
% u0    principal point u-coordinate
% v0    principal point v-coordinate
%
% Notes::
%  - Camera is a reference object.
%  - Camera objects can be used in vectors and arrays
%  - This is an abstract class and must be subclassed and a project()
%    method defined.
%  - The object can create a window to display the Camera image plane, this
%    window is protected and can only be accessed by the plot methods of
%    this object.
%  - The project method is implemented by the concrete subclass.
%
% See also CentralCamera, SphericalCamera, FishEyeCamera, CatadiptricCamera.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

% TODO:
%   make a parent imaging class and subclass perspective, fisheye, panocam
%   test for points in front of camera and set to NaN if not
%   test for points off the image plane and set to NaN if not
%     make clipping/test flags
classdef Camera < handle
    
    properties
        name    % camera name
        type
        rho     % pixel dimensions 1x2
        pp      % principal point 1x2
        npix    % number of pixel 1x2
        T       % camera pose se3 object
        noise   % pixel noise 1x2
        image
    end
    
    properties (SetAccess = protected)
        limits
        perspective
        h_imageplane     % handle for image plane
        h_3dview % handle for camera 3D view
        P           % world points (last plotted)
        holdon
        color
    end
    
    properties (Dependent = true, SetAccess = protected)
        u0
        v0
        nu
        nv
    end
    
    methods (Abstract)
        p = project(c, P, varargin);
    end
    
    methods
        
        function c = Camera(varargin)
            %Camera.Camera Create camera object
            %
            % Constructor for abstact Camera class, used by all subclasses.
            %
            % C = Camera(OPTIONS) creates a default (abstract) camera with null parameters.
            %
            % Options::
            % 'name',N          Name of camera
            % 'image',IM        Load image IM to image plane
            % 'resolution',N    Image plane resolution: NxN or N=[W H]
            % 'sensor',S        Image sensor size in metres (2x1) [metres]
            % 'center',P        Principal point (1x2)
            % 'pixel',S         Pixel size: SxS or S=[W H]
            % 'noise',SIGMA     Standard deviation of additive Gaussian noise added to
            %                   returned image projections
            % 'pose',T          Pose of the camera as a homogeneous transformation
            % 'color',C         Color of image plane background (default [1 1 0.8])
            %
            % Notes::
            % - Normally the class plots points and lines into a set of axes that represent
            %   the image plane.  The 'image' option paints the specified image onto the
            %   image plane and allows points and lines to be overlaid.
            %
            % See also CentralCamera, FisheyeCamera, CatadioptricCamera, SphericalCamera.
            
            % default values
            c.type = '**abstract**';
            c.T = eye(4,4);
            c.pp = [];
            c.limits = [-1 1 -1 1];
            c.perspective = false;
            c.h_imageplane = [];
            c.h_3dview = [];
            c.holdon = false;
            c.color = [1 1 0.8];
            
            if nargin == 1 && isa(varargin{1}, 'Camera')
                return;
            else
                opt.name = 'noname';
                opt.image = [];
                opt.resolution = [];
                opt.center = [];
                opt.sensor = [];
                opt.pixel = [1 1];
                opt.noise = [];
                opt.pose = [];
                opt.color = [];
                c.pp = [0 0];
                
                
                [opt,args] = tb_optparse(opt, varargin);
                
                c.name = opt.name;
                if ~isempty(opt.image)
                    c.image = opt.image;
                    c.npix = [size(c.image,2) size(c.image,1)];
                end
                if ~isempty(opt.resolution)
                    if length(opt.resolution) == 1
                        c.npix = [opt.resolution opt.resolution];
                    elseif length(opt.resolution) == 2
                        c.npix = opt.resolution;
                    else
                        error('resolution must be a 1- or 2-vector');
                    end
                end
                
                c.pp = opt.center;
                c.rho = opt.pixel;
                if ~isempty(opt.color)
                    c.color = opt.color;
                end
                if ~isempty(opt.noise)
                    if length(opt.noise) == 1
                        c.noise = [opt.noise opt.noise];
                    elseif length(opt.noise) == 2
                        c.noise = opt.noise;
                    else
                        error('noise must be a 1- or 2-vector');
                    end
                end
                if ~isempty(opt.pose)
                    c.T = se3(opt.pose);
                end
                if ~isempty(opt.sensor)
                    c.rho = opt.sensor ./ c.npix;
                end
            end
            
            if length(c.rho) == 1
                c.rho = ones(1,2) * c.rho;
            end
            if isempty(c.pp)
                fprintf('principal point not specified, setting it to center of image plane\n');
                c.pp = c.npix / 2;
            end
        end
        
        function delete(c)
            %Camera.delete Camera object destructor
            %
            % C.delete() destroys all figures associated with the Camera object and
            % removes the object.
            %disp('delete camera object');
            if ~isempty(c.h_imageplane) && isgraphics(c.h_imageplane)
                delete(get(c.h_imageplane, 'Parent'));
            end
            if ~isempty(c.h_3dview) && isgraphics(c.h_3dview)
                delete(get(c.h_3dview, 'Parent'));
            end
        end
        
        function display(c)
            %Camera.display Display value
            %
            % C.display() displays a compact human-readable representation of the camera
            % parameters.
            %
            % Notes::
            % - This method is invoked implicitly at the command line when the result
            %   of an expression is a Camera object and the command has no trailing
            %   semicolon.
            %
            % See also Camera.char.
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            if loose
                disp(' ');
            end
            disp(char(c))
            if loose
                disp(' ');
            end
        end
        
        function s = char(c, s)
            %Camera.char Convert to string
            %
            % S = C.char() is a compact string representation of the camera parameters.
            
            s = '';
            if ~isempty(c.rho)
                s = strvcat(s, sprintf('  pixel size:     (%.4g, %.4g)', c.rho(1), c.rho(2)));
            end
            if ~isempty(c.pp)
                s = strvcat(s, sprintf('  principal pt:   (%.4g, %.4g)', c.u0, c.v0));
            end
            if ~isempty(c.npix)
                s = strvcat(s, sprintf('  number pixels:  %d x %d', c.nu, c.nv));
            end
            if ~isempty(c.noise)
                s = strvcat(s, sprintf('  noise:          %.4g,%.4g pix', c.noise));
            end
            s = strvcat(s,     sprintf('  pose:           %s', printtform(c.T)));
            % = strvcat(s, [repmat('      ', 4,1) num2str(c.T)]);
        end
        
        function rpy(c, roll, pitch, yaw)
            %Camera.rpy Set camera attitude
            %
            % C.rpy(R, P, Y) sets the camera attitude to the specified roll-pitch-yaw angles.
            %
            % C.rpy(RPY) as above but RPY=[R,P,Y].
            if nargin == 2,
                pitch = roll(2);
                yaw = roll(3);
                roll = roll(1);
            end
            c.T = se3(rotmy(yaw) * rotmx(pitch) * rotmz(roll)); % YXZ order
        end
        
        function c = center(c)
            %Camera.center Get camera position
            %
            % P = C.center() is the 3-dimensional position of the camera center (1x3).
            
            c = c.T.t';
        end
        
        function ishold = hold(c, flag)
            %Camera.hold Control hold on image plane graphics
            %
            % C.hold() sets "hold on" for the camera's image plane.
            %
            % C.hold(H) hold mode is set on if H is true (or > 0), and off if
            % H is false (or 0).
            
            % cam.ishold(); set hold
            % cam.ishold(flag); set hold
            if nargin < 2
                flag = true;
            end
            c.holdon = flag;
            if flag
                set(c.h_imageplane, 'NextPlot', 'add');
            else
                set(c.h_imageplane, 'NextPlot', 'replacechildren');
            end
            if nargout > 0
                % i = cam.ishold(); test hold condition
                ishold = c.holdon;
                
            end
        end
        
        function v = ishold(c)
            %Camera.ishold Return image plane hold status
            %
            % H = C.ishold() returns true (1) if the camera's image plane is in hold mode,
            % otherwise false (0).
            v = c.holdon();
        end
        
        function clf(c, flag)
            %Camera.clf Clear the image plane
            %
            % C.clf() removes all graphics from the camera's image plane.
            h = c.h_imageplane;
            if ~isempty(h) && isgraphics(h)
                % remove all children of the figure
                children = get(h, 'Children');
                for child=children
                    delete(child)
                end
                
                % if the camera is displaying an image
                if ~isempty(c.image)
                    c.figure
                    idisp(c.image, 'nogui');
                    hold on
                end
            end
        end
        
        function h = figure(c)
            %Camera.figure Return figure handle
            %
            % H = C.figure() is the handle of the figure that contains the camera's
            % image plane graphics.
            fig  = get(c.h_imageplane, 'Parent');
            figure( fig );
            if nargout > 0
                h = fig;
            end
        end
        
        % Return the graphics handle for this camera's image plane
        % and create the graphics if it doesnt exist
        %
        function h = plot_create(c, hin)
            
            if ~isempty(c.image)
                % if this camera is created from an image, then display that image

                if isempty(c.h_imageplane) || ~isgraphics(c.h_imageplane)
                    idisp(c.image, 'nogui');
                    set(gcf, 'name', sprintf('%s(%s) - image plane', class(c), c.name));
                    set(gcf, 'MenuBar', 'none');
                    hold on
                    h = gca;
                    %title(h, ['CentralCamera image plane:' c.name);
                    c.h_imageplane = h;
                    set(gcf, 'HandleVisibility', 'off');
                    set(h, 'HandleVisibility', 'off');
                else
                    h = c.h_imageplane;
                end
                return;
            end
            
            if isgraphics(c.h_imageplane)
                % it already exists, just return the handle
                h = c.h_imageplane;
                return;
            end
            c.h_imageplane = [];  % handle is invalid
            
            if (nargin == 2) && isgraphics(hin)
                % draw camera in an existing axes
                disp('draw image plane in existing axes')
                h = hin;
                h.HandleVisibility = 'Off';
            else
                disp('creating new figure for camera')
                
                figure
                h = axes;
                fig = get(h, 'Parent');
                disp('make axes');
                axis square
                set(fig, 'MenuBar', 'none');
                set(fig, 'Tag', 'camera');
                set(h, 'Color', c.color);
                set(fig, 'HandleVisibility', 'off');
                set(fig, 'name', sprintf('%s(%s) - image plane', class(c), c.name));
            end
            % create an axis for camera view
            set(h, 'XLim', c.limits(1:2), 'YLim', c.limits(3:4), ...
                'DataAspectRatio', [1 1 1], ...
                'Xgrid', 'on', 'Ygrid', 'on', ...
                'Ydir' , 'reverse', ...
                'NextPlot', 'add', ...
                'Tag', c.name ...
                );
            c.h_imageplane = h;       % keep this around
            c.labelaxes();
            
            title(h, c.name);
            %figure( fig );   % raise the camera view
            set(h, 'NextPlot', 'replacechildren');      
        end
           
        function labelaxes(c)
            h = c.h_imageplane;
            
            if ~isempty(c.npix)
                xlabel(h, 'u (pixels)');
                ylabel(h, 'v (pixels)');
            else
                xlabel(h, 'x (m)');
                ylabel(h, 'y (m)');
            end
        end

% xxx WJ: this is from Git, but broken?
%         function v =  plot(c, points, varargin)
%             %Camera.plot Plot points on image plane
%             %
%             % C.plot(P, OPTIONS) projects world points P (3xN) to the image plane and plots them.  If P is 2xN
%             % the points are assumed to be image plane coordinates and are plotted directly.
%             %
%             % UV = C.plot(P) as above but returns the image plane coordinates UV (2xN).
%             %
%             % - If P has 3 dimensions (3xNxS) then it is considered a sequence of point sets and is
%             %   displayed as an animation.
%             %
%             % C.plot(L, OPTIONS) projects the world lines represented by the
%             % array of Plucker objects (1xN) to the image plane and plots them.
%             %
%             % LI = C.plot(L, OPTIONS) as above but returns an array (3xN) of
%             % image plane lines in homogeneous form.
%             %
%             % Options::
%             % 'objpose',T     Transform all points by the homogeneous transformation T before
%             %                  projecting them to the camera image plane.
%             % 'pose',T         Set the camera pose to the homogeneous transformation T before
%             %                  projecting points to the camera image plane.  Overrides the current
%             %                  camera pose C.T.
%             % 'fps',N          Number of frames per second for point sequence display
%             % 'sequence'       Annotate the points with their index
%             % 'textcolor',C    Text color for annotation (default black)
%             % 'textsize',S     Text size for annotation (default 12)
%             % 'drawnow'        Execute MATLAB drawnow function
%             %
%             % Additional options are considered MATLAB line or marker style parameters and are passed
%             % directly to plot.
%             %
%             % See also Camera.mesh, Camera.hold, Camera.clf, Plucker.
%             
%             opt.fps = 5;
%             opt.sequence = false;
%             opt.textcolor = 'k';
%             opt.textsize = 12;
%             opt.drawnow = false;
%             
%             [opt,arglist,ls] = tb_optparse(opt, varargin);
%             
%             % get handle for this camera image plane
%             h = c.plot_create();
%             
%             if isa(points, 'Plucker')
%                 % plot lines
%                 
%                 % project 3D world lines using the class project() method
%                 uv = c.project(points, arglist{:});
%                 c.hold(true);
%                 for line=uv
%                     c.homline(line);
%                 end
%                 c.hold(false)
%             else
%                 % plot points
%                 nr = size(points,1);
%                 
%                 if nr == 3
%                     % project 3D world points using the class project() method
%                     uv = c.project(points, arglist{:});
%                 else
%                     uv = points;
%                 end
%                 
%                 if isempty(ls) || ~any(cellfun(@(x) ischar(x)&&contains(x, 'Marker'), arglist))
%                     % set default style if none given
%                     ls = {'Marker', 'o', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k', 'LineStyle', 'none'};
%                 else
%                     ls = {ls};
%                 end
%                 
%                 for i=1:size(uv,3)
%                     % for every frame in the animation sequence
%                     plot(uv(1,:,i), uv(2,:,i), ls{:}, 'Parent', h);
%                     if opt.sequence
%                         for j=1:size(uv,2)
%                             text(uv(1,j,i), uv(2,j,i), sprintf('  %d', j), ...
%                                 'HorizontalAlignment', 'left', ...
%                                 'VerticalAlignment', 'middle', ...
%                                 'FontUnits', 'pixels', ...
%                                 'FontSize', opt.textsize, ...
%                                 'Color', opt.textcolor, ...
%                                 'Parent', h);
%                         end
%                     end
%                     
%                     if size(uv,3) > 1
%                         pause(1/opt.fps);
%                     end
%                 end
%             end
%             
%             if opt.drawnow
%                 drawnow
%             end
%             
%             if nargout > 0,
%                 v = uv;
%             end
%         end % plot

        function v =  plot(c, points, varargin)
            %Camera.plot Plot points on image plane
            %
            % C.plot(P, OPTIONS) projects world points P (3xN) to the image plane and plots them.  If P is 2xN
            % the points are assumed to be image plane coordinates and are plotted directly.
            %
            % UV = C.plot(P) as above but returns the image plane coordinates UV (2xN).
            %
            % - If P has 3 dimensions (3xNxS) then it is considered a sequence of point sets and is
            %   displayed as an animation.
            %
            % C.plot(L, OPTIONS) projects the world lines represented by the
            % array of Plucker objects (1xN) to the image plane and plots them.
            %
            % LI = C.plot(L, OPTIONS) as above but returns an array (3xN) of
            % image plane lines in homogeneous form.
            %
            % Options::
            % 'objpose',T     Transform all points by the homogeneous transformation T before
            %                  projecting them to the camera image plane.
            % 'pose',T         Set the camera pose to the homogeneous transformation T before
            %                  projecting points to the camera image plane.  Overrides the current
            %                  camera pose C.T.
            % 'fps',N          Number of frames per second for point sequence display
            % 'sequence'       Annotate the points with their index
            % 'textcolor',C    Text color for annotation (default black)
            % 'textsize',S     Text size for annotation (default 12)
            % 'drawnow'        Execute MATLAB drawnow function
            %
            % Additional options are considered MATLAB linestyle parameters and are passed
            % directly to plot.
            %
            % See also Camera.mesh, Camera.hold, Camera.clf, Plucker.
            
            opt.objpose = [];
            opt.pose = [];
            opt.fps = 5;
            opt.sequence = false;
            opt.textcolor = 'k';
            opt.textsize = 12;
            opt.drawnow = false;
            
            [opt,arglist] = tb_optparse(opt, varargin);
            
            % get handle for this camera image plane
            h = c.plot_create();
            
            if isa(points, 'Plucker')
                % plot lines
                
                % project 3D world lines using the class project() method
                uv = c.project(points, varargin{:})';
                for line=uv
                    c.homline(line);
                end
            else
                % plot points
                nr = size(points,2);
                
                if nr == 3
                    % project 3D world points using the class project() method
                    uv = c.project(points, varargin{:});
                else
                    uv = points;
                end
                
                if isempty(arglist)
                    % set default style if none given
                    %disp('set default plot args');
                    arglist = {'Marker', 'o', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k', 'LineStyle', 'none'};
                end
                
                for i=1:size(uv,3)
                    % for every frame in the animation sequence
                    plot(uv(:,1,i), uv(:,2,i), arglist{:}, 'Parent', h);
                    if opt.sequence
                        for j=1:size(uv,2)
                            text(uv(j,1,i), uv(j,2,i), sprintf('  %d', j), ...
                                'HorizontalAlignment', 'left', ...
                                'VerticalAlignment', 'middle', ...
                                'FontUnits', 'pixels', ...
                                'FontSize', opt.textsize, ...
                                'Color', opt.textcolor, ...
                                'Parent', h);
                        end
                    end
                    
                    if size(uv,3) > 1
                        pause(1/opt.fps);
                    end
                end
            end
            
            if opt.drawnow
                drawnow
            end
            
            if nargout > 0,
                v = uv;
            end
        end % plot


        function mesh(c, X, Y, Z, varargin)
            %Camera.mesh Plot mesh object on image plane
            %
            % C.mesh(X, Y, Z, OPTIONS) projects a 3D shape defined by the matrices X, Y, Z
            % to the image plane and plots them.  The matrices X, Y, Z are of the same size
            % and the corresponding elements of the matrices define 3D points.
            %
            % Options::
            % 'objpose',T   Transform all points by the homogeneous transformation T before
            %               projecting them to the camera image plane.
            % 'pose',T      Set the camera pose to the homogeneous transformation T before
            %               projecting points to the camera image plane.  Temporarily overrides
            %               the current camera pose C.T.
            %
            % Additional arguments are passed to plot as line style parameters.
            %
            % See also MESH, CYLINDER, SPHERE, MKCUBE, Camera.plot, Camera.hold, Camera.clf.
            
            % check that mesh matrices conform
            assert( all(size(X) == size(Y)) && all(size(X) == size(Z)), 'matrices must be the same size');
            
            opt.objpose = [];
            opt.pose = [];
            
            [opt,arglist,ls] = tb_optparse(opt, varargin);
            if isempty(opt.pose)
                opt.pose = c.T;
            end
            
            if isempty(ls)
                ls = {'k'};
            end
            
            % get handle for this camera image plane
            h = c.plot_create();
            
            % draw 3D line segments
            nsteps = 21;
            
            c.clf
            holdon = c.hold(1);
            s = linspace(0, 1, nsteps);
            
            for i=1:size(X,1)-1
                for j=1:size(X,2)-1
                    P0 = [X(i,j), Y(i,j), Z(i,j)];
                    P1 = [X(i+1,j), Y(i+1,j), Z(i+1,j)];
                    P2 = [X(i,j+1), Y(i,j+1), Z(i,j+1)];
                    
                    if c.perspective
                        % straight world lines are straight on the image plane
                        uv = c.project([P0; P1], 'setopt', opt);
                    else
                        % straight world lines are not straight, plot them piecewise
                        P = bsxfun(@times, (1-s), P0') + bsxfun(@times, s, P1');
                        uv = c.project(P', 'setopt', opt);
                    end
                    plot(uv(:,1)', uv(:,2)', ls{:}, arglist{:}, 'Parent', c.h_imageplane);
                    
                    if c.perspective
                        % straight world lines are straight on the image plane
                        uv = c.project([P0; P2], 'setopt', opt);
                    else
                        % straight world lines are not straight, plot them piecewise
                        P = bsxfun(@times, (1-s), P0') + bsxfun(@times, s, P2');
                        uv = c.project(P', 'setopt', opt);
                    end
                    plot(uv(:,1)', uv(:,2)', ls{:}, arglist{:}, 'Parent', c.h_imageplane);
                end
            end
            
            for j=1:size(X,2)-1
                P0 = [X(end,j), Y(end,j), Z(end,j)];
                P1 = [X(end,j+1), Y(end,j+1), Z(end,j+1)];
                
                if c.perspective
                    % straight world lines are straight on the image plane
                    uv = c.project([P0; P1], 'setopt', opt);
                else
                    % straight world lines are not straight, plot them piecewise
                    P = bsxfun(@times, (1-s), P0') + bsxfun(@times, s, P1');
                    uv = c.project(P', 'setopt', opt);
                end
                plot(uv(:,1)', uv(:,2)', ls{:}, arglist{:}, 'Parent', c.h_imageplane);
            end
            c.hold(holdon); % turn hold off if it was initially off
            
        end % mesh
        
        function h =  point(c, p, varargin)
            %Camera.point Plot homogeneous points on image plane
            %
            % C.point(P) plots points on the camera image plane which are defined by columns
            % of P (3xN) considered as points in homogeneous form.
            
            % get handle for this camera image plane
            h = c.create
            
            uv = e2h(p);
            h = plot(uv(1,:), uv(2,:), varargin{:});
        end % point
        
        function h =  homline(c, lines, varargin)
            %Camera.homline Plot homogeneous lines on image plane
            %
            % C.homline(L) plots lines on the camera image plane which are defined by columns
            % of L (3xN) considered as lines in homogeneous form: a.u + b.v + c = 0.
            
            % get handle for this camera image plane
            h = c.plot_create;
            xlim = get(h, 'XLim');
            ylim = get(h, 'YLim');
            
            if numel(lines) == 3
                lines = lines(:);
            end
            
            for l=lines
                if abs(l(1)/l(2)) > 1
                    % steeper than 45deg
                    x = (-l(3) - l(2)*ylim) / l(1);
                    h = plot(x, ylim, varargin{:}, 'Parent', c.h_imageplane);
                else
                    % less than 45deg
                    y = (-l(3) - l(1)*xlim) / l(2);
                    
                    h = plot(xlim, y, varargin{:}, 'Parent', c.h_imageplane);
                end
            end
        end % line
        
        function h = lineseg(c, p0, p1, varargin)
            % get handle for this camera image plane
            h = c.plot_create
            c.hold(1)
            for i=1:numcols(p0)
                plot([p0(1,i) p1(1,i)], [p0(2,i) p1(2,i)], varargin{:}, 'Parent', c.h_imageplane);
            end
        end
        
        function newcam = move(cam, T)
            %Camera.move Instantiate displaced camera
            %
            % C2 = C.move(T) is a new camera object that is a clone of C but its pose
            % is displaced by the homogeneous transformation T with respect to the
            % current pose of C.
            newcam = CentralCamera(cam);
            newcam.T = newcam.T * se3(T);
        end
        
        function movedby(c, robot)
            robot.addlistener('Moved', @(src,data)cameramove_callback(src,data,c));
            
            function cameramove_callback(robot, event, camera)
                camera.T = robot.fkine(robot.q);
            end
        end
        
        % return components of principal point and image size
        function v = get.u0(c)
            v = c.pp(1);
        end
        
        function v = get.v0(c)
            v = c.pp(2);
        end
        
        function v = get.rho(c)
            v = c.rho;
        end
        
        function v = get.nu(c)
            v = c.npix(1);
        end
        
        function v = get.nv(c)
            v = c.npix(2);
        end
        
        function c = set.T(c, Tc)
            c.T = se3(Tc);
            
            
            if ~isempty(c.h_3dview) && isgraphics(c.h_3dview)
                set(c.h_3dview, 'Matrix', c.T.tform);
            end
        end
        
        
        function c = set.rho(c, sxy)
            if isempty(sxy)
                c.rho = sxy;
            elseif length(sxy) == 1
                c.rho = [sxy sxy];
            elseif length(sxy) == 2
                c.rho = sxy(:)';
            else
                error('need 1 or 2 scale elements');
            end
        end
        
        function c = set.pp(c, pp)
            if isempty(pp)
                c.pp = [];
            elseif length(pp) == 1
                c.pp = [pp pp];
            elseif length(pp) == 2
                c.pp = pp(:)';
            else
                error('need 1 or 2 pp elements');
            end
        end
        
        function c = set.npix(c, npix)
            if ~isempty(npix)
                if length(npix) == 1,
                    c.npix = [npix npix];
                elseif length(npix) == 2,
                    c.npix = npix(:)';
                else
                    error('need 1 or 2 npix elements');
                end
                c.limits = [0 c.npix(1) 0 c.npix(2)];
            end
        end
        
        function help(c)
            disp(' C.plot(P)     return image coordinates for world points  P');
            disp(' C.point(P)     return image coordinates for world points  P');
            disp(' C.line(P)     return image coordinates for world points  P');
            disp(' C.clf     return image coordinates for world points  P');
            disp(' C.hold     return image coordinates for world points  P');
            disp(' C.project(P)     return image coordinates for world points  P');
            disp(' C.project(P, Tobj)  return image coordinates for world points P ');
            disp(' C.project(P, To, Tcm)  return image coordinates for world points P ');
            disp(' transformed by T prior to projection');
        end
    end % methods
    
end % class
