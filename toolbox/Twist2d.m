%TWIST2 2D Twist class
%
% A Twist class holds the parameters of a twist, a representation of a
% rigid body displacement in SE(2).
%
% Methods::
%  S             twist vector (1x3)
%  se            twist as (augmented) skew-symmetric matrix (3x3)
%  T             convert to homogeneous transformation (3x3)
%  R             convert rotational part to matrix (2x2)
%  exp           synonym for T
%  ad            logarithm of adjoint
%  pole          a point on the line of the screw
%  prod          product of a vector of Twists
%  theta         rotation about the screw
%  line          Plucker line object representing line of the screw
%  display       print the Twist parameters in human readable form
%  char          convert to string
%
% Conversion methods::
%  SE            convert to SE2 object
%  double        convert to real vector
%
% Overloaded operators::
%  *             compose two Twists
%  *             multiply Twist by a scalar
%
% Properties (read only)::
%  v             moment part of twist (2x1)
%  w             direction part of twist (1x1)
%
% References::
% - "Mechanics, planning and control"
%   Park & Lynch, Cambridge, 2016.
%
% See also trexp, trexp2, trlog.

% Copyright (C) 1993-2019 Peter I. Corke
%
% This file is part of The Spatial Math Toolbox for MATLAB (SMTB).
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
% of the Software, and to permit persons to whom the Software is furnished to do
% so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
% FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
% COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
% IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
% CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% https://github.com/petercorke/spatial-math

classdef Twist2d
    properties (SetAccess = protected)
        v  % axis direction (column vector)
        w  % moment (column vector)
    end
    
    methods
        function tw = Twist2d(T, varargin)
            %Twist2.Twist2 Create Twist2 object
            %
            % TW = Twist2(T) is a Twist object representing the SE(2)
            % homogeneous transformation matrix T (3x3).
            %
            % TW = Twist2(V) is a twist object where the vector is specified directly.
            %
            % TW = Twist2('R', Q) is a Twist object representing rotation about the point Q (2x1).
            %
            % TW = Twist2('T', A) is a Twist object representing translation in the
            % direction of A (2x1).
            %
            % Notes::
            %  The argument 'P' for prismatic is synonymous with 'T'.
            
            if ischar(T)
                % 'P', dir
                % 'R', dir, point 3D
                % 'R', point   2D
                switch upper(T)
                    case 'R'
                            
                        point = varargin{1};
                        point = point(:);
                        v = -cross([0 0 1]', [point; 0]);
                        w = 1;
                        v = v(1:2);

                        
                    case {'P', 'T'}
                        dir = varargin{1};
                        
                        w = 0;

                        v = unit(dir(:));
                end
                
                if ~isa(v, 'sym')
                    v(abs(v)<eps) = 0;
                end
                if ~isa(w, 'sym')
                    w(abs(w)<eps) = 0;
                end
                tw.v = v(:)';
                tw.w = w;
            elseif size(T,1) == size(T,2)
                % it's a square matrix
                if T(end,end) == 1
                    % its a homogeneous matrix, take the logarithm
                    S = logm(T);
                    tw.v = S(1:2,3)';
                    tw.w = skew2vec(S(1:2,1:2));
                else
                    % it's an augmented skew matrix, unpack it
                    skw = tform2rotm2d(T);
                    tw.v = S(1:2,3);
                    tw.w = skew2vec(S(1:2,1:2));
                end
            elseif isvector(T)
                % its a row vector form of twist, unpack it
                if length(T) == 3
                    tw.v = T(1:2)'; tw.w = T(3);
                else
                    error('SMTB:Twist:badarg', '3 or 6 element vector expected');
                end
            end
        end


        
        function Su = unit(S)
            %Twist2.unit Return a unit twist
            %
            % TW.unit() is a Twist object representing a unit aligned with the Twist
            % TW.
            if abs(S.w) > 10*eps
                % rotational twist
                Su = Twist2d( double(S) / norm(S.w) );
            else
                % prismatic twist
                Su = Twist2d( [unit(S.v); 0; 0; 0] );
            end
        end
        
        function x = S(tw)
            %Twist2.S Return the twist vector
            %
            % TW.S is the twist vector in se(2) as a vector (3x1).
            %
            % Notes::
            % - Sometimes referred to as the twist coordinate vector.
            x = [tw.w tw.v];
        end
        
        function x = double(tw)
            %Twist2.double Return the twist vector
            %
            % double(TW) is the twist vector in se(2)  as a vector (3x1). If 
            % TW is a vector (1xN) of Twists the result is a matrix (3xN) with
            % one column per twist.
            %
            % Notes::
            % - Sometimes referred to as the twist coordinate vector.
            x = [tw.v; tw.w];
        end
        
%         function x = skewa(tw)
%             %Twist2.skewa Return the twist matrix
%             %
%             % TW.se is the twist matrix in se(2) which is an augmented
%             % skew-symmetric matrix (3x3).
%             %
%             x = vec2skewa(tw.S);
%         end
        
        
        function c = mtimes(a, b)
            %Twist.mtimes Multiply twist by twist or scalar
            %
            % TW1 * TW2 is a new Twist representing the composition of twists TW1 and
            % TW2.
            %
            % TW * T is an SE2 that is the composition of the twist TW and the
            % homogeneous transformation object T.
            %
            % TW * S with its twist coordinates scaled by scalar S.
            %
            % TW * T compounds a twist with an SE2/3 transformation
            %
            
            if isa(a, 'Twist2d')
                if isa(b, 'Twist2d')
                    % twist composition
                    c = Twist2d( a.exp * b.exp);
                elseif length(a.v) == 2 && ishomog2(b)
                    % compose a twist with SE2, result is an SE2
                    c = se2(a.tform * double(b));
                else
                    error('SMTB:Twist', 'twist * SEn, operands don''t conform');
                end
            elseif isreal(a) && isa(b, 'Twist2')
                c = Twist2d(a * b.S);
            elseif isa(a, 'Twist2') && isreal(b)
                c = Twist2d(a.S * b);
            else
                error('SMTB:Twist: incorrect operand types for * operator')
            end
        end
        
        function x = exp(tw, varargin)
            %Twist2.exp Convert twist to homogeneous transformation
            %
            % TW.exp is the homogeneous transformation equivalent to the twist (SE2).
            %
            % TW.exp(THETA) as above but with a rotation of THETA about the twist.
            %
            % Notes::
            % - For the second form the twist must, if rotational, have a unit rotational component.
            %
            % See also Twist.T, trexp, trexp2.
            opt.deg = false;
            [opt,args] = tb_optparse(opt, varargin);
            
            if opt.deg && all(tw.w == 0)
                warning('Twist: using degree mode for a prismatic twist');
            end
            
            if ~isempty(args)
                theta = args{1};
                
                if opt.deg
                    theta = theta * pi/180;
                end
            else
                theta = 1;
            end
            
            ntheta = length(theta);
            assert(length(tw) == ntheta || length(tw) == 1, 'Twist:exp:badarg', 'length of twist vector must be 1 or length of theta vector')
            x(ntheta) = se2;
            if length(tw) == ntheta
                for i=1:ntheta
                    x(i) = se2(expm( vec2skewa(tw(i).S * theta(i)) ));
                end
            else
                for i=1:ntheta
                    x(i) = se2(expm( vec2skewa(tw.S * theta(i)) ));
                end
            end

        end

        function x = tform(tw, theta)
            if nargin < 2
                theta = 1;
            end
            x = expm(vec2skewa(tw.S * theta));
        end

        function x = compact(tw)
            x = tw.S';
        end
        
        function x = ad(tw)
            %Twist2.ad Logarithm of adjoint
            %
            % TW.ad is the logarithm of the adjoint matrix of the corresponding
            % homogeneous transformation.
            %
            % See also SE2.Ad.
            x = [ vec2skew(tw.w) vec2skew(tw.v); zeros(3,3) vec2skew(tw.w) ];

            % TODO
        end
        
        function x = Ad(tw)
            %Twist2.Ad Adjoint
            %
            % TW.Ad is the adjoint matrix of the corresponding
            % homogeneous transformation.
            %
            % See also SE3.Ad.
            x = tw.SE.Ad;
        end
        
        
        function out = se(tw, varargin)
            %Twist.se Convert twist to se2 object
            %
            % TW.se is an se2 object representing the homogeneous transformation equivalent to the twist.
            %
            % See also Twist.T, se2.
            out = se2( tw.T(varargin{:}) );

        end
        
        function x = T(tw, varargin)
            %Twist2.T Convert twist to homogeneous transformation
            %
            % TW.T is the homogeneous transformation equivalent to the twist (3x3).
            %
            % TW.T(THETA) as above but with a rotation of THETA about the twist.
            %
            % Notes::
            % - For the second form the twist must, if rotational, have a unit rotational component.
            %
            % See also Twist2.exp, trexp2, trinterp2.
            x = double( tw.exp(varargin{:}) );
        end
        
        
        function out = prod(obj)
            %Twist2.prod Compound array of twists
            %
            % TW.prod is a twist representing the product (composition) of the
            % successive elements of TW (1xN), an array of Twists.
            %
            %
            % See also RTBPose.prod, Twist2.mtimes.
            out = obj(1);
            
            for i=2:length(obj)
                out = out * obj(i);
            end
        end
        
        function p = pole(tw)
            %Twist2.pole Point on the twist axis
            %
            % TW.pole is a point on the twist axis (2x1).
            %
            % Notes::
            % - For pure translation this point is at infinity.
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
            %Twist2.char Convert to string
            %
            % s = TW.char() is a string showing Twist parameters in a compact single line format.
            % If TW is a vector of Twist objects return a string with one line per Twist.
            %
            % See also Twist.display.
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
            %Twist.display Display parameters
            %
            % L.display() displays the twist parameters in compact single line format.  If L is a
            % vector of Twist objects displays one line per element.
            %
            % Notes::
            % - This method is invoked implicitly at the command line when the result
            %   of an expression is a Twist object and the command has no trailing
            %   semicolon.
            %
            % See also Twist.char.
            loose = strcmp( get(0, 'FormatSpacing'), 'loose'); %#ok<GETFSP>
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            disp( char(tw) );
        end % display()
        
    end

    methods(Static)
        function tw = UnitRevolute(C)
            tw = Twist2d('R', C);
        end

        function tw = UnitPrismatic(a)
            tw = Twist2d('P', a);
        end
    end
end
