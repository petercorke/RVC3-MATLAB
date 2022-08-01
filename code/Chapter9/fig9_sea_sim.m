close all; bdclose all; clear;
sl_sea

set_param("sl_sea/detect obstacle", "const", "2");
r = sim("sl_sea");
t = r.find("t");
% y = x1 x1d x2 x2d u Fs
y = r.find("y");

%% Subfigure (a) - No collision
figure
plot(t, y(:,3)); hold on;
plot(t, y(:,5), LineStyle="--");
plot(t, y(:,6), LineStyle=":");
ylim([-2, 2.5]);
l = legend("$x_2$", "$u$", "$F_s$");
l.Interpreter = "latex";
l.FontSize = 12;
ylabel("");
xlabel("Time (s)");

rvcprint("painters", subfig="_a", thicken=1.5)

%% Subfigure (b) - Collision
set_param("sl_sea/detect obstacle", "const", "0.8");
r = sim("sl_sea");
t = r.find("t");
y = r.find("y");

figure
plot(t, y(:,3)); hold on;
plot(t, y(:,5), LineStyle="--");
plot(t, y(:,6), LineStyle=":");
ylim([-2, 2.5]);
l = legend("$x_2$", "$u$", "$F_s$");
l.Interpreter = "latex";
l.FontSize = 12;
ylabel("");
xlabel("Time (s)");

rvcprint("painters", subfig="_b", thicken=1.5)
