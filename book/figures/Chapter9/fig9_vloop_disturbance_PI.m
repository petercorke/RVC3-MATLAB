bdclose all; close all; clear;

% gravity load + integral action
sl_vloop_test

set_param("sl_vloop_test/tau_d", "Value", "40/107.815");
set_param("sl_vloop_test/Joint vloop", "Ki", "2");

r = sim("sl_vloop_test");
tout = r.find("t"); yout = r.find("y");

figure
subplot(211)
plot(tout, yout(:,1:2))
% xlabel("Time (s)")
ylabel("$\omega$ (rad/s)", interpreter="latex"); 
l = legend("actual", "demand", Location="northwest");
l.FontSize = 10;
grid on;
xlim([0 0.6]);

subplot(212)
plot(tout, yout(:,4))
xlabel("Time (s)");
ylabel("Integral value");
grid on;
xlim([0 0.6]);

rvcprint("painters", thicken=1.5)
