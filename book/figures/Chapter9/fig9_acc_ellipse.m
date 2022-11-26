close all; clear;
[puma, conf] = loadrvcrobot("puma");

J = puma.geometricJacobian(conf.qn, "link6");
Jt = J(4:6,:);

M = puma.massMatrix(conf.qn);
E = Jt * inv(M) * inv(M)' * Jt';

figure
daspect([1 1 1])
plotellipsoid( E, 'fillcolor', 'g', 'shadow' )
xyzlabel; view(120, 13)
ylim([-2 2]);
grid on

rvcprint("painters");
