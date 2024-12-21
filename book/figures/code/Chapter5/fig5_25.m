close all; clear;

% Set start and goal pose
qs = [0 0 pi/2];
qg = [1 0 pi/2];

rs = reedsSheppConnection(MinTurningRadius=1);
[paths, length] = rs.connect(qs,qg);
p = paths{1};

%% Figure a - Default Reeds-Shepp path
figure;
p.show(HeadingLength=0.15);
hold on

% Make reverse path dashed for better readability
pathLineHandles = findall(groot, Type="Line", Tag="pathPlot");
pathLineHandles(1).LineStyle = "--";

% Make start and goal more prominent
plotStartGoal(qs, qg, 14, 18);
legend(["Forward path", "Reverse path", "", "", "Transition point", "Heading", "", "", "", "", "", "", "", "", "", "Start pose", "Goal pose"])

grid on;
axis equal;
xlabel("x")
ylabel("y")
rvcprint("painters", subfig="_a");

%% Figure b - Reeds-Shepp with higher reverse cost
rs.ReverseCost = 3;
[paths, cost] = rs.connect(qs,qg);
p = paths{1}; 

figure;
p.show(HeadingLength=0.15);
hold on

% Make reverse path dashed for better readability
pathLineHandles = findall(groot, Type="Line", Tag="pathPlot");
pathLineHandles(1).LineStyle = "--";

% Make start and goal more prominent
plotStartGoal(qs, qg, 14, 18);
legend(["Forward path", "Reverse path", "", "", "Transition point", "Heading", "", "", "", "", "", "", "", "", "", "Start pose", "Goal pose"])

grid on;
axis equal;
legend off;
xlabel("x")
ylabel("y")
rvcprint("painters", subfig="_b");
