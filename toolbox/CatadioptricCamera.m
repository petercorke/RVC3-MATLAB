%CatadioptricCamera  Catadioptric camera class
%
% A concrete class for a catadioptric camera, subclass of Camera.
%
% Methods::
%
% project          project world points to image plane
%
% plot             plot/return world point on image plane
% hold             control hold for image plane
% ishold           test figure hold for image plane
% clf              clear image plane
% figure           figure holding the image plane
% mesh             draw shape represented as a mesh
% point            draw homogeneous points on image plane
% line             draw homogeneous lines on image plane
% plot_camera      draw camera
%
% rpy              set camera attitude
% move             copy of Camera after motion
% center           get world coordinate of camera center
%
% delete           object destructor
% char             convert camera parameters to string
% display          display camera parameters
%
% Properties (read/write)::
% npix         image dimensions in pixels (2x1)
% pp           intrinsic: principal point (2x1)
% rho          intrinsic: pixel dimensions (2x1) [metres]
% f            intrinsic: focal length [metres]
% p            intrinsic: tangential distortion parameters
% T            extrinsic: camera pose as homogeneous transformation
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
%
% See also CentralCamera, Camera.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

% TODO:
%   make a parent imaging class and subclass perspective, fisheye, panocam
%   test for points in front of camera and set to NaN if not
%   test for points off the image plane and set to NaN if not
%     make clipping/test flags
classdef CatadioptricCamera < Camera
    
    properties
        k       % radial distortion vector
        projection   % projection model
        maxangle    % maximum elevation angle (above horizontal)
    end
    
    properties (SetAccess = private)
    end
    
    properties (GetAccess = private, SetAccess = private)
        
    end
    
    properties (GetAccess = private)
    end
    
    properties (Dependent = true, SetAccess = private)
    end
    
    methods
        
        function cam = CatadioptricCamera(varargin)
            %CatadioptricCamera.CatadioptricCamera Create central projection camera object
            %
            % C = CatadioptricCamera() creates a central projection camera with canonic
            % parameters: f=1 and name='canonic'.
            %
            % C = CatadioptricCamera(OPTIONS) as above but with specified parameters.
            %
            % Options::
            % 'name',N         Name of camera
            % 'focal',F        Focal length (metres)
            % 'default'        Default camera parameters: 1024x1024, f=8mm,
            %                  10um pixels, camera at origin, optical axis
            %                  is z-axis, u- and v-axes parallel to x- and y-axes
            %                  respectively.
            % 'projection',M   Catadioptric model: 'equiangular' (default), 'sine',
            %                  'equisolid', 'stereographic'
            % 'k',K            Parameter for the projection model
            % 'maxangle',A     The maximum viewing angle above the horizontal
            %                  plane.
            % 'resolution',N   Image plane resolution: NxN or N=[W H].
            % 'sensor',S       Image sensor size in metres (2x1)
            % 'center',P       Principal point (2x1)
            % 'pixel',S        Pixel size: SxS or S=[W H].
            % 'noise',SIGMA    Standard deviation of additive Gaussian
            %                  noise added to returned image projections
            % 'pose',T         Pose of the camera as a homogeneous
            %                  transformation
            %
            % Notes::
            % - The elevation angle range is from -pi/2 (below the mirror) to
            %   maxangle above the horizontal plane.
            %
            % See also Camera, FisheyeCamera, CatadioptricCamera, SphericalCamera.
            
            % invoke the superclass constructor
            cam = cam@Camera(varargin{:});
            cam.type = 'FishEye';
            
            if nargin == 0,
                % default values
                cam.type = 'catadioptric';
                cam.k = 1;
                cam.projection = 'equiangular';
                cam.name = 'catadioptric-default';
                
            else
                % process remaining options
                opt.k = [];
                opt.maxangle = [];
                opt.projection = {'equiangular', 'sine', 'equisolid', 'stereographic'};
                opt.default = false;
                
                [opt,args] = tb_optparse(opt, varargin);
                
                cam.projection = opt.projection;
                cam.maxangle = opt.maxangle;
                
                if opt.default
                    cam.s = [10e-6, 10e-6];      % square pixels 10um side
                    cam.npix = [1024, 1024];  % 1Mpix image plane
                    cam.pp = [512, 512];      % principal point in the middle
                    cam.limits = [0 1024 0 1024];
                    cam.name = 'default';
                    r = min([(cam.npix-cam.pp).*cam.s, cam.pp.*cam.s]);
                    cam.k = 2*r/pi;
                    n = 0;
                end
                
                if isempty(cam.k)
                    % compute k if not specified, so that hemisphere fits into
                    % image plane
                    r = min([(cam.npix-cam.pp).*cam.rho, cam.pp.*cam.rho]);
                    switch cam.projection
                        case 'equiangular'
                            cam.k = r / (pi/2 + cam.maxangle);
                        case 'sine'
                            cam.k = r;
                        case 'equisolid'
                            cam.k = r / sin(pi/4);
                        case 'stereographic'
                            cam.k = r / tan(pi/4);
                            r = cam.k * tan(theta/2);
                        otherwise
                            error('unknown projection model');
                    end
                end
            end
        end
        
        function s = char(c)
            
            s = sprintf('name: %s [%s]', c.name, c.type);
            s = strvcat(s, sprintf(    '  model:          %s', c.projection));
            s = strvcat(s, sprintf(    '  k:              %-11.4g', c.k));
            s = strvcat(s, char@Camera(c) );
        end
        
        % return field-of-view angle for x and y direction (rad)
        function th = fov(c)
            th = 2*atan(c.npix/2.*c.s / c.f);
        end
        
        % do the fisheye projection
        function uv = project(cam, P, varargin)
            %CatadioptricCamera.project Project world points to image plane
            %
            % UV = C.project(P, OPTIONS) are the image plane coordinates for the world
            % points P.  The columns of P (3xN) are the world points and the columns
            % of UV (2xN) are the corresponding image plane points.
            %
            % Options::
            % 'pose',T         Set the camera pose to the pose T (homogeneous transformation (4x4) or SE3)
            %                  before projecting points to the camera image plane.  Temporarily overrides
            %                  the current camera pose C.T.
            % 'objpose',T      Transform all points by the pose T (homogeneous transformation (4x4) or SE3)
            %                  before projecting them to the camera image plane.
            %
            % See also FishEyeCamera.plot, Camera.plot.         
            
            np = size(P,1);
            
            opt.objpose = [];
            opt.pose = [];
            
            [opt,arglist] = tb_optparse(opt, varargin);
            
            if isempty(opt.pose)
                opt.pose = cam.T;
            end
            if isempty(opt.objpose)
                opt.objpose = se3();
            else
                opt.objpose = se3(opt.objpose);
            end
            
            % transform all the points to camera frame
            tform = inv(opt.pose) * opt.objpose;

            X = tform.transform(P);         % project them
            
            R = vecnorm(X(:, 1:3)')';
            phi = atan2( X(:, 2), X(:, 1) );
            theta = acos( X(:, 3) ./ R );
            
            switch cam.projection
                case 'equiangular'
                    r = cam.k * theta;
                case 'sine'
                    r = cam.k * sin(theta);
                case 'equisolid'
                    r = cam.k * sin(theta/2);
                case 'stereographic'
                    r = cam.k * tan(theta/2);
                otherwise
                    error('unknown projection model');
            end
            
            x = r .* cos(phi);
            y = r .* sin(phi);
            
            uv = [x/cam.rho(1)+cam.pp(1), y/cam.rho(2)+cam.pp(2)];
            
            if cam.noise
                % add Gaussian noise with specified standard deviation
                uv = (uv' + diag(cam.noise) * randn(size(uv')))';
            end
        end
    end % methods
end % class
