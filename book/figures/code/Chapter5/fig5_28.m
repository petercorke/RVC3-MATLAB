close all; clear;

%% lattice after 2 iter

lp = LatticePlanner(iterations=2);
lp.plan;
lp.plot;
xlim([-1,3]);
ylim([-3,3]);
ylim([-2,4]);

hold on

% add shadow on the ground
z = get(gca, 'ZLim'); z = z(1);
for l = get(gca, 'Children')'
    xd = get(l, 'XData'); yd = get(l, 'YData');
    plot3(xd, yd, 0*xd+z, 'Color', 0.8*[1 1 1]);
end
view(-57.2, 17.2);

rvcprint("painters", thicken=1.5)
