% gravity load + feedforward
vloop_test

set_param('vloop_test/vloop', 'Ki', '0');
set_param('vloop_test/tau_d', 'Value', '0');
set_param('vloop_test/vloop', 'J', '372e-6');
set_param('vloop_test/tau_d', 'Value', '40/107.815');
set_param('vloop_test/vloop', 'Ki', '0');
set_param('vloop_test/tau_ff', 'Value', '35/107.815');

r = sim('vloop_test');
tout = r.find('t'); yout = r.find('y');

figure
oplot(tout, yout(:,1:2))
ylabel('$\omega$ (rad/s)', 'interpreter', 'latex'); 
l = legend('actual', 'demand', 'Location', 'northwest');
set(l, 'FontSize', 12)

rvcprint('thicken', 1.5)
