bdclose all; close all; clear;

sl_ploop_test

set_param("sl_ploop_test/Joint ploop/Kff", "Gain", "0");
r = sim("sl_ploop_test");

%% Subfigure (a) - P control only
figure
tout = r.find("t"); yout = r.find("y");
plot(tout, yout(:,1:2)); 
xlabel("Time (s)");
ylabel("q (rad)"); 
ylim([-0.2 1]);
l = legend("actual", "demand", Location="SouthEast");
l.FontSize = 10;

rvcprint("painters", subfig="_a", thicken=1.5)

set_param("sl_ploop_test/Joint ploop/Kff", "Gain", "1*G");
r = sim("sl_ploop_test");
tout = r.find("t"); yout = r.find("y");

%% Subfigure (b) - P control with feedforward
figure
plot(tout, yout(:,1:2)); 
xlabel("Time (s)");
ylabel("q (rad)"); 
ylim([-0.2 1]);
l = legend("actual", "demand", Location="SouthEast");
l.FontSize = 10;

rvcprint("painters", subfig="_b", thicken=1.5)
