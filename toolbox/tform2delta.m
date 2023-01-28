%tform2delta Convert SE(3) homogeneous transform to differential motion
%
% D = tform2delta(T0, T1) is the differential motion (6x1) corresponding to
% infinitessimal motion (in the T0 frame) from pose T0 to T1 which are homogeneous
% transformations (4x4) or SE3 objects.
%
% The vector D=(dRx, dRy, dRz, dx, dy, dz, ) represents infinitessimal translation
% and rotation, and is an approximation to the instantaneous spatial velocity
% multiplied by time step.
%
% D = tform2delta(T) as above but the motion is from the world frame to the SE3
% pose T.
%
% D = tform2delta(___, "fliptr") will flip the order of the
% translational and rotational components in D. When fliptr is set to true,
% the output vector will be D=(dRx, dRy, dRz, dx, dy, dz)
%
% Notes::
% - D is only an approximation to the motion T, and assumes
%   that T0 ~ T1 or T ~ eye(4,4).
% - Can be considered as an approximation to the effect of spatial velocity over a
%   a time interval, average spatial velocity multiplied by time.
%
% Reference::
% - Robotics, Vision & Control: Second Edition, P. Corke, Springer 2016; p67.
%
% See also delta2tform, SKEW, SE3.todelta.

%## 3d differential homogeneous

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

function delta = tform2delta(A, varargin)

fliptr = true;

% handle arguments, convert all to 4x4 matrices
if nargin > 0
    if isa(A, 'se3')
        T1 = A.tform;
    elseif all(size(A) == 4)
        T1 = A;
    else
        error('SMTB:tform2delta:badarg', 'T1 should be a homogeneous transformation');
    end
    T0 = eye(4,4);
end

if nargin == 2
    if isnumeric(varargin{1}) || isa(varargin{1}, "se3")
        % SYNTAX: tform2delta(T0, T1)
        B = varargin{1};

        T0 = T1;
        if isa(B, 'se3')
            T1 = B.tform;
        elseif all(size(B) == 4)
            T1 = B;
        else
            error('SMTB:tform2delta:badarg', 'T0 should be a homogeneous transformation');
        end
    else
        % SYNTAX: tform2delta(T0, "fliptr")
        flip = convertStringsToChars(varargin{1});
        if strcmp(flip,'fliptr')
            fliptr = true;
        end
    end
end

if nargin == 3
    % SYNTAX: tform2delta(T0, T1, "fliptr")
    B = varargin{1};
    T0 = T1;
    if isa(B, 'se3')
        T1 = B.tform;
    elseif all(size(B) == 4)
        T1 = B;
    else
        error('SMTB:tform2delta:badarg', 'T0 should be a homogeneous transformation');
    end

    flip = convertStringsToChars(varargin{2});
    if strcmp(flip,'fliptr')
        fliptr = true;
    end
end

% compute incremental transformation from T0 to T1 in the T0 frame
TD = inv(T0) * T1; %#ok<MINV>

% build the delta vector
translVec = tform2trvec(TD);
rotVec = skew2vec(tform2rotm(TD) - eye(3,3));
if fliptr
    % Put rotation first
    delta = [rotVec translVec];
else
    % Put translation first
    delta = [translVec rotVec];
end


%    R0 = tform2rotm(T0); R1 = tform2rotm(T1);
%    % in world frame
%    %[th,vec] = tr2angvec(R1*R0');
%    dR = vex(R1*R0');
%    %delta = [ (T1(1:3,4)-T0(1:3,4)); th*vec' ];
%    delta = [ (T1(1:3,4)-T0(1:3,4)); dR];

% same as above but more complex
%    delta = [	T1(1:3,4)-T0(1:3,4);
%        0.5*(	cross(T0(1:3,1), T1(1:3,1)) + ...
%            cross(T0(1:3,2), T1(1:3,2)) + ...
%            cross(T0(1:3,3), T1(1:3,3)) ...
%        )];
end

