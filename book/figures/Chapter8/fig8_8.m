close all; clear;

[puma, conf] = loadrvcrobot("puma");

%% Subfigure (a) - Translational Velocity Ellipse for nominal pose
figure;
axis(1*[-1 1 -1 1 -1 1])

J = puma.geometricJacobian(conf.qn, "link6");
Jt = J(4:6,:);
E = inv(Jt*Jt');

plotellipsoid(E, fillcolor="r", shadow=true)
xyzlabel
grid on
view(150, 30)
rvcprint("painters", subfig="_a");

%% Subfigure (b) - Rotational Velocity Ellipse for pose near singularity
qns = conf.qr;
qns(5) = deg2rad(5);

J = puma.geometricJacobian(qns, "link6");
Jr = J(1:3,:);
E = inv(Jr*Jr');

figure;
axis(2*[-1 1 -1 1 -1 1])
plotellipsoid(E, fillcolor="r", shadow=true)
xyzlabel
grid on
view(150, 30)


rvcprint("painters", subfig="_b");
