% gravity load + integral action
vloop_test

set_param('vloop_test/vloop', 'Ki', '0');
set_param('vloop_test/tau_d', 'Value', '0');
set_param('vloop_test/tau_d', 'Value', '40/107.815');
set_param('vloop_test/vloop', 'Ki', '2');

r = sim('vloop_test');
tout = r.find('t'); yout = r.find('y');

figure
subplot(211)
oplot(tout, yout(:,1:2))
ylabel('$\omega$ (rad/s)', 'interpreter', 'latex'); 
l = legend('actual', 'demand', 'Location', 'northwest');
set(l, 'FontSize', 12)

xaxis(0.6);

subplot(212)
oplot(tout, yout(:,4))
ylabel('Integral value');
xaxis(0.6);

rvcprint('thicken', 1.5)
