%TWIST2D 2D twist class
%
% A Twist2d class holds the parameters of a twist, a representation of a
% rigid body displacement in 3D.  A twist comprises the six unique elements
% of the logarithm of the SE(3) matrix.
%
% TW = Twist2d(T) is a Twist2d object constructed from an SE(2) matrix (4x4).
%
% TW = Twist2d(T) is a Twist object constructed from an se2 object.
%
% TW = Twist2d(V) is a Twist2d object constructed directly from the vector V
% (1x6) comprising the directional and moment components.
%
% Methods:
%  pole          - a point on the line of the screw
%  theta         - rotation about the screw
%  Ad            - adjoint matrix (3x3)
%  ad            - logarithm of adjoint matrix (3x3)
%  prod          - product of a vector of Twist2d
%  printline     - print twist in compact single line format
%  char          - convert to string
%  display       - print the Twist parameters in human readable form
%
% Conversion methods:
%  compact       - convert to a MATLAB vector (1x3)
%  skewa         - convert to an augmented skew-symmetric matrix (3x3)
%  tform         - convert to an SE(2) matrix (3x3)
%  exp           - convert to an se2 object
%
% Overloaded operators:
%  *             - compose Twist2d with Twist2d or SE(2)
%  *             - scale Twist by a scalar
%
% Properties (read only):
%  w             - direction part of twist (1x1)
%  v             - moment part of twist (1x2)
%
%
% See also expm, logm.
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Chapter 2
% - Mechanics, planning and control, F.Park & K.Lynch, Cambridge, 2016.
%
% See also UnitRevolute, UnitPrismatic.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

classdef Twist2d
    properties (SetAccess = protected)
        v  % axis direction (column vector)
        w  % moment (column vector)
    end
    
    methods
        function tw = Twist2d(T)
             %Twist Construct object
            arguments
                T = eye(3)
            end
            
            if isnumeric(T) && all(size(T) == [3 3])
                if T(end,end) == 1
                    % its a homogeneous matrix, take the logarithm
                    S = logm(T);
                    s = skewa2vec(S);
                else
                    % it's an augmented skew matrix, unpack it
                    s = skewa2vec(T);
                end

            elseif isnumeric(T) && isvec(T, 3)
                % in vector form
                if ~isa(T, "sym")
                    T(abs(T)<eps) = 0;
                end
                s = T;
            elseif isa(T, "se2")
                % its a homogeneous matrix, take the logarithm
                T = T.tform
                S = logm(T);
                s = skewa2vec(S);               
            else
                error("RVC3:Twist2d:badarg", "3x3 or 1x3 matrix or se2 object expected");
            end
            
            tw.v = s(2:3);
            tw.w = s(1);
        end

        function ut = unit(tw, tol)
            arguments
                tw (1,1) Twist2d
                tol (1,1) double = 10
            end
            %UNIT Return a unit twist
            %
            % TW.UNIT is a unit twist object representing a unit aligned with
            % the twist TW.
            %
            % TW.UNIT(TOL) as above but use norm(TW.W) < TOL*eps as the
            % threshold to determine if twist is revolute.
            if abs(tw.w) > tol*eps
                % rotational twist
                ut = Twist2d( compact(tw) / norm(tw.w) );
            else
                % prismatic twist
                ut = Twist2d( [0 unitvector(tw.v)] );
            end
        end
        
        function x = tform(tw, theta)
            arguments
                tw (1,1) Twist2d
                theta (1,1) double = 1
            end
            %TFORM Convert twist to SE(2) matrix
            %
            % TW.TFORM is the exponential of the twist which is the
            % equivalent transformation expressed as an SE(2) matrix (3x3).
            %
            % TW.TFORM(THETA) as above but TW is a unit twist and THETA is
            % the rotation about the twist axis.
            %
            % See also EXP.

            x = expm(vec2skewa(tw.compact * theta));
        end

        function x = compact(tw)
            %COMPACT Convert twist to MATLAB vector
            %
            % TW.COMPACT is a 3-element MATLAB vector comprising the
            % direction then moment components of the twist.
            x = [tw.w tw.v];
        end
        
        function x = skewa(tw)
            %SKEWA Return the twist as se(2) matrix
            %
            % TW.SKEWA is the twist as an se(2) matrix, a 3x3 augmented
            % skew-symmetric matrix.
            %
            % See also se2.
            x = vec2skewa(tw.compact);
        end

        function c = mtimes(left, right)
            %MTIMES Multiply twist by other object
            %
            % Compose or scale twists.
            %
            %   left     right                result
            %   -------+------------+----------------------
            %   Twist2d  Twist2d      Twist2d
            %   Twist2d  scalar       Twist2d
            %   Twist2d  3x3          3x3
            %   Twist2d  se2          se2
                        %   scalar Twist                Twist
            %   4x4    Twist                4x4
            
            if isa(left, "Twist2d")
                if isa(right, "Twist2d")
                    % twist composition
                    c = Twist2d( left.tform * right.tform);
                elseif isscalar(right) && isreal(right)
                    c = Twist2d(left.compact * right);
                elseif istform2d(right)
                    % compose a twist with SE(2), result is an SE(2)
                    c = left.tform * double(right);
                elseif isa(right, "se2")
                    % compose a twist with se2, result is an se2
                    c = se2(left.tform * right.tform);
                else
                    error("RVC3:Twis2d", "twist *, operands don't conform");
                end
            elseif isa(right, "Twist2d")
                if isscalar(left) && isreal(left)
                    c = Twist2d(left * right.compact);
                elseif istform(left)
                    % compose a twist with SE(2), result is an SE(2)
                    c = double(left) * right.tform;
                end
            else
                error("RVC3:Twist2d: incorrect operand types for * operator")
            end
        end
        
        function x = exp(tw, theta)
            arguments
                tw (1,1) Twist2d
                theta (1,:) double = 1
            end
            %EXP Convert twist to se2 object
            %
            % TW.EXP is the exponential of the twist which is the
            % equivalent transformation expressed as an se2 object.
            %
            % TW.EXP(THETA) as above but TW is a unit twist and THETA is
            % the rotation about the twist axis. If THETA is a vector the
            % result will be a vector of TW exponentiated with the elements
            % of THETA.
            %
            % See also TFORM.

            for i=1:length(theta)
                x(i) = se2(expm(vec2skewa(tw.compact * theta(i))));
            end
        end

        function x = Ad(tw)
            %Ad Adjoint matrix
            %
            % TW.Ad is the adjoint matrix (3x3) of the corresponding
            % homogeneous transformation.
            %
            % See also SE2.AD.
            x = tform2adjoint(tw.tform);
        end
  
        function x = ad(tw)
            %AD Logarithm of adjoint matrix
            %
            % TW.AD is the logarithm of the adjoint matrix (3x3) of the
            % corresponding homogeneous transformation.
            %
            % See also SE2.Ad.
            x = [ vec2skew(tw.w) vec2skew(tw.v); zeros(3,3) vec2skew(tw.w) ];
        end
        
        
        function out = prod(tw)
            %PROD Compound array of twists
            %
            % TW.PROD is a twist representing the product (composition) of the
            % successive elements of TW (1xN), an array of Twists.
            %
            out = tw(1);
            for i=2:length(tw)
                out = out * tw(i);
            end
        end
        
        function p = pole(tw)
            %POLE Point on the twist axis
            %
            % TW.POLE is a point on the twist axis (1x2). For pure
            % translation this point is at infinity.
            v = [tw.v 0]; %#ok<*PROP>
            w = [0 0 tw.w];
            p = cross(w, v) / tw.theta();
            p = p(1:2);

        end
        
        function th = theta(tw)
            %Twist.theta Twist rotation
            %
            % TW.theta is the rotation (1x1) about the twist axis in radians.
            %
            
            th = norm(tw.w);
        end
        
        function s = char(tw)
            %CHAR Convert to string
            %
            % TW.CHAR is a string showing twist parameters in a compact
            % single line format. If TW is a vector of Twist objects return
            % a string with one line per Twist.
            %
            % See also DISPLAY.
            s = '';
            for i=1:length(tw)
                
                ps = '( ';
                ps = [ ps, sprintf('%0.5g  ', tw(i).w) ]; %#ok<AGROW>
                ps = [ ps(1:end-2), '; '];
                ps = [ ps, sprintf('%0.5g  ', tw(i).v) ]; %#ok<AGROW>

                ps = [ ps(1:end-2), ' )'];
                if isempty(s)
                    s = ps;
                else
                    s = char(s, ps);
                end
            end
        end
        
        function display(tw) %#ok<DISPLAY>
            %DISPLAY Display parameters
            %
            % TW.DISPLAY() displays the twist parameters in compact single
            % line format.  If L is a vector of Twist objects displays one
            % line per element.
            %
            % Notes:
            % - This method is invoked implicitly at the command line when
            %   the result of an expression is a Twist object and the
            %   command has no trailing semicolon.
            %
            % See also CHAR.
            loose = strcmp( get(0, 'FormatSpacing'), 'loose'); %#ok<GETFSP>
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            disp( char(tw) );
        end % display()
        
    end

    methods(Static)
         function tw = UnitRevolute(point)
            arguments
                point (1,2) double
            end
            %UnitRevolute Create a unit revolute twist
            %
            % TW = Twist.UnitRevolute(Q) creates a unit twist
            % representing rotation about the point Q (1x2).
            %
            % See also Twist2d, Twist2d.UnitPrismatic.
                        
            v = -cross([0 0 1], [point 0]);
            tw = Twist2d([1 v(1:2)]);
        end

        function tw = UnitPrismatic(dir)
            arguments
                dir (1,2) double
            end
            %UnitPrismatic Create a unit prismatic twist
            %
            % TW = Twist.UnitPrismatic(A) creates a unit twist representing
            % translation along the axis A (1x2).
            %
            % See also Twist2d, Twist2d.UnitRevolute.
                        
            tw = Twist2d([0 unitvector(dir)]);
        end
    end
end
