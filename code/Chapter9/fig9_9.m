vloop_test

set_param('vloop_test/vloop', 'Ki', '0');
set_param('vloop_test/tau_d', 'Value', '0');

r = sim('vloop_test');
tout = r.find('t'); yout = r.find('y');
figure
subplot(211)
oplot(tout, yout(:,1:2))
ylabel('$\omega$ (rad/s)', 'interpreter', 'latex'); 
l = legend('actual', 'demand');
set(l, 'FontSize', 12)
xaxis(0.6);
subplot(212)
plot(tout, yout(:,3));
grid on
xaxis(0.2, 0.4); 
xlabel('Time (s)');
ylabel('Torque (Nm)')
xaxis(0.6);

rvcprint('subfig', 'a', 'thicken', 1.5)

clf
oplot(tout, yout(:,1:2))
xaxis(0.29, 0.33); yaxis(47, 51);
l = legend('actual', 'demand'); 
set(l, 'FontSize', 12)
ylabel('$\omega$ (rad/s)', 'interpreter', 'latex');

rvcprint('subfig', 'b', 'thicken', 1.5)