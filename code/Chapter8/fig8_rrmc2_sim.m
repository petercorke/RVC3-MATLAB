bdclose all
close all; clear;

sl_rrmc2
r = sim("sl_rrmc2");

circleCenter = se3(puma.getTransform(conf.qn, "link6")).trvec;

figure;
xyz = tform2trvec(T);

% Plot red reference circle (red dashed line)
figure;
plotcircle(circleCenter(1:2)', 0.05, 'r--', LineWidth=4);
hold on

% Draw actual path followed by end effector
plot(xyz(:,1), xyz(:,2), "k-", LineWidth=1.5);

axis equal
grid on
xlabel("x");
ylabel("y");

rvcprint("painters", figy=50)
