close all; clear;

% Set start and goal pose
qs = [0 0 pi/2];
qg = [1 0 pi/2];

rs = reedsSheppConnection(MinTurningRadius=1);
[paths, length] = rs.connect(qs,qg,PathSegments="all");
validPaths = find(~isnan(length));

figure;
hold on;
for pathNum = validPaths'
    paths{pathNum}.show(HeadingLength=0.15);
end

hold on

% Make reverse path dashed for better readability
pathLineHandles = findall(groot, Type="Line", Tag="pathPlot");
reverseLineHandles = findall(pathLineHandles, Color=[1 0 1]);
arrayfun(@(lh) setfield(lh, "LineStyle", "--"), reverseLineHandles)

% Make start and goal more prominent
plotStartGoal(qs, qg, 14, 18);
legend(["Forward path", "Reverse path", "", "", "Transition point", "Heading", ...
    repmat("", 1, 106), "Start pose", "Goal pose"], Location="eastoutside")

grid on;
xlabel("x")
ylabel("y")
axis equal;
xlim([-1 2]);
rvcprint("painters");
