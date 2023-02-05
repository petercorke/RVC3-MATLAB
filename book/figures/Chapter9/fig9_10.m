bdclose all; close all; clear;

% Vary the inertia and see effect on velocity controller
sl_vloop_test

set_param("sl_vloop_test/tau_d", "Value", "0");
set_param("sl_vloop_test/Joint vloop", "Ki", "0");
set_param("sl_vloop_test/tau_ff", "Value", "0");

set_param("sl_vloop_test/Joint vloop", "J", "200e-6");

r0 = sim("sl_vloop_test");
tout = r0.find("t"); y0 = r0.find("y"); %#ok<NASGU> 

% Minimum link inertia
set_param("sl_vloop_test/Joint vloop", "J", "315e-6");
r1 = sim("sl_vloop_test");
tout = r1.find("t"); y1 = r1.find("y"); %#ok<NASGU> 

% Mean link inertia
set_param("sl_vloop_test/Joint vloop", "J", "382e-6");
r2 = sim("sl_vloop_test");
tout = r2.find("t"); y2 = r2.find("y"); %#ok<NASGU> 

% Maximum link inertia
set_param("sl_vloop_test/Joint vloop", "J", "448e-6");
r3 = sim("sl_vloop_test");
tout = r3.find("t"); y3 = r3.find("y");

figure;
plot(tout, [y0(:,1) y1(:,1) y2(:,1) y3(:,1)])
xlim([0.29 0.32]);
ylim([47 51]);
xlabel("Time (s)")
ylabel("$\omega$ (rad/s)", "interpreter", "latex");
l = legend("no link inertia", "min link inertia", "mean link inertia", "max link inertia");
l.FontSize = 10;

rvcprint("painters", thicken=1.5)