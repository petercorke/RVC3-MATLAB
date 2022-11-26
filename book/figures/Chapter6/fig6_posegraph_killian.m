close all; clear;

pg = tororead("killian-small.toro");

%% Subfigure (a) - Initial pose graph
figure;
pg.show(IDs="off");
l = legend("Edge", "Node", "Loop closure", Location="northwest");

rvcprint("painters", subfig="_a")

%% Subfigure (b) - Optimized pose graph
figure;
pgopt = optimizePoseGraph(pg, "g2o-levenberg-marquardt");
pgopt.show(IDs="off");
l = legend("Edge", "Node", "Loop closure", Location="north");

rvcprint("painters", subfig="_b")
