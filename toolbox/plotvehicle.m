%PLOTVEHICLE Draw mobile robot pose
%
% PLOTVEHICLE(X,OPTIONS) draws an oriented triangle to represent the pose
% of a mobile robot moving in a planar world.  The pose X (1x3) =
% [x,y,theta]. If X is a matrix (Nx3) then an animation of the robot motion
% is shown and animated at the specified frame rate.
%
% Image mode::
%
% Create a structure with the following elements and pass it with the
% 'model' option.
%
%  image      an RGB image (HxWx3)
%  alpha      an alpha plane (HxW) with pixels 0 if transparent
%  rotation   image rotation in degrees required for front to pointing to the right
%  center     image coordinate (U,V) of the center of the back axle
%  length     length of the car in real-world units
%
% Animation mode::
%
% H = PLOTVEHICLE(X,OPTIONS) as above draws the robot and returns a handle.
%
% PLOTVEHICLE(X, 'handle', H) updates the pose X (1x3) of the previously drawn
% robot.
%
% Options::
%  'scale',S       draw vehicle with length S x maximum axis dimension (default
%                  1/60)
%  'size',S        draw vehicle with length S
%  'fillcolor',F   the color of the circle's interior, MATLAB color spec
%  'alpha',A       transparency of the filled circle: 0=transparent, 1=solid
%  'box'           draw a box shape (default is triangle)
%  'fps',F         animate at F frames per second (default 10)
%  'image',I       use an image to represent the robot pose
%  'retain'        when X (Nx3) then retain the robots, leaving a trail
%  'model',M       animate an image of the vehicle.  M is a structure with
%                  elements: image, alpha, rotation (deg), center (pix), length (m).
%  'axis',h        handle of axis or UIAxis to draw into (default is current axis)
%  'movie',M       create a movie file in file M
%
% Example::
%          [car.image,~,car.alpha] = imread('car2.png');  % image and alpha layer
%          car.rotation = 180;  % image rotation to align front with world x-axis
%          car.center = [648; 173]; % image coordinates of center of the back wheels
%          car.length = 4.2; % real world length for scaling (guess)
%          h = plotvehicle(x, 'model', car)  % draw car at configuration x
%          plotvehicle(x, 'handle', h)  % animate car to configuration x
%
% Notes::
% - The vehicle is drawn relative to the size of the axes, so set them
%   first using axis().
% - For backward compatibility, 'fill', is a synonym for 'fillcolor'
% - For the 'model' option, you provide a monochrome or color image of the
%   vehicle.  Optionally you can provide an alpha mask (0=transparent).
%   Specify the reference point on the vehicle as the (x,y) pixel
%   coordinate within the image.  Specify the rotation, in degrees, so that
%   the car's front points to the right.  Finally specify a length of the
%   car, the image is scaled to be that length in the plot.
% - Set 'fps' to Inf to have zero pause
%
% See also Vehicle.plot, Animate, plotpoly, demos/car_animation

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

% TODO needs to work for 3D point

function h_ = plotvehicle(x, varargin)

opt.scale = 1/60;
opt.size = [];
opt.shape = {'triangle', 'box'};
opt.fps = 20;
opt.handle = [];
opt.image = [];
opt.model = [];
opt.retain = false;
opt.axis = [];
opt.trail = '';
opt.movie = [];

if numel(x) == 3
    x = x(:)';   % enforce row vector
end

[opt,args] = tb_optparse(opt, varargin);

if isempty(opt.handle)
    % create a new robot
    % compute some default dimensions based on axis scaling
    if isempty(opt.axis)
        opt.axis = gca;
    end
    
    ax = opt.axis;
    a = [ax.XLim ax.YLim];
    d = (a(2)+a(4) - a(1)-a(3)) * opt.scale;
    
    % create the robot
    h.vehicle = draw_robot(d, opt, args);
    
    if ~isempty(opt.trail)
        hold on
        h.trail = plot(0,0, opt.trail);
        hold off
    end
    h.opt = opt;
    
    plotvehicle(x, 'handle', h, varargin{:});
else
    % we are animating
    h = opt.handle;
    anim = Animate(opt.movie);
    
    for i=1:size(x,1)
        s2 = se2(rotm2d(x(i,3)), [x(i,1) x(i,2)]);
        h.vehicle.Matrix = se2To3(s2).tform;  % convert (x,y,th) to SE(3)
        
        % check if retain is on
        if h.opt.retain
            plotvehicle(x(i,:));
        end
        
        % extend the line if required
        if ~isempty(h.opt.trail)
            
            l = h.trail;
            l.XData = [l.XData x(i,1)];
            l.YData = [l.YData x(i,2)];
        end
        
        % pause a while
        anim.add();
        if ~isinf(h.opt.fps)
            pause(1/h.opt.fps)
        end
    end
    anim.close();
end

if nargout > 0
    h_ = h;
end

end

function h = draw_robot(d, opt, args)

if ~isempty(opt.model)
    % display an image of a vehicle, pass in a struct
    if isstruct(opt.model)
        img = opt.model.image;
        rotation = opt.model.rotation;
        center = opt.model.center;
        scale = opt.model.length / max(size(img,2), size(img,1)) ;
    else
        img = opt.image;
        center = [size(img,2)/2 size(img,1)/2];
    end
    h = hgtransform('Tag', 'image');
    h2 = hgtransform('Matrix', trotz(rotation, 'deg')*trscale(scale)*transl(-center(1), -center(2),0), 'Parent', h );
    if isfield(opt.model, 'alpha')
        % use alpha data if provided
        alpha = opt.model.alpha;
    else
        % otherwise black pixels (0,0,0) are set to transparent
        alpha =  any(img>0,3);
    end
    image(img, 'AlphaData', alpha, 'Parent', h2);
    %axis equal
else
    % display a simple polygon
    switch opt.shape
        case 'triangle'
            if ~isempty(opt.size)
                d = opt.size;
            end
            L = d; W = 0.6*d;
            corners = [
                L       0
                -L      -W
                -L       W]';
        case 'box'
            if ~isempty(opt.size)
                switch length(opt.size)
                    case 1
                        W = opt.size/2; L1 = opt.size/2; L2 = opt.size/2;
                    case 2
                        W = opt.size(1)/2; L1 = opt.size(2)/2; L2 = opt.size(2)/2;
                    case 3
                        W = opt.size(1)/2; L1 = opt.size(2); L2 = opt.size(3);
                end
            else
                L1 = d; L2 = d; W = 0.6*d;
            end
            corners = [
                -L1       W
                0.6*L2   W
                L2       0.5*W
                L2      -0.5*W
                0.6*L2  -W
                -L1      -W ]';
    end
    h = plotpoly(corners, 'animate', 'axis', opt.axis, args{:});
end
end
