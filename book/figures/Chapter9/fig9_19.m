close all; bdclose all; clear;

sl_zerotorque;
r = sim("sl_zerotorque");

pose1 = 15;
pose2 = 26;

%% Subfigure (a) - Joint plots
t = r.find("tout");
q = r.find("yout");
figure;
plot(t, q(:,1:3)); 

% Mark the 2 poses on the chart
hold on;
plot([t(pose1) t(pose1)], ylim, LineStyle="--", LineWidth=1/2, Color="black")
plot([t(pose2) t(pose2)], ylim, LineStyle=":", LineWidth=1/2, Color="black")

xlabel("Time (s)")
ylabel('q (rad)');
legend("q_1", "q_2", "q_3", "q in (b)", "q in (c)", Location="southwest");
grid on
rvcprint("painters", thicken=1.5, subfig="_a")

%% Subfigure (b) - Pose 1
figure;
ur5.show(q(pose1,:));

view(135, 8)
set(gca,"CameraViewAngle", 1.833)
set(gcf, "Position", [1682         662         330         420])
set(gca,"CameraPosition", [18.2916   18.0846    3.6490])
set(gca,"CameraTarget", [0.0992   -0.1078    0.0332])
rvcprint("opengl", "nogrid", subfig="_b")

%% Subfigure (c) - Pose 2
figure;
ur5.show(q(pose2,:));
view(135, 8)
set(gca,"CameraViewAngle", 1.833)
set(gca,"CameraPosition", [18.1472   18.2889    3.4191])
set(gca,"CameraTarget", [-0.0452    0.0965   -0.1967])
set(gcf, "Position", [1682         662         330         420])

rvcprint("opengl", "nogrid", subfig="_c")