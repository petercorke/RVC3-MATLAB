% T0 = SE3([0.4, 0.2, 0]) *     SE3.RPY(-1, 1, 1);
% T1 = SE3([-0.4, -0.2, 0.3]) * SE3.RPY(-2, 2, -1);

% T0 = SE3([0.4, 0.2, 0]) *     SE3.RPY(0, -1, 0);
% T1 = SE3([-0.4, -0.2, 0.3]) * SE3.RPY(1, -2, -1);

T0 = se3(eul2rotm([0, -1, 0]), [0.4 0.2 0]);
T1 = se3(eul2rotm([0.5, -2, -0.5]), [-0.4 -0.2 0.3]);

tpts = [0 1]; tvec = linspace(tpts(1), tpts(2), 50);
Ts = transformtraj(T0.tform, T1.tform, tpts, tvec);
Ts = se3(Ts)

% T0 is different compared to second edition, quaternion interpolator
% always takes shortest path
% Ts = interp(T0, T1, lspb(0, 1, 50));
% whos Ts
% Ts(1)

% Ts.animate()
P = Ts.trvec();
whos P
t = [0:49];
plot(t', P', '.-', 'LineWidth', 2, 'MarkerSize', 22);
ylabel('position')
xlabel('k (step)');
grid on
legend('x', 'y', 'z', 'Location', 'SouthWest');
xaxis(0,49)

rvcprint('subfig', 'a')

%%
clf

rpy = rotm2eul(Ts.rotm());
plot(t,rpy, '.-', 'LineWidth', 2, 'MarkerSize', 22)
legend('yaw', 'pitch', 'roll', 'Location', 'SouthWest')
ylabel('RPY angles');
xlabel('k (step)'); grid on
xaxis(0,49)

rvcprint('subfig', 'b')
