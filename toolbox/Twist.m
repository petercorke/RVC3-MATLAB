%TWIST 3D twist class
%
% A Twist class holds the parameters of a twist, a representation of a
% rigid body displacement in 3D.  A twist comprises the six unique elements
% of the logarithm of the SE(3) matrix.
%
% TW = Twist(T) is a Twist object constructed from an SE(3) matrix (4x4).
%
% TW = Twist(T) is a Twist object constructed from an se3 object.
%
% TW = Twist(V) is a Twist object constructed directly from the vector V
% (1x6) comprising the directional and moment components.
%
% Methods:
%  pitch         - pitch of the twist
%  pole          - a point on the line of the screw
%  theta         - rotation about the screw
%  Ad            - adjoint matrix (6x6)
%  ad            - logarithm of adjoint matrix (6x6)
%  prod          - product of a vector of Twists
%  line          - Plucker line object representing line of the screw
%  printline     - print twist in compact single line format
%  char          - convert to string
%  display       - print the Twist parameters in human readable form
%
% Static methods:
%  UnitRevolute  - create a unit revolute twist
%  UnitPrismatic - create a unit prismatic twist
%  Euler         - create a pure rotational twist
%
% Conversion methods:
%  compact       - convert to a MATLAB vector (1x6)
%  skewa         - convert to an augmented skew-symmetric matrix (4x4)
%  tform         - convert to an SE(3) matrix (4x4)
%  exp           - convert to an se3 object
%
% Overloaded operators:
%  *             - compose Twist with Twist or SE(3)
%  *             - transform SpatialVector subclass objects
%  *             - scale Twist by a scalar
%
% Properties (read only):
%  w             - direction part of twist (1x3)
%  v             - moment part of twist (1x3)
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Chapter 2
% - Mechanics, planning and control, F.Park & K.Lynch, Cambridge, 2016.
%
% See also UnitRevolute, UnitPrismatic.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

classdef Twist
    properties (SetAccess = protected)
        v  % axis direction (column vector)
        w  % moment (column vector)
    end
    
    methods
        function tw = Twist(T)
            %Twist Construct object
            arguments
                T = eye(4)
            end
            
            if isnumeric(T) && all(size(T) == [4 4])
                if T(end,end) == 1
                    % its a homogeneous matrix, take the logarithm
                    S = logm(T);
                    s = skewa2vec(S);
                else
                    % it's an augmented skew matrix, unpack it
                    s = skewa2vec(T);
                end

            elseif isnumeric(T) &&  isvec(T, 6)
                % in vector form
                if ~isa(T, "sym")
                    T(abs(T)<eps) = 0;
                end
                s = T;

            elseif isa(T, "se3")
                % its a homogeneous matrix, take the logarithm
                T = T.tform
                S = logm(T);
                s = skewa2vec(S);  

            else
                error("RVC3:Twist:badarg", "4x4 or 1x6 matrix or se3 object expected");
            end
            tw.v = s(4:6);
            tw.w = s(1:3);
        end

        function printline(obj, varargin)
            %PRINTLINE Print twist in compact single line format
            %
            % TW.PRINTLINE print twist in compact single line format.
            %
            % TW.PRINTLINE(OPTIONS) as above but with options passed to
            % PRINTTFORM.
            %
            % See also PRINTTFORM.
            printtform(obj.tform, varargin{:});
        end
        
        function ut = unit(tw, tol)
            arguments
                tw (1,1) Twist
                tol (1,1) double = 10
            end
            %UNIT Return a unit twist
            %
            % TW.UNIT is a unit twist object representing a unit aligned with
            % the twist TW.
            %
            % TW.UNIT(TOL) as above but use norm(TW.W) < TOL*eps as the
            % threshold to determine if twist is revolute.
            if norm(tw.w) > tol*eps
                % rotational twist
                ut = Twist( compact(tw) / norm(tw.w) );
            else
                % prismatic twist
                ut = Twist( [0 0 0 unitvector(tw.v)] );
            end
        end
        
        function x = tform(tw, theta)
            arguments
                tw (1,1) Twist
                theta (1,1) double = 1
            end
            %TFORM Convert twist to SE(3) matrix
            %
            % TW.TFORM is the exponential of the twist which is the
            % equivalent transformation expressed as an SE(3) matrix (4x4).
            %
            % TW.TFORM(THETA) as above but TW is a unit twist and THETA is
            % the rotation about the twist axis.
            %
            % See also EXP.

            x = expm(vec2skewa(tw.compact * theta));
        end

        function x = exp(tw, theta)
            arguments
                tw (1,1) Twist
                theta (1,:) double = 1
            end
            %EXP Convert twist to se3 object
            %
            % TW.EXP is the exponential of the twist which is the
            % equivalent transformation expressed as an se3 object.
            %
            % TW.EXP(THETA) as above but TW is a unit twist and THETA is
            % the rotation about the twist axis. If THETA is a vector the
            % result will be a vector of TW exponentiated with the elements
            % of THETA.
            %
            % See also TFORM.

            for i=1:length(theta)
                x(i) = se3(expm(vec2skewa(tw.compact * theta(i))));
            end
        end

        function x = compact(tw)
            %COMPACT Convert twist to MATLAB vector
            %
            % TW.COMPACT is a 6-element MATLAB vector comprising the
            % directional then moment components of the twist.
            x = [tw.w tw.v];
        end
        
        function x = skewa(tw)
            %SKEWA Return the twist as se(3) matrix
            %
            % TW.SKEWA is the twist as an se(3) matrix, a 4x4 augmented
            % skew-symmetric matrix.
            %
            % See also se3.
            x = vec2skewa(tw.compact);
        end
        
        function c = mtimes(left, right)
            %MTIMES Multiply twist by other object
            %
            % Compose or scale twists, or transform a spatial vector
            % subclass object.
            %
            %   left   right                result
            %   -----+---------------------+----------------------
            %   Twist  Twist                Twist
            %   Twist  scalar               Twist
            %   Twist  4x4                  4x4
            %   Twist  se3                  se3
            %   Twist  SpatialVelocity      SpatialVelocity
            %   Twist  SpatialAcceleration  SpatialAcceleration
            %   Twist  SpatialForce         SpatialForce
            %   scalar Twist                Twist
            %   4x4    Twist                4x4
            %
            
            if isa(left, "Twist")
                if isa(right, "Twist")
                    % twist composition
                    c = Twist( left.tform * right.tform);
                elseif isscalar(right) && isreal(right)
                    c = Twist(left.compact * right);
                elseif istform(right)
                    % compose a twist with SE(3), result is an SE(3)
                    c = left.tform * double(right);
                elseif isa(right, "se3")
                    % compose a twist with se3, result is an se3
                    c = se3(left.tform * right.tform);
                elseif isa(right, "SpatialVelocity")
                    c = SpatialVelocity(left.Ad * right.vw);
                elseif isa(right, "SpatialAcceleration")
                    c = SpatialAcceleration(left.Ad * right.vw);
                elseif isa(right, "SpatialForce")
                    c = SpatialForce(left.Ad' * right.vw);
                else
                    error("RVC3:Twist", "twist * SEn, operands don''t conform");
                end
            elseif isa(right, "Twist")
                if isscalar(left) && isreal(left)
                    c = Twist(left * right.compact);
                elseif istform(left)
                    % compose a twist with SE(3), result is an SE(3)
                    c = double(left) * right.tform;
                end
            else
                error("RVC3:Twist: incorrect operand types for * operator")
            end
        end
        
        function x = mrdivide(a, b)
            %MRDIVIDE Scale twist by a scalar
            %
            % Scale twists.
            %
            %   left   right                result
            %   -----+---------------------+----------------------
            %   Twist  scalar               Twist
            %
            x = Twist(a.compact / b);
        end

        function x = Ad(tw)
            %Ad Adjoint matrix
            %
            % TW.Ad is the adjoint matrix (6x6) of the corresponding
            % homogeneous transformation.
            %
            % See also SE3.AD.
            x = tform2adjoint(tw.tform);
        end
        
        function x = ad(tw)
            %AD Logarithm of adjoint matrix
            %
            % TW.AD is the logarithm of the adjoint matrix (6x6) of the
            % corresponding homogeneous transformation, if TW is a unit
            % twist.
            %
            % See also SE3.Ad.
            x = [ vec2skew(tw.w) vec2skew(tw.v); zeros(3,3) vec2skew(tw.w) ];
        end

        function p = pitch(tw)
            %PITCH Pitch of the twist
            %
            % TW.PITCH is the pitch of the twist as a scalar in units of
            % distance per radian.

            p = tw.w * tw.v';
        end
        
        function L = line(tw)
            %LINE Line of twist axis in Plucker form
            %
            % TW.LINE is a Plucker object representing the line of the
            % twist axis.
            %
            % See also Plucker.
            
            % V = -tw.v - tw.pitch * tw.w;
            for i=1:length(tw)
                L(i) = Plucker([tw(i).w -tw(i).v-tw(i).pitch*tw(i).w]); %#ok<AGROW>
            end
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
            % TW.POLE is a point on the twist axis (1x3).
            %
            % Notes::
            % - For a pure translational twist, this point is at infinity.
            p = cross(tw.w, tw.v) / tw.theta();
        end
        
        function th = theta(tw)
            %THETA Twist rotation
            %
            % TW.THETA is the rotation (1x1) about the twist axis in
            % radians.
            %
            % See also
            
            th = norm(tw.w);
        end
       
        function s = char(tw)
            %CHAR Convert to string
            %
            % TW.CHAR() is a string showing twist parameters in a compact
            % single line format. If TW is a vector of Twist objects return
            % a string with one line per Twist.
            %
            % See also DISP.
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

        function disp(nav)
            %DISP Display twist parameters
            %
            %   TW.DISP displays twist parameters in compact human readable
            %   form.
            %
            %   This method is invoked implicitly at the command line when
            %   the result of an expression is a Twist object and the
            %   command has no trailing semicolon.
            %
            %   See also CHAR.

            loose = strcmp( get(0, 'FormatSpacing'), 'loose'); %#ok<GETFSP> 
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            disp( char(nav) );
        end
    end % methods

    methods(Static)
        function tw = UnitRevolute(dir, point, pitch)
            arguments
                dir (1,3) double
                point (1,3) double
                pitch (1,1) double = 0
            end
            %UnitRevolute Create a unit revolute twist
            %
            % TW = Twist.UnitRevolute(A, Q) creates a unit twist
            % representing rotation about the axis A (1x3) through the
            % point Q (1x3).
            % 
            % TW = Twist.UnitRevolute(A, Q, P) as above but with a pitch of
            % P (distance/angle).
            %
            % See also Twist, Twist.UnitPrismatic.
                        
            w = unitvector(dir);
            v = -cross(w, point) + pitch * w;
            tw = Twist([w v]);
        end

        function tw = UnitPrismatic(dir)
            arguments
                dir (1,3) double
            end
            %UnitPrismatic Create a unit prismatic twist
            %
            % TW = Twist.UnitPrismatic(A) creates a unit twist representing
            % translation along the axis A (1x3).
            %
            % See also Twist, Twist.UnitRevolute.
                        
            w = [0 0 0];
            v = unitvector(dir);
            tw = Twist([w v]);
        end

        function tw = Euler(varargin)
            %RPY Create a pure rotational twist from RPY angles
            %
            % TW = Twist.Euler(EUL, SEQ) creates a pure rotational twist from
            % the given Euler angles.
            %
            % See also EUL2TFORM.
            tw = Twist(se3(eul2tform(varargin{:})));
        end
    end % methods
end % classdef
