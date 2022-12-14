% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

classdef scamera
    properties
        name
        Tcam
    end


    methods
        function c = scamera
            c.Tcam = eye(4,4);
        end


        function f = plot(c, points, varargin)
            f = c.project(points, varargin{:});
            plot(f(2,:), f(1,:), 'o');
            xlabel('phi (rad)');
            ylabel('theta (rad)');
            grid on
            axis([-pi pi 0 pi]);
        end

        function f = project(c, P, Tcam)
            if nargin < 3
                Tcam = c.Tcam;
            end
            P = transformp(inv(Tcam), P);

            R = sqrt( sum(P.^2) );
            x = P(1,:) ./ R;
            y = P(2,:) ./ R;
            z = P(3,:) ./ R;
            r = sqrt( x.^2 + y.^2);
            theta = atan2(r, z);
            phi = atan2(y, x);
            f = [theta; phi];
        end
    end
end
