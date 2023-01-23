%Vehicle Abstract vehicle class
%
%   This abstract class models the kinematics of a mobile robot moving on
%   a plane and with a pose in SE(2).  For given steering and velocity inputs it
%   updates the true vehicle state and returns noise-corrupted odometry
%   readings.
%
%   VEH = Vehicle creates a Vehicle object. All properties will be set to 
%   default values.
%
%   VEH = Vehicle(Name=Value) specifies additional
%   options using one or more name-value pair arguments.
%   Specify the options after all other input arguments.
% 
%   MaxSpeed         - Maximum speed (in m/s)
%                      Default: 1
%   WheelBase        - Wheel base (in meters)
%                      Default: 1
%   Covariance       - Odometry covariance (2x2)
%                      The covariance is used by a "hidden" random number 
%                      generator within the class.
%                      Default: zeros(2)
%
%   Vehicle methods:
%      addDriver  - Attach a driver object to this vehicle
%      control    - Generate the control inputs for the vehicle
%      init       - Initialize vehicle state
%      f          - Predict next state based on odometry
%      update     - Update the vehicle state
%      run        - Run for multiple time steps
%      run2       - Run with control inputs
%      step       - Move one time step and return noisy odometry  
%      char       - Convert to string
%      plot       - Plot/animate vehicle on current figure
%      plotxy     - Plot the true path of the vehicle
%      plotv      - Plot/animate a pose on current figure
%
%   Vehicle properties:
%      MaxSpeed         - Maximum speed (in m/s)
%      q                - True vehicle state (x,y,theta)
%      q0               - Initial state (x,y,theta)
%      qhist            - History of true vehicle state
%      odometry         - Distance moved in the last interval                   
%      V                - Odometry covariance matrix
%      dt               - Sample time interval (in seconds)
%      rdim             - Robot size as fraction of plot window
%      driver           - Driver object
%      verbose          - True if command-line printouts should be verbose
%
%
%   Examples:
%
%      % If veh is an instance of a Vehicle class then we can add a driver object
%      veh.addDriver(RandomDriver(10))
%
%      % Which will move the vehicle within the region -10<x<10, -10<y<10 
%      % which we can see by
%      veh.run(1000)
%
%      % Which shows an animation of the vehicle moving for 1000 time steps
%      % between randomly selected waypoints.
%
%
%   Reference:
%
%   Robotics, Vision & Control, Chap 6
%   Peter Corke,
%   Springer 2011
%
%   See also BicycleVehicle, RandomDriver, EKF.

% Copyright 2022-2023 Peter Corke, Witek Jachimczyk, Remo Pillat

classdef Vehicle < handle

    properties
        % state

        %q - True vehicle state (x,y,theta)
        %   Returned as 1-by-3 vector.
        q

        %qhist - History of true vehicle states
        %   Stored as N-by-3 matrix.
        qhist

        % parameters

        %MaxSpeed - Maximum speed allowed for vehicle (in m/s)
        %   Default: 1
        MaxSpeed

        dim         % dimension of the world -dim -> +dim in x and y

        %rdim - Robot size as fraction of plot window
        %   Default: 0.2
        rdim

        %dt - Sample time interval (in seconds)
        %   Default: 0.1
        dt

        %V - Odometry covariance
        %   Stored as 2-by-2 matrix
        %   Default: zeros(2)
        V

        %odometry - Distance moved in the last interval
        %   Stored as 1-by-2 vector [norm([dx dy]) dtheta]                         
        %   See also update.
        odometry

        %verbose - True if command-line printouts should be verbose
        %   Default: false
        verbose

        %driver - Driver object
        %   Default: []
        driver

        %q0 - Initial state (x,y,theta)
        %   Stored as 1-by-3 vector
        %   Default: [0 0 0]
        q0

        options

        %vhandle - Handle to vehicle graphics object
        vhandle

        %vtrail - Handle to vehicle trail graphics object
        vtrail
    end

    methods(Abstract)
        f
    end

    methods

        function veh = Vehicle(varargin)
            %Vehicle Construct object

            % vehicle common
            opt.Covariance = [];
            opt.rdim = 0.2;
            opt.dt = 0.1;
            opt.q0 = zeros(1,3);
            opt.MaxSpeed = 1;
            opt.vhandle = [];

            [opt,args] = tb_optparse(opt, varargin);

            veh.V = opt.Covariance;
            veh.rdim = opt.rdim;
            veh.dt = opt.dt;
            veh.q0 = opt.q0(:)';
            assert(isvec(veh.q0, 3), 'Initial configuration must be a 3-vector');
            veh.MaxSpeed = opt.MaxSpeed;
            veh.options = args;  % unused options go back to the subclass
            veh.vhandle = opt.vhandle;
            veh.qhist = [];
        end

        function init(veh, q0)
            %INIT Reset state
            %
            %   VEH.INIT sets the state VEH.q := VEH.q0, initializes the driver
            %   object (if attached), and clears the history.
            %
            %   VEH.INIT(Q0) as above but the state is initialized to Q0.

            % TODO: should this be called from run?

            if nargin > 1
                veh.q = q0(:)';
            else
                veh.q = veh.q0;
            end
            veh.qhist = [];

            if ~isempty(veh.driver)
                veh.driver.init();
            end

            veh.vhandle = [];
        end

        function yy = path(veh, t, u, y0)
            %PATH Compute path for constant inputs
            %
            %   QF = VEH.PATH(TF,U) is the final state of the vehicle (1-by-3) 
            %   from the initial state (0,0,0) with the control inputs U 
            %   (vehicle specific). TF is a scalar to specify the total 
            %   integration time (in seconds).
            %
            %   QP = VEH.PATH(TV,U) is the trajectory of the vehicle (N-by-3) 
            %   from the initial state (0,0,0) with the control inputs U 
            %   (vehicle specific).  T is a vector (N) of times for which 
            %   elements of the trajectory will be computed.
            %
            %   QP = VEH.PATH(T,U,Q0) as above but specify the initial state.
            %
            %   Integration is performed using ODE45.
            %   The ODE being integrated is given by the derivative method 
            %   of the vehicle object.
            %
            %   See also ODE45, derivative.

            if length(t) == 1
                tt = [0 t];
            else
                tt = t;
            end

            if nargin < 4
                y0 = [0 0 0];
            end
            out = ode45( @(t,y) veh.derivative(t, y, u), tt, y0);

            y = out.y';
            if nargout == 0
                plot(y(:,1), y(:,2));
                grid on
                xlabel('X'); ylabel('Y')
            else
                yy = y;
                if length(t) == 1
                    % if scalar time given, just return final state
                    yy = yy(end,:);
                end
            end
        end

        function addDriver(veh, driver)
            %addDriver Add a driver for the vehicle
            %
            %   VEH.addDriver(D) connects a driver object D to the vehicle.  
            %   The driver object has one public method:
            %        [speed, steer] = D.demand;
            %   that returns a speed and steer angle.
            %
            %   The step method invokes the driver if one is attached.
            %
            %   See also step, RandomDriver.

            veh.driver = driver;
            driver.Vehicle = veh;
        end

        function odo = update(veh, u)
            %UPDATE Update the vehicle state
            %
            %   ODO = VEH.UPDATE(U) is the true odometry value for
            %   motion with U = [speed steer].
            %
            %   This appends new state to state history property qhist.
            %   The odometry output ODO is also saved as property odometry.
            %
            %   See also qhist, odometry.

            xp = veh.q; % previous state
            veh.q(1) = veh.q(1) + u(1)*veh.dt*cos(veh.q(3));
            veh.q(2) = veh.q(2) + u(1)*veh.dt*sin(veh.q(3));
            veh.q(3) = veh.q(3) + u(1)*veh.dt/veh.WheelBase * u(2);
            odo = [vecnorm(veh.q(1:2)-xp(1:2)) veh.q(3)-xp(3)];
            veh.odometry = odo;

            veh.qhist = [veh.qhist; veh.q];   % maintain history
        end

        function odo = step(veh, varargin)
            %STEP Advance one timestep
            %
            %   ODO = VEH.STEP(SPEED,STEER) updates the vehicle state for one timestep
            %   of motion at specified SPEED and STEER angle, and returns noisy odometry.
            %
            %   ODO = VEH.STEP updates the vehicle state for one timestep of motion and
            %   returns noisy odometry.  If a "driver" is attached then its DEMAND method
            %   is invoked to compute speed and steer angle.  If no driver is attached
            %   then speed and steer angle are assumed to be zero.
            %
            %   The process noise covariance is specified in the property V.
            %
            %   See also control, update, addDriver.

            % get the control input to the vehicle from either passed demand or driver
            u = veh.control(varargin{:});

            % compute the true odometry and update the state
            odo = veh.update(u);

            % add noise to the odometry
            if ~isempty(veh.V)
                odo = veh.odometry + randn(1,2)*sqrtm(veh.V);
            end
        end

        function u = control(veh, speed, steer)
            %CONTROL Compute the control input to vehicle
            %
            %   U = VEH.CONTROL(SPEED,STEER) is a control input (1-by-2) = 
            %   [speed,steer] based on provided controls SPEED,STEER to which 
            %   speed and steering angle limits have been applied.
            %
            %   U = VEH.CONTROL as above but demand originates with a "driver" object if
            %   one is attached, the driver's DEMAND() method is invoked. If no driver is
            %   attached then speed and steer angle are assumed to be zero.
            %
            %   See also step, RandomDriver

            if nargin < 2
                % if no explicit demand, and a driver is attached, use
                % it to provide demand
                if ~isempty(veh.driver)
                    [speed, steer] = veh.driver.demand();
                else
                    % no demand, do something safe
                    speed = 0;
                    steer = 0;
                end
            end

            % clip the speed
            if isempty(veh.MaxSpeed)
                u(1) = speed;
            else
                u(1) = min(veh.MaxSpeed, max(-veh.MaxSpeed, speed));
            end

            % clip the steering angle
            if isprop(veh, 'steermax') && ~isempty(veh.steermax)
                u(2) = max(-veh.steermax, min(veh.steermax, steer));
            else
                u(2) = steer;
            end
        end

        function p = run(veh, nsteps)
            %RUN Run the vehicle simulation
            %
            %   VEH.RUN(N) runs the vehicle model for N timesteps and plots
            %   the vehicle pose at each step.
            %
            %   P = VEH.RUN(N) runs the vehicle simulation for N timesteps and
            %   return the state history (Nx3) without plotting.  Each row
            %   is (x,y,theta).
            %
            %   See also step, run2.

            if nargin < 2
                nsteps = 1000;
            end
            if ~isempty(veh.driver)
                veh.driver.init()
            end
            %veh.clear();
            if ~isempty(veh.driver)
                veh.driver.plot();
            end

            veh.plot();
            for i=1:nsteps
                veh.step();
                if nargout == 0
                    % if no output arguments then plot each step
                    veh.plot();
                    drawnow
                end
            end
            p = veh.qhist;
        end

        function p = run2(veh, T, q0, speed, steer)
            %RUN2 Run the vehicle simulation with control inputs
            %
            % P = VEH.RUN2(T, Q0, SPEED, STEER) runs the vehicle model for a time T with
            % speed SPEED and steer-ed wheel angle STEER. P (Nx3) is the path followed and
            % each row is (x,y,theta).
            %
            % This is a faster and more specific version of the run method.
            %
            % See also run, step.

            veh.init(q0);

            for i=1:(T/veh.dt)
                veh.update([speed steer]);
            end
            p = veh.qhist;
        end

        function h = plot(veh, varargin)
            %PLOT Plot vehicle
            %
            %   The vehicle is depicted graphically as a narrow triangle that travels
            %   "point first" and has a length VEH.rdim.
            %
            %   VEH.PLOT plots the vehicle on the current axes at a pose given by
            %   the current robot state.  If the vehicle has been previously plotted, 
            %   its pose is updated.
            %
            %   VEH.PLOT(Q) plots the vehicle at pose given by Q (1-by-3).
            %
            %   H = VEH.PLOT(...) plots the vehicle and returns its graphics
            %   handle in H.
            %
            %   VEH.PLOT(H, Q) updates the pose of the vehicle graphic represented
            %   by the handle H to pose Q. This syntax is useful if animating 
            %   multiple robots in the same figure.
            %
            %   VEH.PLOT(...,Name=Value) specifies additional
            %   options using one or more name-value pair arguments.
            %   Specify the options after all other input arguments.
            %
            %   scale     - Draw vehicle with length SCALE x maximum axis dimension
            %   size      - Draw vehicle with length SIZE
            %   fillcolor - Color of inside of vehicle, MATLAB color spec
            %   edgecolor - Color of edge of vehicle, MATLAB color spec
            %   trail     - Draw a trail of previous positions with specific 
            %               line style. This supports the same name-value
            %               pairs as LINE. Specify the value as a cell
            %               array.
            %
            %   Examples:
            %      VEH.PLOT(trail={'Color', 'r', 'Marker', 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'MarkerSize', 3})
            %
            %   See also plotvehicle, plotv, rdim.


            if isempty(veh.vhandle)
                veh.vhandle = veh.plotv(veh.q, varargin{:});
            end

            if ~isempty(varargin) && isnumeric(varargin{1})
                % V.plot(X)
                pos = varargin{1}; % use passed value
            else
                % V.plot()
                pos = veh.q;    % use current state
            end

            % animate it
            veh.plotv(veh.vhandle, pos);

            h = veh.vhandle;

        end


        function out = plotxy(veh, varargin)
            %PLOTXY Plots true path followed by vehicle
            %
            %   VEH.PLOTXY plots the true xy-plane path followed by the vehicle.
            %   The path is extracted from the qhist property.
            %
            %   VEH.PLOTXY(Name=Value) also passes the line style arguments 
            %   to plot. This supports the same name-value pairs as LINE.
            %
            %   See also plot.

            xyt = veh.qhist;
            if nargout == 0
                plot(xyt(:,1), xyt(:,2), varargin{:});
            else
                out = xyt;
            end
        end

        function verbosity(veh, v)
            %VERBOSITY Set verbosity
            %
            %   VEH.VERBOSITY(A) set verbosity to A.
            %   If A is FALSE, there no command window printouts, if A is
            %   TRUE verbose command window printouts occur.
            %
            %   See also verbose.

            veh.verbose = v;
        end

        function disp(nav)
            %DISP Display vehicle parameters and state
            %
            %   VEH.DISP displays vehicle parameters and state in compact
            %   human readable form.
            %
            %   This method is invoked implicitly at the command line when the result
            %   of an expression is a Vehicle object and the command has no trailing
            %   semicolon.
            %
            %   See also char.

            loose = strcmp( get(0, 'FormatSpacing'), 'loose'); %#ok<GETFSP> 
            if loose
                disp(' ');
            end
            %disp([inputname(1), ' = '])
            disp( char(nav) );
        end

        function s = char(veh)
            %CHAR Convert to a string
            %
            %   s = VEH.CHAR is a string showing vehicle parameters and 
            %   state in a compact human readable format.
            %
            %   See also DISP.

            s = '  Superclass: Vehicle';
            s = char(s, sprintf(...
                '    MaxSpeed=%g, dT=%g, nhist=%d', ...
                veh.MaxSpeed, veh.dt, ...
                size(veh.qhist,1)));
            if ~isempty(veh.V)
                s = char(s, sprintf(...
                    '    Covariance=(%g, %g)', ...
                    veh.V(1,1), veh.V(2,2)));
            end
            s = char(s, sprintf('    Configuration: x=%g, y=%g, theta=%g', veh.q));
            if ~isempty(veh.driver)
                s = char(s, '    driven by::');
                s = char(s, [['      '; '      '] char(veh.driver)]);
            end
        end

    end % method

    methods(Static)

        function h = plotv(varargin)
            %PLOTV Plot ground vehicle pose
            %
            %   H = Vehicle.PLOTV(Q) draws a representation of a ground robot as an
            %   oriented triangle with pose Q (1x3) [x,y,theta].  H is a graphics handle.
            %   If Q (Nx3) is a matrix it is considered to represent a trajectory in which case
            %   the vehicle graphic is animated.
            %
            %   Vehicle.PLOTV(H, Q) updates the pose of the graphic represented
            %   by the handle H to pose Q.
            %
            %   Vehicle.PLOTV(...,Name=Value) specifies additional
            %   options using one or more name-value pair arguments.
            %   Specify the options after all other input arguments.
            %
            %   scale     - Draw vehicle with length SCALE x maximum axis dimension
            %   size      - Draw vehicle with length SIZE
            %   fillcolor - Color of inside of vehicle, MATLAB color spec
            %   edgecolor - Color of edge of vehicle, MATLAB color spec
            %   fps       - Frames per second in animation mode (default 10)
            %
            %   This is a static class method.
            %
            %   See also plotvehicle, plot.

            if isstruct(varargin{1})
                plotvehicle(varargin{2}, 'handle', varargin{1});
            else
                h = plotvehicle(varargin{1}, 'fillcolor', 'b', 'alpha', 0.5);
            end

        end
    end % static methods

end % classdef
