bdclose all; close all; clear;
r = sim("sl_pursuit");

% Create first figure for x-y plot
figure;
yout = r.get("y");
plot(yout(:,1), yout(:,2)); grid; xyzlabel
hold on; 
viscircles([0,0], 1, "Color", "k", "LineWidth", 1)
plot(path(:,1), path(:,2), "r--", "LineWidth", 2)
xlabel("x");
ylabel("y");
axis equal;

rvcprint("subfig", "_a")

% Create second figure for speed over time
figure;
t = r.get("t");
v = yout(:,6);
plot(t, v); xlabel("Time"); ylabel("Speed"); grid on
rvcprint("subfig", "_b", "thicken", 1.5)
