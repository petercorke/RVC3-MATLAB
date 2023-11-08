%LandmarkSensor Range and bearing sensor class
%
% A concrete subclass of the Sensor class that implements a range and
% bearing angle sensor that provides robot-centric measurements of landmark
% points in the world. To enable this it holds a references to a map of the
% world (LandmarkMap object) and a robot (Vehicle subclass object) that
% moves in SE(2).
%
% The sensor observes landmarks within its angular field of view between
% the minimum and maximum range.
%
% Methods::
%
% reading   range/bearing observation of random landmark
% h         range/bearing observation of specific landmark
% Hx        Jacobian matrix with respect to vehicle pose dh/dx
% Hp        Jacobian matrix with respect to landmark position dh/dp
% Hw        Jacobian matrix with respect to noise dh/dw
%-
% g         feature position given vehicle pose and observation
% Gx        Jacobian matrix with respect to vehicle pose dg/dx
% Gz        Jacobian matrix with respect to observation dg/dz
%
% Properties (read/write)::
% W            measurement covariance matrix (2x2)
% interval     valid measurements returned every interval'th call to reading()
% landmarklog  time history of observed landmarks
%
% Reference::
%
%   Robotics, Vision & Control, Chap 6,
%   Peter Corke,
%   Springer 2011
%
% See also Sensor, Vehicle, LandmarkMap, EKF.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

classdef LandmarkSensor < Sensor

    properties
        W           % measurment covariance
        r_range     % range limits
        theta_range % angle limits

        randstream  % random stream just for Sensors

        landmarklog  % time history of observed landmarks
    end

    properties (SetAccess = private)
        count       % number of reading()s
    end

    methods

        function s = LandmarkSensor(robot, map, varargin)
            %LandmarkSensor.LandmarkSensor Range and bearing sensor constructor
            %
            % S = LandmarkSensor(VEHICLE, MAP, OPTIONS) is an object
            % representing a range and bearing angle sensor mounted on the Vehicle
            % subclass object VEHICLE and observing an environment of known landmarks
            % represented by the LandmarkMap object MAP.  The sensor covariance is W
            % (2x2) representing range and bearing covariance.
            %
            % The sensor has specified angular field of view and minimum and maximum
            % range.
            %
            % Options::
            % 'covar',W               covariance matrix (2x2)
            % 'range',xmax            maximum range of sensor
            % 'range',[xmin xmax]     minimum and maximum range of sensor
            % 'angle',TH              angular field of view, from -TH to +TH
            % 'angle',[THMIN THMAX]   detection for angles betwen THMIN
            %                         and THMAX
            % 'skip',K                return a valid reading on every K'th call
            % 'fail',[TMIN TMAX]      sensor simulates failure between
            %                         timesteps TMIN and TMAX
            % 'animate'               animate sensor readings
            %
            % See also options for Sensor constructor.
            %
            % See also LandmarkSensor.reading, Sensor.Sensor, Vehicle, LandmarkMap, EKF.


            % call the superclass constructor
            s = s@Sensor(robot, map, varargin{:});

            s.randstream = RandStream.create('mt19937ar');

            opt.range = [];
            opt.angle = [];
            opt.covar = zeros(2,2);

            opt = tb_optparse(opt, varargin);

            s.W = opt.covar;
            if ~isempty(opt.range)
                if length(opt.range) == 1
                    s.r_range = [0 opt.range];
                elseif length(opt.range) == 2
                    s.r_range = opt.range;
                end
            end
            if ~isempty(opt.angle)
                if length(opt.angle) == 1
                    s.theta_range = [-opt.angle opt.angle];
                elseif length(opt.angle) == 2
                    s.theta_range = opt.angle;
                end
            end

            s.count = 0;
            s.verbose = opt.verbose;
        end

        function init(s)
            s.landmarklog = [];
        end

        function k = selectFeature(s)
            k = s.randstream.randi(s.map.nlandmarks);
        end

        function [z,jf] = reading(s)
            %LandmarkSensor.reading Choose landmark and return observation
            %
            % [Z,K] = S.reading() is an observation of a random visible landmark where
            % Z=[R,THETA] is the range and bearing with additive Gaussian noise of
            % covariance W (property W). K is the index of the map feature that was
            % observed.
            %
            % The landmark is chosen randomly from the set of all visible landmarks,
            % those within the angular field of view and range limits.  If no valid
            % measurement, ie. no features within range, interval subsampling enabled
            % or simulated failure the return is Z=[] and K=0.
            %
            % Notes::
            % - Noise with covariance W (property W) is added to each row of Z.
            % - If 'animate' option set then show a line from the vehicle to the
            %   landmark
            % - If 'animate' option set and the angular and distance limits are set
            %   then display that region as a shaded polygon.
            % - Implements sensor failure and subsampling if specified to constructor.
            %
            % See also LandmarkSensor.h.

            % TODO probably should return K=0 to indicated invalid

            % model a sensor that emits readings every interval samples
            s.count = s.count + 1;

            % check conditions for NOT returning a value
            z = [];
            jf = 0;
            % sample interval
            if mod(s.count, s.interval) ~= 0
                return;
            end
            % simulated failure
            if ~isempty(s.fail) && (s.count >= s.fail(1)) && (s.count <= s.fail(2))
                return;
            end

            % create a polygon to indicate the active sensing area based on range+angle limits
            if s.animate && ~isempty(s.theta_range) && ~isempty(s.r_range)
                h = findobj(gca, 'tag', 'sensor-area');
                if isempty(h)

                    th=linspace(s.theta_range(1), s.theta_range(2), 20);
                    x = s.r_range(2) * cos(th);
                    y = s.r_range(2) * sin(th);
                    if s.r_range(1) > 0
                        th = flip(th);
                        x = [x s.r_range(1) * cos(th)];
                        y = [y s.r_range(1) * sin(th)];
                    else
                        x = [x 0];
                        y = [y 0];
                    end
                    % no sensor zone, create one
                    plotpoly([x; y], 'fillcolor', 'r', 'alpha', 0.1, 'edgecolor', 'none', 'animate', 'tag', 'sensor-area');
                else
                    %hg = get(h, 'Parent');
                    plotpoly(h, s.robot.q);

                end
            end

            if ~isempty(s.r_range)  || ~isempty(s.theta_range)
                % if range and bearing angle limits are in place look for
                % any landmarks that match criteria

                % get range/bearing to all landmarks, one per row
                z = s.h(s.robot.q);
                jf = 1:size(s.map.map,2);

                if ~isempty(s.r_range)
                    % find all within range
                    k = find( z(:,1) >= s.r_range(1) & z(:,1) <= s.r_range(2) );
                    z = z(k,:);
                    jf = jf(k);
                end
                if ~isempty(s.theta_range)
                    % find all within angular range as well
                    k = find( z(:,2) >= s.theta_range(1) & z(:,2) <= s.theta_range(2) );
                    z = z(k,:);
                    jf = jf(k);
                end

                % deal with cases for 0 or > 1 features found
                if isempty(z)
                    % no landmarks found
                    jf = 0;
                elseif length(k) >= 1
                    % more than 1 in range, pick a random one
                    i = s.randstream.randi(length(k));
                    z = z(i,:);
                    jf = jf(i);
                end

            else
                % randomly choose the feature
                jf = s.selectFeature();

                % compute the range and bearing from robot to feature
                z = s.h(s.robot.q, jf);
            end

            if s.verbose
                if isempty(z)
                    fprintf('Sensor:: no features\n');
                else
                    fprintf('Sensor:: feature %d: %.1f %.1f\n', jf, z);
                end
            end
            if s.animate
                s.plot(jf);
            end

            z = z';

            % add the reading to the landmark log
            s.landmarklog = [s.landmarklog jf];
        end


        function z = h(s, xv, jf)
            %LandmarkSensor.h Landmark range and bearing
            %
            % Z = S.h(X, K) is a sensor observation (1x2), range and bearing, from vehicle at
            % pose X (1x3) to the K'th landmark.
            %
            % Z = S.h(X, P) as above but compute range and bearing to a landmark at coordinate P.
            %
            % Z = s.h(X) as above but computes range and bearing to all
            % map features.  Z has one row per landmark.
            %
            % Notes::
            % - Noise with covariance W (propertyW) is added to each row of Z.
            % - Supports vectorized operation where XV (Nx3) and Z (Nx2).
            % - The landmark is assumed visible, field of view and range liits are not
            %   applied.
            %
            % See also LandmarkSensor.reading, LandmarkSensor.Hx, LandmarkSensor.Hw, LandmarkSensor.Hp.

            % get the landmarks, one per row
            if nargin < 3
                % s.h(XV)
                xlm = s.map.map';
            elseif length(jf) == 1
                % s.h(XV, JF)
                xlm = s.map.map(:,jf)';
            else
                % s.h(XV, XF)
                xlm = jf(:)';
            end

            % Straightforward code:
            %
            % dx = xf(1) - xv(1); dy = xf(2) - xv(2);
            %
            % z = zeros(2,1);
            % z(1) = sqrt(dx^2 + dy^2);       % range measurement
            % z(2) = atan2(dy, dx) - xv(3);   % bearing measurement
            %
            % Vectorized code:

            % compute range and bearing
            dx = xlm(:,1) - xv(:,1); dy = xlm(:,2) - xv(:,2);
            xv3 = xv(:,3);
            if length(xv3) ~= size(dy,1)
                xv3 = repmat(xv3, size(dy,1), 1);
            end
            z = [sqrt(dx.^2 + dy.^2) angdiff(xv3,atan2(dy, dx)) ];   % range & bearing measurement

            % add noise with covariance W
            z = z + s.randstream.randn(size(z)) * sqrtm(s.W) ;
        end

        function J = Hx(s, xv, jf)
            %LandmarkSensor.Hx Jacobian dh/dx
            %
            % J = S.Hx(X, K) returns the Jacobian dh/dx (2x3) at the vehicle
            % state X (3x1) for map landmark K.
            %
            % J = S.Hx(X, P) as above but for a landmark at coordinate P.
            %
            % See also LandmarkSensor.h.
            if length(jf) == 1
                xf = s.map.map(:,jf);
            else
                xf = jf;
            end
            if isempty(xv)
                xv = s.robot.q;
            end
            Delta = xf - xv(1:2)';
            r = norm(Delta);
            J = [
                -Delta(1)/r,    -Delta(2)/r,        0
                Delta(2)/(r^2),  -Delta(1)/(r^2),   -1
                ];
        end

        function J = Hp(s, xv, jf)
            %LandmarkSensor.Hp Jacobian dh/dp
            %
            % J = S.Hp(X, K) is the Jacobian dh/dp (2x2) at the vehicle
            % state X (3x1) for map landmark K.
            %
            % J = S.Hp(X, P) as above but for a landmark at coordinate P (1x2).
            %
            % See also LandmarkSensor.h.
            if length(jf) == 1
                xf = s.map.map(:,jf);
            else
                xf = jf;
            end
            Delta = xf - xv(1:2)';
            r = norm(Delta);
            J = [
                Delta(1)/r,         Delta(2)/r
                -Delta(2)/(r^2),    Delta(1)/(r^2)
                ];
        end

        function J = Hw(~, ~, ~)
            %LandmarkSensor.Hx Jacobian dh/dw
            %
            % J = S.Hw(X, K) is the Jacobian dh/dw (2x2) at the vehicle
            % state X (3x1) for map landmark K.
            %
            % See also LandmarkSensor.h.
            J = eye(2,2);
        end

        function xf = g(~, xv, z)
            %LandmarkSensor.g Compute landmark location
            %
            % P = S.g(X, Z) is the world coordinate (2x1) of a feature given
            % the observation Z (1x2) from a vehicle state with X (3x1).
            %
            % See also LandmarkSensor.Gx, LandmarkSensor.Gz.

            range = z(1);
            bearing = z(2) + xv(3); % bearing angle in vehicle frame

            xf = [xv(1)+range*cos(bearing); xv(2)+range*sin(bearing)];
        end

        function J = Gx(~, xv, z)
            %LandmarkSensor.Gxv Jacobian dg/dx
            %
            % J = S.Gx(X, Z) is the Jacobian dg/dx (2x3) at the vehicle state X (3x1) for
            % sensor observation Z (2x1).
            %
            % See also LandmarkSensor.g.
            theta = xv(3);
            r = z(1);
            bearing = z(2);
            J = [
                1,   0,   -r*sin(theta + bearing);
                0,   1,    r*cos(theta + bearing)
                ];
        end


        function J = Gz(~ , xv, z)
            %LandmarkSensor.Gz Jacobian dg/dz
            %
            % J = S.Gz(X, Z) is the Jacobian dg/dz (2x2) at the vehicle state X (3x1) for
            % sensor observation Z (2x1).
            %
            % See also LandmarkSensor.g.
            theta = xv(3);
            r = z(1);
            bearing = z(2);
            J = [
                cos(theta + bearing),   -r*sin(theta + bearing);
                sin(theta + bearing),    r*cos(theta + bearing)
                ];
        end

        function str = char(s)
            str = char@Sensor(s);
            str = char(str, ['W = ', mat2str(s.W, 3)]);

            str = char(str, sprintf('interval %d samples', s.interval) );
            if ~isempty(s.r_range)
                str = char(str, sprintf('range: %g to %g', s.r_range) );
            end
            if ~isempty(s.theta_range)
                str = char(str, sprintf('angle: %g to %g', s.theta_range) );
            end
        end

    end % method
end % classdef
