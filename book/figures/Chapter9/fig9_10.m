% double the inertia
vloop_test

set_param('vloop_test/tau_d', 'Value', '0');
set_param('vloop_test/vloop', 'Ki', '0');
set_param('vloop_test/tau_ff', 'Value', '0');

set_param('vloop_test/vloop', 'J', '200e-6');
r0 = sim('vloop_test');
tout = r.find('t'); y0 = r0.find('y');

set_param('vloop_test/vloop', 'J', '515e-6');
r1 = sim('vloop_test');
tout = r.find('t'); y1 = r1.find('y');

set_param('vloop_test/vloop', 'J', '580e-6');
r2 = sim('vloop_test');
tout = r.find('t'); y2 = r2.find('y');

set_param('vloop_test/vloop', 'J', '648e-6');
r3 = sim('vloop_test');
tout = r.find('t'); y3 = r3.find('y');

figure
plot(tout, [y0(:,1) y1(:,1) y2(:,1) y3(:,1)])
xaxis(0.29, 0.32); yaxis(47, 51);
xlabel('Time (s)')

% clf
% oplot(tout, yout(:,1:2))
ylabel('$\omega$ (rad/s)', 'interpreter', 'latex');
l = legend('no link inertia', 'min link inertia', 'mean link inertia', 'max link inertia')
set(l, 'FontSize', 12)

% xaxis(0.6)
% 
rvcprint('thicken', 1.5)