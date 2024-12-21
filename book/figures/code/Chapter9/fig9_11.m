bdclose all; close all; clear;

% gravity load
sl_vloop_test

set_param("sl_vloop_test/Joint vloop", "Ki", "0");
set_param("sl_vloop_test/tau_d", "Value", "0");

% Add torque disturbance of 20 Nm
set_param("sl_vloop_test/tau_d", "Value", "20/107.815");

r = sim("sl_vloop_test");
tout = r.find("t"); yout = r.find("y");

figure;
plot(tout, yout(:,1:2))
xlabel("Time (s)")
ylabel("$\omega$ (rad/s)", "interpreter", "latex"); 
l = legend("actual", "demand");
l.FontSize = 10;

xlim([0 0.6]);
ylim([-2 50]);
yticks([0 10 20 30 40 50])

rvcprint("painters", thicken=1.5)