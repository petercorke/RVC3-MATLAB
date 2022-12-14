%Sensor Sensor superclass
%
% An abstract superclass to represent robot navigation sensors.
%
% Methods::
%   plot        plot a line from robot to map feature
%   display     print the parameters in human readable form
%   char        convert to string
%
% Properties::
% robot   The Vehicle object on which the sensor is mounted
% map     The PointMap object representing the landmarks around the robot
%
% Reference::
%
%   Robotics, Vision & Control,
%   Peter Corke,
%   Springer 2011
%
% See also RangeBearingSensor, EKF, Vehicle, LandmarkMap.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

classdef (Abstract) Sensor < handle
    % TODO, pose option, wrt vehicle

    properties
        robot
        map
        
        verbose
        
        ls
        animate     % animate sensor measurements
        interval    % measurement return subsample factor
        fail
        delay
        
        
    end

    methods

        function s = Sensor(robot, map, varargin)
        %Sensor.Sensor Sensor object constructor
        %
        % S = Sensor(VEHICLE, MAP, OPTIONS) is a sensor mounted on a vehicle
        % described by the Vehicle subclass object VEHICLE and observing landmarks
        % in a map described by the LandmarkMap class object MAP.
        %
        % Options::
        % 'animate'    animate the action of the laser scanner
        % 'ls',LS      laser scan lines drawn with style ls (default 'r-')
        % 'skip', I    return a valid reading on every I'th call
        % 'fail',T     sensor simulates failure between timesteps T=[TMIN,TMAX]
        %
        % Notes::
        % - Animation shows a ray from the vehicle position to the selected
        %   landmark.
        %
        
            opt.skip = 1;
            opt.animate = false;
            opt.fail =  [];
            opt.ls = 'r-';
            opt.delay = 0.1;

            [opt,args] = tb_optparse(opt, varargin);
            
            s.interval = opt.skip;
            s.animate = opt.animate;
            
            s.robot = robot;
            s.map = map;
            s.verbose = false;
            s.fail = opt.fail;
            s.ls = opt.ls;
        end
        
        function plot(s, jf)
        %Sensor.plot Plot sensor reading
        %
        % S.plot(J) draws a line from the robot to the J'th map feature.
        %
        % Notes::
        % - The line is drawn using the linestyle given by the property ls
        % - There is a delay given by the property delay

            if isempty(s.ls)
                return;
            end
            
            h = findobj(gca, 'tag', 'sensor');
            if isempty(h)
                % no sensor line, create one
                h = plot(0, 0, s.ls, 'tag', 'sensor');
            end
            
            % there is a sensor line animate it
            
            if jf == 0
                set(h, 'Visible', 'off');
            else
                xi = s.map.map(:,jf);
                set(h, 'Visible', 'on', 'XData', [s.robot.q(1), xi(1)], 'YData', [s.robot.q(2), xi(2)]);
            end
            pause(s.delay);

            drawnow
        end

        function display(s)
            %Sensor.display Display status of sensor object
            %
            % S.display() displays the state of the sensor object in
            % human-readable form.
            %
            % Notes::
            % - This method is invoked implicitly at the command line when the result
            %   of an expression is a Sensor object and the command has no trailing
            %   semicolon.
            %
            % See also Sensor.char.
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            disp( char(s) );
        end % display()

        function str = char(s)
            %Sensor.char Convert sensor parameters to a string
            %
            % s = S.char() is a string showing sensor parameters in
            % a compact human readable format.
            str = [class(s) ' sensor class:'];
            str = char(str, char(s.map));
        end

    end % method
end % classdef
