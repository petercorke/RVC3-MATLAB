close all; clear;

figure;
qs = [0 0 pi/2];
qg = [1 0 pi/2];

% Calculate Dubins connection and show standard plot
dc = dubinsConnection(MinTurningRadius=1);
ps = dc.connect(qs, qg);
seg = ps{1};

%% Figure (a) - 2D visualization of Dubins motion
ax = seg.show("Positions", {}, "Headings", ["start", "goal"], "HeadingLength", 0.3);
axis equal
grid on
hold on
xlabel("x", "FontSize",18)
ylabel("y", "FontSize",18)
%legend off

% Show circle and star at beginning and end
%plot([qs(1) qg(1)], [qs(2) qg(2)], "-b", "LineWidth", 1)
plot(qs(1), qs(2), "ob", "MarkerSize", 15, "MarkerFaceColor", "white")
plot(qg(1), qg(2), "pb", "MarkerSize", 20, "MarkerFaceColor", "white")

% Draw heading lines in blue
lines = ax.findobj("Tag", "headingLine");
for l = lines'
    l.Color = "b";
end

% Draw non-holonomic lines
% The interpolation contains the transition poses, which makes for an
% odd visualization. Exclude transition points from interpolated list.
interpPts = seg.interpolate(linspace(0, seg.Length, 15));
transitionPts = seg.interpolate;
interpPts = setdiff(interpPts, transitionPts, "rows", "stable");

d = 0.2;
for i = 1:size(interpPts,1)
    T = se2(rotm2d(interpPts(i,3)), [interpPts(i,1) interpPts(i,2)]);
    p1 = T.transform([0 d]);
    p2 = T.transform([0 -d]);
    plot([p1(1) p2(1)], [p1(2) p2(2)], "k-.", "LineWidth", 2);
end

% Manually adjust the legand position
l = legend(["Vehicle path", "", "", "", "Vehicle orientation", "", "", "", ...
    "Start pose", "Goal pose", sprintf('Impossible motion\ndirection')], ...
    "Location","northeast");
l.Position(1) = l.Position(1) + 0.075;

% f = gcf;


rvcprint("nocmyk", subfig="_a")


%% Figure (b) - 3D visualization of configuration space
figure;
plotPts = seg.interpolate(linspace(0, seg.Length, 100));
x = plotPts(:,1);
y = plotPts(:,2);
th = wrapToPi(plotPts(:,3));
plot3(x, y, th, "r", "LineWidth", 2)

axis equal
grid on
hold on
daspect([1 1 2])
view(-11.7084,46.2)

xlabel("x", "FontSize",16)
ylabel("y", "FontSize",16)
zlabel("\theta", "FontSize",18)

% Show circle and star at beginning and end
% Move the marker slightly negative in the y direction to ensure that it
% is in front of the red plot line
plot3(qs(1), qs(2)-0.01, qs(3), "ob", "MarkerSize", 15, "MarkerFaceColor", "white")
plot3(qg(1), qg(2)-0.01, qg(3), "pb", "MarkerSize", 20, "MarkerFaceColor", "white")

d = 0.2;
for i = 1:size(interpPts,1)
    T = se2(rotm2d(interpPts(i,3)), [interpPts(i,1) interpPts(i,2)]);
    p1 = T.transform([0 d]);
    p2 = T.transform([0 -d]);
    % Add 0.05 to angles, so that the black lines are slightly in front 
    % of red plot line
    th = wrapToPi(interpPts(i,3))+0.05;
    plot3([p1(1) p2(1)], [p1(2) p2(2)], [th th], ...
        "k-.", "LineWidth", 2);
end

rvcprint("nocmyk", "painters", subfig="_b")
