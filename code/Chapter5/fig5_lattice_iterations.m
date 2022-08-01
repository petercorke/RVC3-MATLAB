close all; clear;

lp = LatticePlanner;

%% lattice after 1 iter
lp.plan(iterations=1);
figure;
lp.plot;
xlim([-1 3]);
ylim([-3 3]);

rvcprint("painters", subfig="_a", thicken=1.5)

%% lattice after 2 iter
lp.plan(iterations=2);
figure;
lp.plot;
xlim([-1 3]);
ylim([-3 3]);

rvcprint("painters", subfig="_b", thicken=1.5)


%% lattice after 8 iter
lp.plan(iterations=8);
figure;
lp.plot;
xlim([-1 3]);
ylim([-3 3]);

rvcprint("painters", subfig="_c", thicken=1.5)


