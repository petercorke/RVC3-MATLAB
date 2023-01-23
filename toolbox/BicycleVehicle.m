%BicycleVehicle Car-like vehicle class
%
%   This concrete class models the kinematics of a car-like vehicle
%   (bicycle or Ackermann model) on a plane.  For given steering and
%   velocity inputs it updates the true vehicle state and returns
%   noise-corrupted odometry readings.
%
%   VEH = BicycleVehicle creates a BicycleVehicle object with the
%   kinematics of a bicycle (or Ackermann) vehicle. The properties for
%   wheel base, maximum steering angle, and maximum acceleration will be
%   set to default values.
%   
%   VEH = BicycleVehicle(Name=Value) specifies additional
%   options using one or more name-value pair arguments.
%   Specify the options after all other input arguments.
% 
%   MaxSteeringAngle - Maximum steer angle (in radians)
%                      Default: 0.5
%   MaxAcceleration  - Maximum acceleration (in m/s^2)
%                      Default: Inf
%   MaxSpeed         - Maximum speed (in m/s)
%                      Default: 1
%   WheelBase        - Wheel base (in meters)
%                      Default: 1
%   Covariance       - Odometry covariance (2x2)
%                      The covariance is used by a "hidden" random number 
%                      generator within the class.
%                      Default: zeros(2)
%
%
%   BicycleVehicle methods:
%      addDriver  - Attach a driver object to this vehicle
%      control    - Generate the control inputs for the vehicle
%      derivative - Derivative of state given inputs
%      init       - Initialize vehicle state
%      f          - Predict next state based on odometry
%      Fx         - Jacobian of f wrt x
%      Fv         - Jacobian of f wrt odometry noise
%      update     - Update the vehicle state
%      run        - Run for multiple time steps
%      step       - Move one time step and return noisy odometry  
%      char       - Convert to string
%      plot       - Plot/animate vehicle on current figure
%      plotxy     - Plot the true path of the vehicle
%      plotv      - Plot/animate a pose on current figure
%
%   BicycleVehicle properties:
%      MaxSteeringAngle - Maximum steered-wheel angle (in radians)
%      MaxAcceleration  - Maximum acceleration (in m/s^2)
%      MaxSpeed         - Maximum speed (in m/s)
%      WheelBase        - Wheel base of vehicle (in meters)
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
%      % Odometry covariance (per time step) is
%      V = diag([0.02 deg2rad(0.5)].^2);
% 
%      % Create a vehicle with this noisy odometry
%      vehicle = BicycleVehicle(Covariance=V);
%  
%      % Display its initial state
%      vehicle.q'
%
%      % Apply a speed (0.2 m/s) and steered-wheel angle (0.1 rad) 
%      % for 1 time step
%      odo = vehicle.step(0.2,0.1)
%
%      % Where odo is the noisy odometry estimate, and the new true
%      % vehicle state is
%      vehicle.q'
%
%      % We can add a driver object
%      vehicle.addDriver( RandomDriver(10) )
%
%      % Which will move the vehicle within the region -10<x<10, -10<y<10 
%      % which we can see by
%      vehicle.run(1000)
% 
%      % Which shows an animation of the vehicle moving for 1000 time steps
%      % between randomly selected waypoints.
%
%
%   Reference:
%   - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%     P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%     Chapter 2
%
% See also RandomDriver, EKF.

% Copyright 2022-2023 Peter Corke, Witek Jachimczyk, Remo Pillat

classdef BicycleVehicle < Vehicle

    properties
        %WheelBase - Wheel base of vehicle (in meters)
        %   Default: 1
        WheelBase

        %MaxSteeringAngle - Maximum steered-wheel angle (in radians)
        %   Default: 0.5
        MaxSteeringAngle

        %MaxAcceleration - Maximum acceleration (in m/s^2)
        %   Default: Inf
        MaxAcceleration
    end

    properties (Access=private)
        Kinematics
        vprev
        steerprev        
    end

    methods

        function veh = BicycleVehicle(varargin)
            %BicycleVehicle Construct object

            veh = veh@Vehicle(varargin{:});

            veh.q = zeros(1,3);

            opt.WheelBase = 1;
            opt.MaxSteeringAngle = 0.5;
            opt.MaxAcceleration = Inf;

            veh = tb_optparse(opt, veh.options, veh);

            veh.vprev = 0;
            veh.q = veh.q0;

            veh.Kinematics = bicycleKinematics("WheelBase", opt.WheelBase, "VehicleSpeedRange", ...
                [-veh.MaxSpeed, veh.MaxSpeed], "MaxSteeringAngle", opt.MaxSteeringAngle);
        end

        function qnext = f(~, q, odo, w)
            %F Predict next state based on odometry
            %
            %   QN = VEH.F(Q, ODO) is the predicted next state QN (1-by-3) based 
            %   on current state Q (1-by-3 vector) and odometry ODO
            %   (1-by-2) = [distance dtheta] where distance = norm([dx dy])
            %   and dtheta is the heading change (in radians).
            %
            %   QN = VEH.F(Q, ODO, W) also applies the odometry noise, W,
            %   which is a 1-by-2 vector of additive distance and dtheta
            %   noise.
            %
            %   This function supports vectorized inputs where Q and QN are 
            %   matrices of size N-by-3.
            if nargin < 4
                w = [0 0];
            end

            dd = odo(1) + w(1); dth = odo(2) + w(2);

            % straightforward code:
            % thp = q(3) + dth;
            % qnext = zeros(1,3);
            % qnext(1) = q(1) + (dd + w(1))*cos(thp);
            % qnext(2) = q(2) + (dd + w(1))*sin(thp);
            % qnext(3) = q(3) + dth + w(2);
            %
            % vectorized code:

            thp = q(:,3) + dth;
            qnext = q + [dd*cos(thp)  dd*sin(thp) ones(size(q,1),1)*dth];
        end

        function dq = derivative(veh, ~, q, u)
            %DERIVATIVE Time derivative of state
            %
            %   DQ = VEH.DERIVATIVE(T,Q,U) is the time derivative of state 
            %   (1-by-3) at the state Q (1-by-3) with input U (1-by-3).
            %
            %   The parameter T is ignored but called from a continuous time 
            %   integrator such as ode45 or Simulink.

            % implement acceleration limit if required
            if ~isinf(veh.MaxAcceleration)
                if (u(1) - veh.vprev)/veh.dt > veh.MaxAcceleration
                    u(1) = veh.vprev + veh.MaxAcceleration * veh.dt;
                elseif (u(1) - veh.vprev)/veh.dt < -veh.MaxAcceleration
                    u(1) = veh.vprev - veh.MaxAcceleration * veh.dt;
                end
                veh.vprev = u(1);
            end

            % Use the standard kinematics model to calculate the kinematics
            dq = veh.Kinematics.derivative(q, u)';

%             % Reflect speed and steer angle limits in control input
%             u(1) = min(veh.MaxSpeed, max(u(1), -veh.MaxSpeed));
%             u(2) = min(veh.MaxSteeringAngle, max(u(2), -veh.MaxSteeringAngle));
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

            % update the state
            dx = veh.dt * veh.derivative([], veh.q, u);
            veh.q = veh.q + dx;

            % compute and save the odometry
            odo = [ norm(dx(1:2)) dx(3) ];
            veh.odometry = odo;

            veh.qhist = [veh.qhist; veh.q];   % maintain history
        end


        function J = Fx(~, q, odo)
            %Fx Jacobian df/dq
            %
            %   J = VEH.Fx(Q, ODO) is the Jacobian df/dq (3-by-3) at the state 
            %   Q, for odometry input ODO (1-by-2) = [distance  heading_change].
            %
            %   See also f, Fv.

            dd = odo(1); 
            %dth = odo(2);
            theta = q(3);

            J = [
                1   0   -dd*sin(theta)
                0   1   dd*cos(theta)
                0   0   1
                ];
        end

        function J = Fv(~, x, ~)
            %Fv Jacobian df/dv
            %
            %   J = VEH.Fv(Q, ODO) is the Jacobian df/dv (3-by-2) at the 
            %   state Q, for odometry input ODO (1-by-2) = 
            %   [distance, heading_change].
            %
            %   See also F, Fx.

            thp = x(3);

            J = [
                cos(thp)    0
                sin(thp)    0
                0           1
                ];
        end

        function s = char(veh)
            %CHAR Convert to a string
            %
            %   s = VEH.CHAR is a string showing vehicle parameters and 
            %   state in a compact human readable format.
            %
            %   See also DISP.

            ss = char@Vehicle(veh);

            s = 'BicycleVehicle object';
            s = char(s, sprintf('  WheelBase=%g, MaxSteeringAngle=%g, MaxAcceleration=%g', veh.WheelBase, veh.MaxSteeringAngle, veh.MaxAcceleration));
            s = char(s, ss);
        end
    end % method

end % classdef
