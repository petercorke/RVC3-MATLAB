%BicycleVehicle Car-like vehicle class
%
%   This concrete class models the kinematics of a car-like vehicle (bicycle
%   or Ackermann model) on a plane.  For given steering and velocity inputs it
%   updates the true vehicle state and returns noise-corrupted odometry
%   readings.
%
%   V = BicycleVehicle creates a BicycleVehicle object with the kinematics of a
%   bicycle (or Ackermann) vehicle. The properties for wheel base, maximum
%   steering angle, and maximum acceleration will be set to default values.
%   
%   V = BicycleVehicle(Name=Value) specifies additional
%   options using one or more name-value pair arguments.
%   Specify the options after all other input arguments.
% 
%   MaxSteeringAngle - Maximum steer angle [rad]
%                      Default: 0.5
%   MaxAcceleration  - Maximum acceleration [m/s^2]
%                      Default: Inf
%   WheelBase        - Wheel base [m]
%                      Default: 1
%   Covariance       - Odometry covariance (2x2)
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
%      MaxSteeringAngle - Maximum steer angle [rad]
%                         Default: 0.5
%      MaxAcceleration  - Maximum acceleration [m/s^2]
%                         Default: Inf
%      WheelBase        - Wheel base [m]
%                         Default: 1
%      q0               - Initial state (x,y,theta)
%                         Default: [0 0 0]
%      dt               - Time interval [s]
%                         Default: 0.1
%      rdim             - Robot size as fraction of plot window
%                         Default: 0.2
%      verbose          - True if command-line printouts should be verbose
%                         Default: false
%
%   Examples:
%
%      % Odometry covariance (per time step) is
%      V = diag([0.02, 0.5*pi/180].^2);
% 
%      % Create a vehicle with this noisy odometry
%      v = BicycleVehicle( Covariance=diag([0.1 0.01].^2));
%  
%      % and display its initial state
%      v
%
%   Reference:
%      Robotics, Vision & Control, Chap 6
%      Peter Corke,
%      Springer 2011
%
% See also RandomPath, EKF.



% Properties (read/write)::
%   x               true vehicle state: x, y, theta (3x1)
%   V               odometry covariance (2x2)
%   odometry        distance moved in the last interval (2x1)
%   rdim            dimension of the robot (for drawing)
%   WheelBase       length of the vehicle (wheel base)
%   MaxSteeringAngle steering wheel limit
%   MaxSpeed        maximum vehicle speed
%   T               sample interval
%   verbose         verbosity
%   qhist          history of true vehicle state (Nx3)
%   driver          reference to the driver object
%   q0              initial state, restored on init()


% now apply a speed (0.2m/s) and steer angle (0.1rad) for 1 time step
%       odo = v.step(0.2, 0.1)
% where odo is the noisy odometry estimate, and the new true vehicle state
%       v
%
% We can add a driver object
%      v.addDriver( RandomPath(10) )
% which will move the vehicle within the region -10<x<10, -10<y<10 which we
% can see by
%      v.run(1000)
% which shows an animation of the vehicle moving for 1000 time steps
% between randomly selected wayoints.
%
% Notes::
% - Subclasses the MATLAB handle class which means that pass by reference semantics
%   apply.


% Copyright (C) 1993-2017, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for MATLAB (RTB).
%
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
%
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com

classdef BicycleVehicle < Vehicle

    properties
        % state
        WheelBase           % length of vehicle

        MaxSteeringAngle
        MaxAcceleration
    end

    properties (Access=private)
        Kinematics
        vprev
        steerprev        
    end

    methods

        function veh = BicycleVehicle(varargin)
            %BicycleVehicle.BicycleVehicle Vehicle object constructor
            %
            % V = BicycleVehicle(OPTIONS)  creates a BicycleVehicle object with the kinematics of a
            % bicycle (or Ackerman) vehicle.
            %
            % Options::
            % 'MaxSteeringAngle',M    Maximum steer angle [rad] (default 0.5)
            % 'MaxAcceleration',M    Maximum acceleration [m/s2] (default Inf)
            %--
            % 'Covariance',C       specify odometry covariance (2x2) (default 0)
            % 'MaxSpeed',S    Maximum speed (default 1m/s)
            % 'WheelBase',WheelBase           Wheel base (default 1m)
            % 'q0',q0         Initial state (default (0,0,0) )
            % 'dt',T          Time interval (default 0.1)
            % 'rdim',R        Robot size as fraction of plot window (default 0.2)
            % 'verbose'       Be verbose
            %
            % Notes::
            % - The covariance is used by a "hidden" random number generator within the class.
            % - Subclasses the MATLAB handle class which means that pass by reference semantics
            %   apply.
            %
            % Notes::
            % - Subclasses the MATLAB handle class which means that pass by reference semantics
            %   apply.

            veh = veh@Vehicle(varargin{:});

            veh.q = zeros(3,1);

            opt.WheelBase = 1;
            opt.MaxSteeringAngle = 0.5;
            opt.MaxAcceleration = Inf;

            veh = tb_optparse(opt, veh.options, veh);

            veh.vprev = 0;
            veh.q = veh.q0;

            veh.Kinematics = bicycleKinematics("WheelBase", opt.WheelBase, "VehicleSpeedRange", ...
                [-veh.MaxSpeed, veh.MaxSpeed], "MaxSteeringAngle", opt.MaxSteeringAngle);
        end

        function xnext = f(~, x, odo, w)
            %BicycleVehicle.f Predict next state based on odometry
            %
            % XN = V.f(X, ODO) is the predicted next state XN (1x3) based on current
            % state X (1x3) and odometry ODO (1x2) = [distance, heading_change].
            %
            % XN = V.f(X, ODO, W) as above but with odometry noise W.
            %
            % Notes::
            % - Supports vectorized operation where X and XN (Nx3).
            if nargin < 4
                w = [0 0];
            end

            dd = odo(1) + w(1); dth = odo(2) + w(2);

            % straightforward code:
            % thp = x(3) + dth;
            % xnext = zeros(1,3);
            % xnext(1) = x(1) + (dd + w(1))*cos(thp);
            % xnext(2) = x(2) + (dd + w(1))*sin(thp);
            % xnext(3) = x(3) + dth + w(2);
            %
            % vectorized code:

            thp = x(:,3) + dth;
            %xnext = x + [(dd+w(1))*cos(thp)  (dd+w(1))*sin(thp) ones(size(x,1),1)*dth+w(2)];
            xnext = x + [dd*cos(thp)  dd*sin(thp) ones(size(x,1),1)*dth];
        end

        function dx = derivative(veh, ~, x, u)
            %BicycleVehicle.derivative  Time derivative of state
            %
            % DX = V.derivative(T, X, U) is the time derivative of state (3x1) at the state
            % X (3x1) with input U (2x1).
            %
            % Notes::
            % - The parameter T is ignored but called from a continuous time integrator such as ode45 or
            %   Simulink.

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
            dx = veh.Kinematics.derivative(x, u);

%             % Reflect speed and steer angle limits in control input
%             u(1) = min(veh.MaxSpeed, max(u(1), -veh.MaxSpeed));
%             u(2) = min(veh.MaxSteeringAngle, max(u(2), -veh.MaxSteeringAngle));
        end

        function odo = update(veh, u)
            %BicycleVehicle.update Update the vehicle state
            %
            % ODO = V.update(U) is the true odometry value for
            % motion with U=[speed,steer].
            %
            % Notes::
            % - Appends new state to state history property qhist.
            % - Odometry is also saved as property odometry.

            % update the state
            dx = veh.dt * veh.derivative([], veh.q, u);
            veh.q = veh.q + dx;

            % compute and save the odometry
            odo = [ norm(dx(1:2)) dx(3) ];
            veh.odometry = odo;

            veh.qhist = [veh.qhist; veh.q'];   % maintain history
        end


        function J = Fx(~, x, odo)
            %BicycleVehicle.Fx  Jacobian df/dx
            %
            % J = V.Fx(X, ODO) is the Jacobian df/dx (3x3) at the state X, for
            % odometry input ODO (1x2) = [distance, heading_change].
            %
            % See also BicycleVehicle.f, Vehicle.Fv.
            dd = odo(1); dth = odo(2);
            theta = x(3);

            J = [
                1   0   -dd*sin(theta)
                0   1   dd*cos(theta)
                0   0   1
                ];
        end

        function J = Fv(~, x, ~)
            %BicycleVehicle.Fv  Jacobian df/dv
            %
            % J = V.Fv(X, ODO) is the Jacobian df/dv (3x2) at the state X, for
            % odometry input ODO (1x2) = [distance, heading_change].
            %
            % See also BicycleVehicle.F, Vehicle.Fx.
            thp = x(3);

            J = [
                cos(thp)    0
                sin(thp)    0
                0           1
                ];
        end

        function s = char(veh)
            %BicycleVehicle.char Convert to a string
            %
            % s = V.char() is a string showing vehicle parameters and state in
            % a compact human readable format.
            %
            % See also BicycleVehicle.display.

            ss = char@Vehicle(veh);

            s = 'BicycleVehicle object';
            s = char(s, sprintf('  WheelBase=%g, MaxSteeringAngle=%g, MaxAcceleration=%g', veh.WheelBase, veh.MaxSteeringAngle, veh.MaxAcceleration));
            s = char(s, ss);
        end
    end % method

end % classdef
