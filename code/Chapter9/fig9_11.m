% gravity load

vloop_test

set_param('vloop_test/vloop', 'Ki', '0');
set_param('vloop_test/tau_d', 'Value', '0');
set_param('vloop_test/tau_d', 'Value', '40/107.815');

r = sim('vloop_test');
tout = r.find('t'); yout = r.find('y');

clf
oplot(tout, yout(:,1:2))
ylabel('$\omega$ (rad/s)', 'interpreter', 'latex'); 
l = legend('actual', 'demand');
set(l, 'FontSize', 12)

xaxis(0.6);

rvcprint('thicken', 1.5)