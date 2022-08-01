close all; clear;

sl_vloop_test

set_param("sl_vloop_test/Joint vloop", "Ki", "0");
set_param("sl_vloop_test/tau_d", "Value", "0");

r = sim("sl_vloop_test");
tout = r.find("t"); yout = r.find("y");

%% Subfigure (a) - Velocity tracking
figure
subplot(211)
plot(tout, yout(:,1:2))
ylabel("$\omega$ (rad/s)", interpreter="latex"); 
l = legend("actual", "demand", Location="northwest");
l.FontSize = 10;
grid on;
xlim([0 0.6]);

subplot(212)
plot(tout, yout(:,3));
grid on
xlim([0 0.6]);
ylim([-0.2 0.2])
xlabel("Time (s)");
ylabel("Torque (Nm)")

rvcprint("painters", subfig="_a", thicken=1.5)

%% Subfigure (b) - Velocity tracking closeup
figure
plot(tout, yout(:,1:2))
xlim([0.29 0.33]);
ylim([47 51]);
l = legend("actual", "demand");
l.FontSize = 10;
xlabel("Time (s)");
ylabel("$\omega$ (rad/s)", interpreter="latex"); 

rvcprint("painters", subfig="_b", thicken=1.5)