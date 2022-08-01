close all; clear;

V = diag([0.02, 0.5*pi/180].^2);
veh = BicycleVehicle(Covariance=V);
veh.addDriver( RandomDriver(10) );

P0 = diag([0.05, 0.05, deg2rad(0.5)].^2);
ekf = EKF(veh, V, P0);

rng("default")
ekf.run(400);

figure;

p0 = ekf.get_P;

% redo the sims for different values of V
ekf = EKF(veh, 2*V, P0);
rng("default");
ekf.run(400);
pb = ekf.get_P;

ekf = EKF(veh, 0.5*V, P0);
rng("default");
ekf.run(400);
ps = ekf.get_P;

figure;
%plot([p0 pb ps]);
plot(p0); hold on;
plot(pb, LineStyle="--");
plot(ps, LineStyle="-.");
l = legend(["1", "2", "0.5"], Location="NorthWest");
l.FontSize = 12;
xlabel("Time step");

ylabel("(det P)^{0.5}")
ylim([0, 0.23]);

rvcprint("painters", thicken=1.5)
