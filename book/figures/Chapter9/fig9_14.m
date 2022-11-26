ploop_test

set_param('ploop_test/ploop/Kff', 'Gain', '0');
r = sim('ploop_test');

figure
tout = r.find('t'); yout = r.find('y');oplot(tout, yout(:,[1:2])); ylabel('q (rad)'); 
l = legend('actual', 'demand', 'Location', 'SouthEast');
set(l, 'FontSize', 12)

rvcprint('subfig', 'a', 'thicken', 1.5)

set_param('ploop_test/ploop/Kff', 'Gain', '107.815');
r = sim('ploop_test');
tout = r.find('t'); yout = r.find('y');
figure
oplot(tout, yout(:,[1:2])); ylabel('q (rad)'); 
l = legend('actual', 'demand', 'Location', 'SouthEast');
set(l, 'FontSize', 12)

rvcprint('subfig', 'b', 'thicken', 1.5)