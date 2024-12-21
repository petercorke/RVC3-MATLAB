% target line


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
L = [1 -2 4];
clf
hold on
xlabel("x");
ylabel("y");
x = [0 10];
y = -(L(1)*x+L(3))/L(2);
plot(x, y, 'k--');
a = gca;
grid on

xc = 4; yc = 4;
N = 4;
radius = 3;

axes(a)

for i=1:N
    th = (i-1)*2*pi/N;
    x0 = [xc+radius*cos(th) yc+radius*sin(th) th+pi/2];
    
    r = sim('sl_driveline');
    y = r.find('y');
    lineHandle = plot(y(:,1), y(:,2));

    plotvehicle(x0, edgecolor=lineHandle.Color);
end

axis equal
axis([0 10 0 10]);

