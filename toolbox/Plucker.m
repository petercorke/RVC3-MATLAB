%Plucker Create 3D line using Plucker coordinates
%
% Class to represent a 3D line using Plucker coordinates.
%
% P = Plucker(P1, P2) creates a Plucker object that represents
% the line joining the 3D points P1 (1x3) and P2 (1x3). The direction
% is from P2 to P1.
%
% P = Plucker(X) creates a Plucker object from X (1x6) = [W,V] where
% W (3x1) is the line direction and V (3x1) is the moment.
%
% P = Plucker(L) creates a copy of the Plucker object L.
%
% Methods:
% closest          - closest point on line
% commonperp       - common perpendicular for two lines
% contains         - test if point is on line
% distance         - minimum distance between two lines
% intersects       - intersection point for two lines
% intersect_plane  - intersection points with a plane
% intersect_volume - intersection points with a volume
% pp               - principal point
% ppd              - principal point distance from origin
% point            - generate point on line
%
% Conversion methods:
% char             - convert to human readable string
% compact          - convert to 6-vector
% skew             - convert to 4x4 skew symmetric matrix
%
% Display and print methods:
% display          - display in human readable form
% plot             - plot line
%
% Operators:
% *                - multiply Plucker matrix by a general matrix
% |                - test if lines are parallel
% ^                - test if lines intersect
% ==               - test if two lines are equivalent
% ~=               - test if lines are not equivalent
%
% Static methods:
% Plucker.Planes   - Constructor from planes
% Plucker.PointDir - Constructor from point and direction
%
% Notes:
%  - This is reference (handle) class object
%  - Plucker objects can be used in vectors and arrays
%
% References::
%  - Ken Shoemake, "Ray Tracing News", Volume 11, Number 1
%    http://www.realtimerendering.com/resources/RTNews/html/rtnv11n1.html#art3
%  - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%    P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%    Chapter 2
%

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 


% NOTES
% working: constructor, origin-distance, plane+volume intersect, plot, .L
% method
% TODO
% .L method to skew

classdef Plucker < handle
    
    properties
        w  % direction vector
        v  % moment vector (normal of plane containing line and origin)
    end
    
    properties (Dependent)
        uw  % unit direction vector
    end
    
    methods
        
        function pl = Plucker(p1, p2)
            %Plucker Construct object

            switch nargin
                case 0
                    w = [nan nan nan];
                    v = w;
                case 1
                    if isvec(p1, 6)
                        w = p1(1:3);
                        v = p1(4:6);
                    elseif isa(p1, "Plucker")
                        v = p1.v;
                        w = p1.w;
                    else
                        error("RVC3:Plucker", "bad arguments to constructor");
                    end
                case 2                    
                    assert(isvec(p1,3) && isvec(p2,3), "RVC3:Plucker:badarg", "arguments must be two 3-vectors");
                    % compute direction and moment
                    p1 = p1(:)'; p2 = p2(:)';
                    w = p1 - p2;
                    v = cross(p1-p2, p1);
            end
            pl.w = w(:)';
            pl.v = v(:)';
        end
        
        function z = mtimes(left, right)
            %MTIMES Plucker multiplication
            %
            % PL1 * PL2 is the scalar reciprocal product.
            %
            % PL * M is the product of the Plucker skew matrix and M (4xN).
            %
            % Notes:
            %  - The * operator is overloaded for convenience.
            %  - Multiplication or composition of Plucker lines is not defined.
            %
            % See also Plucker.skew, SE3.mtimes.
            
            if isa(left, "Plucker") && isa(right, "Plucker")
                % reciprocal product
                z = dot(left.uw, right.v) + dot(right.uw, left.v);
            elseif isa(left, "Plucker") && isnumeric(right)
                assert(size(right,1) == 4, "RVC3:Plucker:badarg", "must postmultiply by 4xN matrix");
                z = left.skew * right;  % postmultiply by 4xN
            end
        end

        function pl2 = transform(pl, T)
            %TRANSFORM Plucker multiplication
            %
            % T * PL is the product of Ad(T) (6x6) and the Plucker
            % coordinate vector (1x6).
            %
            % Notes:
            %  - Premultiplying by an se3 will transform the line with respect to the world
            %    coordinate frame.
            %
            % See also Plucker.skew, SE3.mtimes.

            pl2 = Plucker(tform2adjoint(inv(T)) * pl.compact')
        end
        
        function x = pp(pl)
            %PP Principal point of the line
            %
            % PL.PP is the point on the line (1x3) that is closest to the origin.
            %
            % Notes:
            %  - Same as PL.POINT(0)
            %
            % See also Plucker.PPD, Plucker.POINT.
            
            x = cross(pl.v, pl.w) / dot(pl.w, pl.w);
            x = x(:)';  % row vector
        end
        
        function x = compact(pl)
            %COMPACT  Convert Plucker coordinates to MATLAB vector
            %
            % PL.COMPACT is a vector (1x6) comprising the Plucker direction and moment vectors.
            x = [pl.w pl.v];
        end
        
        function z = get.uw(pl)
            %UW Line direction as a unit vector
            %
            % PL.UW is a unit-vector (1x3) parallel to the line
            z = unitvector(pl.w);
        end
        
        function z = skew(pl)
            %SKEW Skew matrix form of the line
            %
            % PL.SKEW() is the Plucker matrix (4x4), a skew-symmetric
            % matrix representation of the line.
            %
            % Notes:
            %  - For two homogeneous points P and Q on the line, PQ'-QP' is
            %    also skew symmetric.
            %  - The projection of Plucker line by a perspective camera is
            %    a homogeneous line (3x1) given by vex(C*L*C') where C
            %    (3x4) is the camera matrix.
            
            v = pl.v; w = pl.w; %#ok<*PROP>
            
            % the following matrix is at odds with H&Z pg. 72
            z = [
                 0      v(3) -v(2) w(1)
                -v(3)   0     v(1) w(2)
                 v(2) -v(1)   0    w(3)
                -w(1) -w(2)  -w(3) 0    ];
        end

        
        function d = ppd(pl)
            %PPD  Distance from principal point to the origin
            %
            % PL.PPD() is the distance from the principal point to the
            % origin. This is the smallest distance of any point on the
            % line to the origin.
            %
            % See also Plucker.PP.
            d = sqrt( dot(pl.v, pl.v) / dot(pl.w, pl.w) );
        end
        
        function P = point(L, lambda)
            %POINT Generate point on line
            %
            % PL.POINT(LAMBDA) is a point (1x3) on the line, where LAMBDA
            % is the parametric distance along the line from the principal
            % point of the line P = PP + PL.UW*LAMBDA.
            %
            % See also Plucker.PP, Plucker.CLOSEST.
            
            P = L.pp + lambda(:)*L.uw;
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  TESTS ON PLUCKER OBJECTS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function t = contains(pl, x, tol)
            arguments
                pl
                x (:,3)
                tol (1,1) double = 50
            end
            %CONTAINS  Test if point is on the line
            %
            % PL.CONTAINS(X) is true if the point X (1x3) lies on the line
            % defined by the Plucker object PL. If X is Nx3 then each
            % row is a point and is tested, the result is 1xN.
            % 
            
            assert(size(x,2) == 3, "RVC3:Plucker", "points must have 3 columns");
            t = zeros(1, size(x,1), "logical");
            for i=1:size(x,1)
                t(i) = norm( cross(x(i,:) - pl.pp, pl.w) ) < tol*eps;
            end
        end
        
        function t = eq(pl1, pl2)
            %EQ Test if two lines are equivalent
            %
            % PL1 == PL2 is true if the Plucker objects describe the same
            % line in space.  Note that because of the over
            % parameterization, lines can be equivalent even if they have
            % different parameters.
            
            t = abs( 1 - dot(unitvector(compact(pl1)), unitvector(compact(pl2))) ) < 10*eps;
        end
        
        function t = ne(pl1, pl2)
            %NE Test if two lines are not equivalent
            %
            % PL1 ~= PL2 is true if the Plucker objects describe different
            % lines in space.  Note that because of the over
            % parameterization, lines can be equivalent even if they have
            % different parameters.
            
            t = abs( 1 - dot(unitvector(compact(pl1)), unitvector(compact(pl2))) ) >= 10*eps;
        end
        
        function v = isparallel(p1, p2)
            %ISPARALLEL Test if lines are parallel
            %
            % P1.ISPARALLEL(P2) is true if the lines represented by Plucker
            % objects P1 and P2 are parallel.
            %
            % See also Plucker.OR, Plucker.INTERSECTS.
            
            v = norm( cross(p1.w, p2.w) ) < 10*eps;
        end
        
        function v = or(p1, p2)
            %OR Test if lines are parallel
            %
            % P1|P2 is true if the lines represented by Plucker objects P1
            % and P2 are parallel.
            %
            %
            % See also Plucker.ISPARALLEL, Plucker.MPOWER.
            v = isparallel(p1, p2);
        end
        
        function v = mpower(p1, p2)
            %MPOWER Test if lines intersect
            %
            % P1^P2 is true if lines represented by Plucker objects P1
            % and P2 intersect at a point.
            %
            % Notes:
            %  - Is false if the lines are equivalent since they would intersect at
            %    an infinite number of points.
            %
            % See also Plucker.INTERSECTS, Plucker.ISPARALLEL.
            v = ~isparallel(p1, p2) && ( abs(p1 * p2) < 10*eps );
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  PLUCKER LINE DISTANCE AND INTERSECTION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        function p = intersects(p1, p2)
            %INTERSECTS Find intersection of two lines
            %
            % P1.INTERSECTS(P2) is the point of intersection (1x3) of the
            % lines represented by Plucker objects P1 and P2.  P = [] if
            % the lines do not intersect, or the lines are equivalent.
            %
            % Notes:
            %  - Can be used in operator form as P1^P2.
            %  - Returns [] if the lines are equivalent (P1==P2) since they
            %  would intersect at an infinite number of points.
            %
            % See also Plucker.COMMONPERP, Plucker.EQ, Plucker.MPOWER.
            
            if p1^p2 %#ok<BDLOG>
                p = -( dot(p1.v,p2.w)*eye(3,3) + p1.w'*p2.v - p2.w'*p1.v ) * unitvector(cross(p1.w, p2.w)');
            else
                p = [];
            end
        end
        
        function l = distance(p1, p2)
            %DISTANCE Distance between lines
            %
            % P1.DISTANCE(P2) is the minimum distance between two lines
            % represented by Plucker objects P1 and P2.
            %
            % Notes:
            %  - Works for parallel, skew and intersecting lines.
            if isparallel(p1, p2)
                % lines are parallel
                l = cross(p1.w, p1.v - p2.v * dot(p1.w, p2.w)/ dot(p2.w, p2.w)) / norm(p1.w);
            else
                % lines are not parallel
                if abs(p1 * p2) < 10*eps
                    % lines intersect at a point
                    l = 0;
                else
                    % lines don't intersect, find closest distance
                    l = abs(p1*p2) / norm(cross(p1.w, p2.w))^2;
                end
            end
        end
        
        function [p,dist,lambda] = closest(pl, x)
            %CLOSEST  Point on line closest to given point
            %
            % P = PL.CLOSEST(X) is the coordinate of a point (3x1) on the line that is
            % closest to the point X (3x1).
            %
            % [P,d] = PL.CLOSEST(X) as above but also returns the minimum distance
            % between the point and the line.
            %
            % [P,dist,lambda] = PL.CLOSEST(X) as above but also returns the line parameter
            % lambda corresponding to the point on the line, ie. P = PL.point(lambda)
            %
            % See also Plucker.POINT.
            
            % http://www.ahinson.com/algorithms_general/Sections/Geometry/PluckerLine.pdf
            % has different equation for moment, the negative
            
            x = x(:)';
            
            lam = dot(x - pl.pp, pl.uw);
            p = pl.point(lam);  % is the closest point on the line
            
            if nargout > 1
                dist = norm( x - p);
            end
            if nargout > 2
                lambda = lam;
            end
        end
        
        
        function p = commonperp(p1, p2)
            %COMMONPERP Common perpendicular to two lines
            %
            % P = PL1.COMMONPERP(PL2) is a Plucker object representing the
            % common perpendicular line between the lines represented by
            % the Plucker objects PL1 and PL2.
            %
            % See also Plucker.INTERSECT.
            
            if isparallel(p1, p2)
                % no common perpendicular if lines are parallel
                p = [];
            else
                w = cross(p1.w, p2.w); %#ok<*PROPLC>
                
                v = cross(p1.v, p2.w) - cross(p2.v, p1.w) + ...
                    (p1*p2) * dot(p1.w, p2.w) * unitvector(cross(p1.w, p2.w));
                
                p = Plucker([w v]);
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  PLUCKER LINE DISTANCE AND INTERSECTION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        function [p,t] = intersect_plane(L, plane)
            %INTERSECT_PLANE  Line intersection with plane
            %
            % X = PL.INTERSECT_PLANE(PI) is the point where the Plucker
            % line PL intersects the plane PI.  X=[] if no intersection.
            %
            % The plane PI can be either:
            %  - a vector (1x4) = [a b c d] to describe the plane ax+by+cz+d=0.
            %  - a structure with a normal PI.n (3x1) and an offset PI.p
            %    (1x1) such that PI.n X + PI.p = 0.
            %
            % [X,lambda] = PL.intersect_plane(P) as above but also returns the
            % line parameter at the intersection point, ie. X = PL.point(lambda).
            %
            % See also Plucker.POINT.
            
            % Line U, V
            % Plane N n
            % (VxN-nU:U.N)
            % Note that this is in homogeneous coordinates.
            %    intersection of plane (n,p) with the line (v,p)
            %    returns point and line parameter
            
            if isstruct(plane)
                N = plane.n;
                n = -dot(plane.n, plane.p);
            else
                N = plane(1:3);
                n = plane(4);
            end
            N = N(:);
            
            den = dot(L.w, N);
            
            if abs(den) > (100*eps)
                %p = -(cross(L.v, N) + n*L.w) / den;
                p = (cross(L.v, N) - n*L.w) / den;
                
                P = L.pp;
                t = dot( P-p, N');
            else
                p = [];
                t = [];
            end
        end
        
        function [P,lambda] = intersect_volume(line, bounds)
            %INTERSECT_VOLUME Line intersection with volume
            %
            % P = PL.INTERSECT_VOLUME(BOUNDS) is a matrix (3xN) with
            % columns that indicate where the Plucker line PL intersects
            % the faces of a volume specified by BOUNDS = [xmin xmax ymin
            % ymax zmin zmax].  The number of columns N is either 0 (the
            % line is outside the plot volume) or 2 (where the line pierces
            % the bounding volume).
            %
            % [P,lambda] = PL.intersect_volume(bounds, line) as above but
            % also returns the line parameters (1xN) at the intersection
            % points, ie. X = PL.point(lambda).
            %
            % See also Plucker.PLOT, Plucker.POINT.
            
            ll = [];
            
            % reshape, top row is minimum, bottom row is maximum
            bounds = reshape(bounds, [2 3]);
            
            for face=1:6
                % for each face of the bounding volume
                %  x=xmin, x=xmax, y=ymin, y=ymax, z=zmin, z=zmax
                
                i = ceil(face/2);  % 1,2,3
                I = eye(3,3);
                plane.n = I(:,i);
                plane.p = [0 0 0]';
                plane.p(i) = bounds(face);
                
                % find where line pierces the plane
                [p,lambda] = line.intersect_plane(plane);
                
                
                if isempty(p)
                    continue;  % no intersection with this plane
                end
                
                %                 fprintf('face %d: n=(%f, %f, %f), p=(%f, %f, %f)\n', face, plane.n, plane.p);
                %                 fprintf('      : p=(%f, %f, %f)  ', p)
                
                % find if intersection point is within the cube face
                %  test x,y,z simultaneously
                k = (p >= bounds(1,:)) & (p <= bounds(2,:));
                k(i) = [];  % remove the boolean corresponding to current face
                if all(k)
                    % if within bounds, add
                    ll = [ll lambda]; %#ok<AGROW>
                    %                     fprintf('  HIT\n');
                    %                 else
                    %                     fprintf('\n');
                end
            end
            % put them in ascending order
            ll = sort(ll);
            
            % determine the intersection points from the parameter values
            if isempty(ll)
                P = [];
            else
%                 P = bsxfun(@plus, line.point(0), line.w*ll);
                  P = line.point(ll);
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  PLOT AND DISPLAY
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function plot(lines, varargin)
            %PLOT Plot a line
            %
            % PL.PLOT(OPTIONS) adds the Plucker line PL to the current plot volume.
            %
            % PL.PLOT(B, OPTIONS) as above but plots within the plot bounds B = [XMIN
            % XMAX YMIN YMAX ZMIN ZMAX].
            %
            % Options:
            %  - Are passed directly to plot3, eg. 'k--', 'LineWidth', etc.
            %
            % Notes:
            %  - If the line does not intersect the current plot volume nothing will
            %    be displayed.
            %
            % See also PLOT3, Plucker.INTERSECT_VOLUME.
            bounds = [];
            if nargin > 1
                if all(size(varargin{1}) == [1 6])
                    bounds = varargin{1};
                    varargin = varargin{2:end};
                end
            end
            
            ax = gca;
            if isempty(bounds)
                bounds = [ax.XLim ax.YLim ax.ZLim];
            else
                axis(bounds);
            end
            
            %U = pl.Q - pl.P;
            %line.p = pl.P; line.v = unitvector(U);
            
            ish = ishold();
            hold on
            for pl=lines
                P = pl.intersect_volume(bounds);
                
                if isempty(P)
                    warning("RVC3:Plucker", "line does not intersect the plot volume");
                else
                    plot3(P(:,1), P(:,2), P(:,3), varargin{:});
                end
            end
            if ~ish
                hold off
            end
        end
        
        
        function display(pl) %#ok<DISPLAY>
            %DISPLAY Display parameters
            %
            % P.DISPLAY() displays the Plucker parameters in compact single line format.
            %
            % Notes::
            %  - This method is invoked implicitly at the command line when the result
            %    of an expression is a Plucker object and the command has no trailing
            %    semicolon.
            %
            % See also Plucker.CHAR.
            loose = strcmp( get(0, "FormatSpacing"), 'loose'); %#ok<GETFSP>
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            disp( char(pl) );
        end % display()
        
        function disp(pl)
            disp( char(pl) );
        end
        
        function s = char(pl)
            %CHAR Convert to string
            %
            % s = P.CHAR() is a string showing Plucker parameters in a
            % compact single line format.
            %
            % See also Plucker.DISPLAY.
            s = '';
            for i=1:length(pl)
                
                ps = '{ ';
                ps = [ ps, sprintf('%0.5g  ', pl(i).v) ]; %#ok<AGROW>
                ps = [ ps(1:end-2), '; '];
                ps = [ ps, sprintf('%0.5g  ', pl(i).w) ]; %#ok<AGROW>
                ps = [ ps(1:end-2), '}'];
                if isempty(s)
                    s = ps;
                else
                    s = char(s, ps);
                end
            end
        end
        
        
        %         function z = side(pl1, pl2)
        %             %Plucker.side Plucker side operator
        %             %
        %             % X = SIDE(P1, P2) is the side operator which is zero whenever
        %             % the lines P1 and P2 intersect or are parallel.
        %             %
        %             % See also Plucker.or.
        %
        %             if ~isa(pl2, 'Plucker')
        %                 error('SMTB:Plucker:badarg', 'both arguments to | must be Plucker objects');
        %             end
        %             L1 = pl1.line(); L2 = pl2.line();
        %
        %             z = L1([1 5 2 6 3 4]) * L2([5 1 6 2 4 3])';
        %         end
        
        %
        %         function z = intersect(pl1, pl2)
        %             Plucker.intersect  Line intersection
        %
        %             PL1.intersect(PL2) is zero if the lines intersect.  It is positive if PL2
        %             passes counterclockwise and negative if PL2 passes clockwise.  Defined as
        %             looking in direction of PL1
        %
        %                                        ---------->
        %                            o                o
        %                       ---------->
        %                      counterclockwise    clockwise
        %
        %             z = dot(pl1.w, pl1.v) + dot(pl2.w, pl2.v);
        %         end
        
    end % methods
    
    methods (Static)
        % Static factory methods for constructors from exotic representations
        
        function pl = Planes(pi1, pi2)
            %Planes Create Plucker line from two planes
            %
            % P = Plucker.Planes(PI1, PI2) is a Plucker object that represents
            % the line formed by the intersection of two planes PI1, PI2 (each 4x1).
            %
            % Notes:
            %  - Planes are given by the 4-vector [a b c d] to represent ax+by+cz+d=0.
            
            assert( isvec(pi1,4) && isvec(pi2,4), "RVC3:Plucker:badarg", "expecting 4-vectors");
            pi1 = pi1(:); pi2 = pi2(:);
            
            pl = Plucker();
            pl.w = cross(pi1(1:3), pi2(1:3))';
            pl.v = (pi2(4)*pi1(1:3) - pi1(4)*pi2(1:3))';
        end
        
        function pl = PointDir(point, dir)
            %PointDir Construct Plucker line from point and direction
            %
            % P = Plucker.PointDir(P, W) is a Plucker object that represents the
            % line containing the point P (3x1) and parallel to the direction vector W (3x1).
            %
            % See also: Plucker.
            
            
            assert( isvec(point,3) && isvec(dir,3), "RVC3:Plucker:badarg", "expecting 3-vectors");
            %                     pl.P = B;
            %                     pl.Q = A+B;
            
            point = point(:); dir = dir(:);
            pl = Plucker();
            pl.w = dir';
            pl.v = cross(dir, point)';
            
        end
    end % static methods
end % class


