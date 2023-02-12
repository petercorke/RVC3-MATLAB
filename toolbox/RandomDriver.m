%RandomDriver Vehicle driver class
%
% Create a "driver" object capable of steering a Vehicle subclass object through random
% waypoints within a rectangular region and at constant Speed.
%
% The driver object is connected to a Vehicle object by the latter's
% addDriver() method.  The driver's demand() method is invoked on every
% call to the Vehicle's step() method.
%
% Methods::
%  init       reset the random number generator
%  demand     Speed and steer angle to next waypoint
%  display    display the state and parameters in human readable form
%  char       convert to string
%plot
% Properties::
%  Goal          current Goal/waypoint coordinate
%  Vehicle           the Vehicle object being controlled
%  dim           dimensions of the work space (2x1) [m]
%  Speed         Speed of travel [m/s]
%  DistTresh       proximity to waypoint at which next is chosen [m]
%
% Example::
%
%    veh = Bicycle(V);
%    veh.addDriver( RandomDriver(20, 2) );
%
% Notes::
% - It is possible in some cases for the vehicle to move outside the desired
%   region, for instance if moving to a waypoint near the edge, the limited
%   turning circle may cause the vehicle to temporarily move outside.
% - The vehicle chooses a new waypoint when it is closer than property
%   closeenough to the current waypoint.
% - Uses its own random number stream so as to not influence the performance
%   of other randomized algorithms such as path planning.
%
% Reference::
%
%   Robotics, Vision & Control, Chap 6,
%   Peter Corke,
%   Springer 2011
%
% See also Vehicle, Bicycle, Unicycle.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

% TODO
%  should be a subclass of VehicleDriver
%  Vehicle should be an abstract superclass
%  dim should be checked, can be a 4-vector like axis()

classdef RandomDriver < handle
    properties
        Goal        % current Goal
        Vehicle         % the vehicle we are driving
        XLim
        YLim
        Speed       % Speed of travel
        DistTresh     % proximity to Goal before choosing new one
        show
        verbose
    end

    properties (Access = private)
        h_goal      % graphics handle for Goal
        d_prev
        randstream  % random stream just for Sensors
    end

    methods

        function driver = RandomDriver(dim, varargin)
            %RandomDriver.RandomDriver Create a driver object
            %
            % D = RandomDriver(D, OPTIONS) returns a "driver" object capable of driving
            % a Vehicle subclass object through random waypoints.  The waypoints are positioned
            % inside a rectangular region of dimension D interpreted as:
            %      - D scalar; X: -D to +D, Y: -D to +D
            %      - D (1x2); X: -D(1) to +D(1), Y: -D(2) to +D(2)
            %      - D (1x4); X: D(1) to D(2), Y: D(3) to D(4)
            %
            % Options::
            % 'Speed',S      Speed along path (default 1m/s).
            % 'DistTresh',D    Distance from Goal at which next Goal is chosen.
            %
            % See also Vehicle.

            % TODO options to specify region, maybe accept a Map object?
            % dim can be a 4-vector

            switch length(dim)
                case 1
                    driver.XLim = [-dim dim];
                    driver.YLim = [-dim dim];
                case 2
                    driver.XLim = [-dim(1) dim(1)];
                    driver.YLim = [-dim(2) dim(2)];
                case 4
                    driver.XLim = [dim(1) dim(2)];
                    driver.YLim = [dim(3) dim(4)];
                otherwise
                    error('bad dimension specified');
            end

            opt.Speed = 1;
            opt.DistTresh = 0.05 * diff(driver.XLim) / 2;
            opt.show = 0;

            driver = tb_optparse(opt, varargin, driver);

            driver.d_prev = Inf;
            driver.randstream = RandStream.create('mt19937ar');
            driver.Goal = double.empty(0,2);
        end

        function init(driver)
            %RandomDriver.init Reset random number generator
            %
            % R.init() resets the random number generator used to create the waypoints.
            % This enables the sequence of random waypoints to be repeated.
            %
            % Notes::
            % - Called by Vehicle.run.
            %
            % See also RANDSTREAM.
            driver.Goal = double.empty(0,2);
            driver.randstream.reset();
            delete(driver.h_goal);   % delete the Goal
            driver.h_goal = [];
        end

        % called by Vehicle superclass
        function plot(driver)
            clf
            axis([driver.XLim driver.YLim]);
            hold on
            xlabel('x');
            ylabel('y');
        end

        % private method, invoked from demand() to compute a new waypoint
        function setgoal(driver)

            % choose a uniform random Goal within inner 80% of driving area
            while true
                r = driver.randstream.rand()*0.8+0.1;
                gx = driver.XLim * [r; 1-r];
                r = driver.randstream.rand()*0.8+0.1;
                gy = driver.YLim * [r; 1-r];
                driver.Goal = [gx; gy];
                %driver.Goal = 0.8 * driver.dim * (r - 0.5)*2;
                if norm(driver.Goal - driver.Vehicle.q(1:2)) > 2*driver.DistTresh
                    break;
                end
            end

            if driver.verbose
                fprintf('set Goal: (%.1f %.1f)\n', driver.Goal);
            end
            if driver.show && isempty(driver.h_goal)
                driver.h_goal = plot(driver.Goal(1), driver.Goal(2), 'rd', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
            else
                set(driver.h_goal, 'Xdata', driver.Goal(1), 'Ydata', driver.Goal(2));
            end
        end

        function [speed, steer] = demand(driver)
            %RandomDriver.demand Compute Speed and heading to waypoint
            %
            % [SPEED,STEER] = R.demand() is the Speed and steer angle to
            % drive the vehicle toward the next waypoint.  When the vehicle is
            % within R.dtresh a new waypoint is chosen.
            %
            % See also Vehicle.
            if isempty(driver.Goal)
                driver.setgoal();
            end

            speed = driver.Speed;

            goal_heading = atan2(driver.Goal(2)-driver.Vehicle.q(2), ...
                driver.Goal(1)-driver.Vehicle.q(1));
            d_heading = angdiff(driver.Vehicle.q(3), goal_heading);

            steer = d_heading;

            % if nearly at Goal point, choose the next one
            d = norm(driver.Vehicle.q(1:2)' - driver.Goal);
            if d < driver.DistTresh
                driver.setgoal();
            elseif d > 2*driver.d_prev
                driver.setgoal();
            end
            driver.d_prev = d;
        end

        function disp(driver)
            %RandomDriver.disp Display driver parameters and state
            %
            % R.display() displays driver parameters and state in compact
            % human readable form.
            %
            % Notes::
            % - This method is invoked implicitly at the command line when the result
            %   of an expression is a RandomDriver object and the command has no trailing
            %   semicolon.
            %
            % See also RandomDriver.char.
            loose = strcmp( get(0, 'FormatSpacing'), 'loose'); %#ok<GETFSP>
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            disp( char(driver) );
        end % display()

        function s = char(driver)
            %RandomDriver.char Convert to string
            %
            % s = R.char() is a string showing driver parameters and state in in
            % a compact human readable format.
            s = 'RandomDriver driver object';
            if isempty(driver.Goal)
                goal = [nan, nan];
            else
                goal = driver.Goal;
            end
            s = char(s, sprintf('  Current Goal=(%g,%g), XLim [%g,%g]; YLim [%g,%g], DistTresh %g', ...
                goal, driver.XLim, driver.YLim, driver.DistTresh));
        end

    end % methods
end % classdef
