function walking(varargin)

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

opt.niterations = 500;
opt.movie = [];

opt = tb_optparse(opt, varargin);

L1 = 0.5; L2 = 0.5;

disp("create leg model");

% create the leg links based on ETS
e = ETS3.Rz("q1") * ETS3.Rx("q2") * ETS3.Ty(-L1) * ETS3.Rx("q3") * ETS3.Tz(-L2);

% now create a robot to represent a single leg
leg = ets2rbt(e);

% define the key parameters of the gait trajectory, walking in the
% x-direction
xf = 0.25; xb = -xf;   % forward and backward limits for foot on ground
y = -0.25;             % distance of foot from body along y-axis
zu = -0.1; zd = -0.25; % height of foot when up and down

% define the rectangular path taken by the foot
segments = [ xf, y, zd; ...
    xb, y, zd; ...
    xb, y, zu; ...
    xf, y, zu];

% build the gait. the points are:
%   1 start of walking stroke
%   2 end of walking stroke
%   3 end of foot raise
%   4 foot raised and forward
%
% The segments times are :
%   1->2  3s
%   2->3  0.25s
%   3->4  0.5s
%   4->1  0.25s
%
% A total of 4s, of which 3s is walking and 1s is reset.  At 0.01s sample
% time this is exactly 400 steps long.
%
% We use a finite acceleration time to get a nice smooth path, which means
% that the foot never actually goes through any of these points.  This
% makes setting the initial robot pose and velocity difficult.
%
% Intead we create a longer cyclic path: 1, 2, 3, 4, 1, 2, 3, 4. The
% first 1->2 segment includes the initial ramp up, and the final 3->4
% has the slow down.  However the middle 2->3->4->1 is smooth cyclic
% motion so we "cut it out" and use it.
disp("create trajectory");

sampleTime = 0.05;

segments = [segments; segments];
tseg = [1 3 0.25 0.5 0.25 3 0.25 0.5];    
x = mstraj(segments, [], tseg, segments(1,:), sampleTime, 0.1);

% pull out the cycle
disp("inverse kinematics (this will take a while)...");
xcycle = x(1/sampleTime:5/sampleTime,:);
qcycle = ikineTrajNum(leg, se3(trvec2tform(xcycle)), "link5", weights=[0 0 0 1 1 1]);

% dimensions of the robot's rectangular body, width and height, the legs
% are at each corner.
W = 0.5; L = 1;

disp("animate");

% a bit of optimization.  We use a lot of plotting options to
% make the animation fast.
showopt = {"PreservePlot", false, "FastUpdate", true, "Collisions", "on"};

% create 4 leg robots.  Each is a clone of the leg robot we built above,
% has a unique name, and a base transform to represent it's position
% on the body of the walking robot.

Tflip = se3(tformrz(pi));
legs = [...
    rbtTform(leg, se3(eye(3), [L/2, W/2, 0]) * Tflip), ...
    rbtTform(leg, se3(eye(3), [-L/2, W/2, 0]) * Tflip), ...
    rbtTform(leg, se3(eye(3), [L/2, -W/2, 0])), ...
    rbtTform(leg, se3(eye(3), [-L/2, -W/2, 0]))];

% create the visualization
clf
for i=1:4
    legs(i).show(showopt{:});
    hold on
end
xlim([-1 1])
ylim([-1 1])
zlim([-0.25 0.5])

% draw the robot's body with height H. Specify vertices and faces for the
% patch object.
H = 0.1;
vert = [-L/2 -W/2 -H/2;L/2 -W/2 -H/2;L/2 W/2 -H/2;-L/2 W/2 -H/2; ...
    -L/2 -W/2 H/2;L/2 -W/2 H/2;L/2 W/2 H/2;-L/2 W/2 H/2];
fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
patch(Vertices=vert, Faces=fac, ...
    FaceColor="r", FaceAlpha=0.5)
% instantiate each robot in the axes
hold off

% walk!
A = Animate(opt.movie);

r = rateControl(20);
for i=1:opt.niterations
    legs(1).show(gait(qcycle, i, 0,   false), showopt{:});
    legs(2).show(gait(qcycle, i, 100, false), showopt{:});
    legs(3).show(gait(qcycle, i, 200, true), showopt{:});
    legs(4).show(gait(qcycle, i, 300, true), showopt{:});
    r.waitfor;
    A.add();
end

end
