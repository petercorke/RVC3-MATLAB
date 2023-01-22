close all; clear;

% Set start and goal pose
qs = [0 0 pi/2];
qg = [1 0 pi/2];

dubins = dubinsConnection(MinTurningRadius=1);
[paths, length] = dubins.connect(qs,qg);
p = paths{1};

%% Figure a - Continuous Dubins path
figure;
p.show(HeadingLength=0.25, Positions={});
hold on

plotStartGoal(qs, qg, 14, 18);
legend(["Path", "", "", "Transition point", "Heading", "", "", "", "", "", "", "", "Start pose", "Goal pose"])

grid on;
axis equal;
xlabel("x")
ylabel("y")
rvcprint("painters", subfig="_a");

%% Figure b - Sampled Dubins path
figure;
p.show(HeadingLength=0.25, Headings={"start", "goal"}, Positions={});
hold on;
plotStartGoal(qs, qg, 14, 18);

grid on
xlabel("x")
ylabel("y")
axis equal

% Plot the interpolated path points
hold on
samples = p.interpolate(0:0.5:p.Length);

% Remove transition points
samples = setdiff(samples, p.interpolate, "rows");
scatter(samples(1:end,1), samples(1:end,2), 35, "black", "filled")
for i = 1:size(samples,1)
    x = samples(i,1);
    y = samples(i,2);
    theta = samples(i,3);
    vertices = nav.algs.internal.MotionModelShowPath.getHeadingLineCoordinates(gca, ...
        x, y, theta, 0.3);
    plot(vertices(1,:),vertices(2,:),'Color','black','LineWidth', 2);
end
legend(["Path", "", "", "Interpolated pose", "Heading", "", "", "", "Start pose", "Goal pose"])

rvcprint("painters", subfig="_b");
