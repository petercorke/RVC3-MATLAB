close all; clear;

% EKF dead reckoning
V = diag([0.02, 0.5*pi/180].^2);
veh = BicycleVehicle(Covariance=V);
veh.addDriver( RandomDriver(10,show=false) );

P0 = diag([0.05, 0.05, deg2rad(0.5)].^2);
ekf = EKF(veh, V, P0);

rng("default")
ekf.run(400);

figure;
ekf.plotellipse(fillcolor="g", alpha=0.3, edgecolor="none")
hold on
veh.plotxy
ekf.plotxy

xyzlabel;
grid on;
axis equal

% Don't show legend for the ellipses
legend([repmat("", 1, 19), "95% confidence", "Ground truth", ...
    "EKF estimate"], Location="southeast")

rvcprint("opengl", thicken=1.5)