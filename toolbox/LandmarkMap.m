%LandmarkMap Map of planar point landmarks
%
% A LandmarkMap object represents a square 2D environment with a number of
% landmark landmark points.
%
% Methods::
%   plot      Plot the landmark map
%   landmark   Return a specified map landmark
%   display   Display map parameters in human readable form
%   char      Convert map parameters to human readable string
%
% Properties::
%   map         Matrix of map landmark coordinates 2xN
%   dim         The dimensions of the map region x,y in [-dim,dim]
%   nlandmarks   The number of map landmarks N
%
% Examples::
%
% To create a map for an area where X and Y are in the range -10 to +10
% metres and with 50 random landmark points
%        map = LandmarkMap(50, 10);
% which can be displayed by
%        map.plot();
%
% Reference::
%
%   Robotics, Vision & Control, Chap 6,
%   Peter Corke,
%   Springer 2011
%
% See also RangeBearingSensor, EKF.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

classdef LandmarkMap < handle
    % TODO:
    % add a name property, show in char()

    properties
        map    % map landmarks
        dim         % map dimension
        nlandmarks   % number of landmarks in map

        verbose
    end

    methods

        % constructor
        function map = LandmarkMap(nlandmarks, varargin)
            %LandmarkMap.LandmarkMap Create a map of point landmark landmarks
            %
            % M = LandmarkMap(N, DIM, OPTIONS) is a LandmarkMap object that represents N random point landmarks
            % in a planar region bounded by +/-DIM in the x- and y-directions.
            %
            % Options::
            % 'verbose'    Be verbose


            %% TODO: dim can be a 4-vector

            opt = [];
            [opt,args] = tb_optparse(opt, varargin);
            map.verbose = opt.verbose;

            if ~isempty(args) && isnumeric(args{1})
                dim = args{1};
            else
                dim = 10;
            end
            map.dim = dim;
            map.nlandmarks = nlandmarks;
            map.map = dim * (2*rand(2, nlandmarks)-1);
            map.verbose = false;
        end

        function f = landmark(map, k)
            %LandmarkMap.landmark Get landmarks from map
            %
            % F = M.landmark(K) is the coordinate (2x1) of the K'th landmark (landmark).
            f = map.map(:,k);
        end

        function plot(map, varargin)
            %LandmarkMap.plot Plot the map
            %
            % M.plot() plots the landmark map in the current figure, as a square
            % region with dimensions given by the M.dim property.  Each landmark
            % is marked by a black diamond.
            %
            % M.plot(LS) as above, but the arguments LS
            % are passed to plot and override the default marker style.
            %
            % Notes::
            % - The plot is left with HOLD ON.
            clf
            d = map.dim;
            axis equal
            axis([-d d -d d]);
            xlabel('x');
            ylabel('y');

            if nargin == 1
                args = {'kh'};
            else
                args = varargin;
            end
            h = plot(map.map(1,:)', map.map(2,:)', args{:});
            set(h, 'Tag', 'map');
            grid on
            hold on
        end

        function show(map, varargin)
            %map.SHOW Show the landmark map
            %
            % Notes::
            % - Deprecated, use plot method.
            warning('show method is deprecated, use plot() instead');
            map.plot(varargin{:});
        end

        function verbosity(map, v)
            %map.verbosity Set verbosity
            %
            % M.verbosity(V) set verbosity to V, where 0 is silent and greater
            % values display more information.
            map.verbose = v;
        end

        function disp(map)
            %map.display Display map parameters
            %
            % M.display() displays map parameters in a compact
            % human readable form.
            %
            % Notes::
            % - This method is invoked implicitly at the command line when the result
            %   of an expression is a LandmarkMap object and the command has no trailing
            %   semicolon.
            %
            % See also map.char.
            loose = strcmp( get(0, 'FormatSpacing'), 'loose'); %#ok<GETFSP> 
            if loose
                disp(' ');
            end
%             disp([inputname(1), ' = '])
            disp( char(map) );
        end % display()

        function s = char(map)
            %map.char Convert map parameters to a string
            %
            % s = M.char() is a string showing map parameters in
            % a compact human readable format.
            s = 'LandmarkMap object';
            s = char(s, sprintf('  %d landmarks', map.nlandmarks));
            s = char(s, sprintf('  dimension %.1f', map.dim));
        end

    end % method

end % classdef
