%DistanceTransformPlanner Distance transform navigation class
%
% A concrete subclass of the abstract Navigation class that implements the distance 
% transform navigation algorithm which computes minimum distance paths.
%
% Methods::
%  DistanceTransformPlanner       Constructor
%  plan         Compute the cost map given a goal and map
%  query        Find a path
%  plot         Display the distance function and obstacle map
%  plot3d       Display the distance function as a surface
%  display      Print the parameters in human readable form
%  char         Convert to string
%
% Properties (read only)::
%  distancemap   Distance from each point to the goal.
%  metric        The distance metric, can be 'euclidean' (default) or 'manhattan'
%
% Example::
%
%        load map1           % load map
%        goal = [50,30];     % goal point
%        start = [20, 10];   % start point
%        dx = DistanceTransformPlanner(map);   % create navigation object
%        dx.plan(goal)       % create plan for specified goal
%        dx.query(start)     % animate path from this start location
%
% Notes::
% - Obstacles are represented by NaN in the distancemap.
% - The value of each element in the distancemap is the shortest distance from the 
%   corresponding point in the map to the current goal.
%
% References::
% -  Robotics, Vision & Control, Sec 5.2.1,
%    Peter Corke, Springer, 2011.
%
% See also Navigation, Dstar, PRM, distancexform.



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

classdef DistanceTransformPlanner < Navigation

    properties
        metric;     % distance metric
        distancemap;   % distance transform results
    end

    methods

        function dx = DistanceTransformPlanner(world, varargin)
            %DistanceTransformPlanner.DistanceTransformPlanner Distance transform constructor
            %
            % DX = DistanceTransformPlanner(MAP, OPTIONS) is a distance transform navigation object,
            % and MAP is an occupancy grid, a representation of a planar
            % world as a matrix whose elements are 0 (free space) or 1
            % (occupied).
            %
            % Options::
            % 'goal',G      Specify the goal point (2x1)
            % 'metric',M    Specify the distance metric as 'euclidean' (default)
            %               or 'manhattan'.
            % 'inflate',K   Inflate all obstacles by K cells.
            %
            % Other options are supported by the Navigation superclass.
            %
            % See also Navigation.Navigation.

            % TODO NEEDS PROPER ARG HANDLER

            opt.metric = {'euclidean', 'manhattan', 'cityblock'};
            [opt, args] = tb_optparse(opt, varargin);

            % invoke the superclass constructor
            dx = dx@Navigation(world, args{:});

            dx.metric = opt.metric;
            dx.verbose = opt.verbose;

        end

        function s = char(dx)
            %DistanceTransformPlanner.char Convert to string
            %
            % DX.char() is a string representing the state of the object in 
            % human-readable form.
            %
            % See also DistanceTransformPlanner.display, Navigation.char
 
            % most of the work is done by the superclass
            s = char@Navigation(dx);

            % DistanceTransformPlanner specific stuff
            s = char(s, sprintf('  distance metric: %s', dx.metric));
            if ~isempty(dx.distancemap)
                s = char(s, sprintf('  distancemap: computed:'));
            else
                s = char(s, sprintf('  distancemap: empty:'));
            end
        end

        % invoked by superclass on a change of goal, mark the distancemap
        % as invalid
        function goal_change(dx, ~)

            dx.distancemap = [];
            if dx.verbose
                disp('Goal changed -> distancemap cleared');
            end
        end
  
        function plan(dx, varargin)
            %DistanceTransformPlanner.plan Plan path to goal
            %
            % DX.plan(GOAL) plans a path to the goal given to the constructor,
            % updates the internal distancemap where the value of each element is the 
            % minimum distance from the corresponding point to the goal.
            %
            % Notes::
            % - This may take many seconds.
            %
            % See also Navigation.path.

            if ~isempty(varargin) && isvec(varargin{1},2)
                dx.setgoal(varargin{1});
            end
            
            % check the goal point is sane
            assert(~isempty(dx.goal), 'RTB:DistanceTransformPlanner:plan', 'no goal specified here or in constructor');
            occgrid = double(dx.occgridnav);
            assert(occgrid(dx.goal(2), dx.goal(1)) == 0, 'RTB:distancexform:badarg', 'goal inside obstacle')           
                
            % solve using IPT
            switch dx.metric
                case {'cityblock', 'manhattan'}
                    ipt_metric = 'cityblock';
                case 'euclidean'
                    ipt_metric = 'quasi-euclidean';
            end
            dx.distancemap = double( bwdistgeodesic(occgrid==0, dx.goal(1), dx.goal(2), ipt_metric) );
            
        end

        function plot(dx, varargin)
            %DistanceTransformPlanner.plot Visualize navigation environment
            %
            % DX.plot(OPTIONS) displays the occupancy grid and the goal distance
            % in a new figure.  The goal distance is shown by intensity which
            % increases with distance from the goal.  Obstacles are overlaid
            % and shown in red.
            %
            % DX.plot(P, OPTIONS) as above but also overlays a path given by the set
            % of points P (Mx2).
            %
            % Notes::
            % - See Navigation.plot for options.
            %
            % See also Navigation.plot.

            plot@Navigation(dx, varargin{:}, 'distance', dx.distancemap);

        end

        function n = next(dx, robot)
            if isempty(dx.distancemap)
                error('No distancemap computed, you need to plan');
            end
            
            % list of all possible directions to move from current cell
            directions = [
                -1 -1
                0 -1
                1 -1
                -1 0
                0 0
                1 0
                -1 1
                0 1
                1 1];

            x = robot(1); y = robot(2);
            
            % find the neighbouring cell that has the smallest distance
            mindist = Inf;
            mindir = [];
            for d=directions'
                % use exceptions to catch attempt to move outside the map
                try
                    if dx.distancemap(y+d(1), x+d(2)) < mindist
                        mindir = d;
                        mindist = dx.distancemap(y+d(1), x+d(2));
                    end
                catch
                end
            end

            x = x + mindir(2);
            y = y + mindir(1);

            if all([x;y] == dx.goal)
                n = [];     % indicate we are at the goal
            else
                n = [x; y];  % else return the next closest point to the goal
            end
        end % next

        function plot3d(dx, p, varargin)
            %DistanceTransformPlanner.plot3d 3D costmap view
            %
            % DX.plot3d() displays the distance function as a 3D surface with
            % distance from goal as the vertical axis.  Obstacles are "cut out"
            % from the surface.
            %
            % DX.plot3d(P) as above but also overlays a path given by the set
            % of points P (Mx2).
            %
            % DX.plot3d(P, LS) as above but plot the line with the MATLAB linestyle LS.
            %
            % See also Navigation.plot.

            opt.pathmarker =  {};
            opt.startmarker = {};
            opt.goalmarker =  {};
            opt.goal = true;
            opt.start = true;
            
            pathmarker =  {"go", "MarkerSize", 8, "MarkerEdgeColor", "black", ...
                "MarkerFaceColor", "green", "LineWidth", 2};
            startmarker = {"bo", "MarkerFaceColor", "w", "MarkerEdgeColor", "k", ...
                "MarkerSize", 16, "LineWidth", 1};
            goalmarker =  {"bp", "MarkerFaceColor", "w", "MarkerEdgeColor", "k", ...
                "MarkerSize", 22, "LineWidth", 1};
            opt = tb_optparse(opt, varargin);

            surf(dx.distancemap);
            colormap("gray")
            shading interp

            if nargin > 1
                % plot path if provided
                k = sub2ind(size(dx.distancemap), p(:,2), p(:,1));
                height = dx.distancemap(k);
                hold on
                plot3(p(:,1), p(:,2), height, pathmarker{:}, ...
                    opt.pathmarker{:}, "Tag", "path")
                if opt.goal && ~isempty(dx.goal)
                    plot3(dx.goal(1), dx.goal(2), dx.distancemap(dx.goal(2), dx.goal(1)), ...
                        goalmarker{:}, opt.goalmarker{:}, 'Tag', 'goal');
                end
                if opt.start && ~isempty(dx.start)
                    plot3(dx.start(1), dx.start(2), dx.distancemap(dx.start(2), dx.start(1)) + 0.1, ...
                        startmarker{:}, opt.startmarker{:}, 'Tag', 'start');
                end
                hold off               
            end

            xlabel x
            ylabel y
            zlabel("Distance from goal")
        end
    end % methods
end % classdef
