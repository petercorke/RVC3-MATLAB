%delta2tform Convert differential motion  to a homogeneous transform
%
% T = delta2tform(D) is a homogeneous transform (4x4) representing differential
% translation and rotation. The vector D=(dx, dy, dz, dRx, dRy, dRz)
% represents an infinitessimal motion, and is an approximation to the spatial
% velocity multiplied by time.
%
% T = delta2tform(D, fliptr=true) will flip the expected order of the
% translational and rotational components in D. When fliptr is set to true,
% the input vector D is expected as D=(dRx, dRy, dRz, dx, dy, dz)
%
% See also tform2delta, SE3.delta.




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

function delta = delta2tform(d, varargin)

opt.fliptr = 1;
% Parse name-value pairs (if they are passed)
opt = tb_optparse(opt, varargin);

d = d(:);

if opt.fliptr
    delta = eye(4,4) + [vec2skew(d(1:3)) d(4:6); 0 0 0 0];
else
    delta = eye(4,4) + [vec2skew(d(4:6)) d(1:3); 0 0 0 0];
end

end