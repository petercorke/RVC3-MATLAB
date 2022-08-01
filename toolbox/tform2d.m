%TFORM2D SE(2) transformation matrix
%
% T = TFORM2D([X,Y,THETA]) is a homogeneous transformation (3x3) representing a rotation 
% of THETA radians and a translation of [X,Y].
%
% T = TFORM2D(X,Y,THETA) is a homogeneous transformation (3x3) representing a rotation 
% of THETA radians and a translation of [X,Y].
%
% T = TFORM2D(...,"deg") as above but THETA is in degrees.
%
% See also rot2, transl2, ishomog2, trplot2, trotx, troty, trotz, SE2.

%## 2d homogeneous rotation

function T = tform2d(varargin)
    narginchk(1,4);
    if nargin == 1 
        % Syntax: TFORM2D([X,Y,THETA])
        xyt = varargin{1};
        x = xyt(1);
        y = xyt(2);
        theta = xyt(3);

        T = [rotm2d(theta) [x y]'; 0 0 1];
    elseif nargin == 2
        % Syntax: TFORM2D([X,Y,THETA], "deg")
        xyt = varargin{1};
        theta = xyt(3);
        x = xyt(1);
        y = xyt(2);
        T = [rotm2d(theta, varargin{2}) [x y]'; 0 0 1];
    elseif nargin == 3
        % Syntax: TFORM2D(X,Y,THETA)
        x = varargin{1};
        y = varargin{2};
        theta = varargin{3};
        T = [rotm2d(theta) [x y]'; 0 0 1];
    elseif nargin == 4
        % Syntax: TFORM2D(X,Y,THETA, "deg")
        x = varargin{1};
        y = varargin{2};
        theta = varargin{3};        
        T = [rotm2d(theta, varargin{4}) [x y]'; 0 0 1];
    end

end