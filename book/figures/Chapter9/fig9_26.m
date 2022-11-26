sl_sea

set_param('sl_sea/detect obstacle', 'const', '2');
r = sim('sl_sea');
t = r.find('t');
% y = x1 x1d x2 x2d u Fs
y = r.find('y');
figure
clf
oplot(t, y(:,[3,5,6]))
yaxis(-2, 2.5);
c = get(gca, 'Children');
set(c(2), 'LineStyle', '--')
l = legend('$x_2$', '$u$', '$F_s$');
set(l,'interpreter','latex', 'FontSize', 12)
ylabel('');

rvcprint('subfig', 'a', 'thicken', 1.5)

set_param('sl_sea/detect obstacle', 'const', '0.8');
r = sim('sl_sea');
t = r.find('t');
y = r.find('y');
clf
oplot(t, y(:,[3, 5, 6]))
yaxis(-2, 2.5);
c = get(gca, 'Children');
set(c(2), 'LineStyle', '--')
l = legend('$x_2$', '$u$', '$F_s$');
set(l,'interpreter','latex', 'FontSize', 12)
ylabel('');

rvcprint('subfig', 'b', 'thicken', 1.5)