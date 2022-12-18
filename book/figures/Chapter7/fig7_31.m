close all; clear;

xf = 0.25; xb = -xf;  y = -0.25; zu = -0.1; zd = -0.25;
via = [ xf, y, zd; ...
    xb, y, zd; ...
    xb, y, zu; ...
    xf, y, zu; ...
    xf, y, zd];

p = mstraj(via, [], [3, 0.25, 0.5, 0.25], [], 0.01, 0.1);

%% Subfigure (a)
figure;
stance = 1:300; reset = 300:400;
plot3(p(stance,1), stance*0.01, p(stance,3), "b")
hold on
plot3(p(reset,1), reset*0.01, p(reset,3), "r")

% set(gca, "Zdir", "reverse")
xlabel("x");
zlabel("z");
ylabel("Time (s)")
grid
view(72, 18)
%zlim([0.02, 0.05]);

l = legend("Stance Phase", "Reset Phase");
%l.FontSize = 7;
l.Position = [0.2 0.7 0.1 0.1];


rvcprint("painters", subfig="_a", thicken=2.5, figy=100)

%% Subfigure (b)
x = p(:,1);

lineStyles = ["-", "--", ":", "-."];

figure;
hold on
for i=1:4
    plot((1:400)*0.01, x( mod((1:400)+(i-1)*100, 400)+1), LineStyle=lineStyles(i));
end
grid
xlabel("Time (s)")
ylabel("Foot x-coordinate (m)")
l = legend("Foot 1", "Foot 2", "Foot 3", "Foot 4");
l.FontSize = 7;
l.Position = [0.8 0.2 0.1 0.1];
ylim([-0.3 0.3]);

rvcprint("painters", subfig="_b", thicken=1.5, figy=100)
