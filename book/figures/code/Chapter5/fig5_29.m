close all; clear;

%% lattice after 8 iter
lp = LatticePlanner(iterations=8);
lp.plan()

% A-star search
% Set start and goal pose
qs = [0 0 pi/2];
qg = [1 0 pi/2];

%% Sub-figure (a) - Uniform cost
lp.query(qs, qg);
figure;
lp.plot()
xlim([-2,3]);
ylim([-3,3]);

rvcprint("painters", subfig="_a")

%% Sub-figure (b) - Penalty for left turns
lp.plan(cost=[1 10 1]);
lp.query(qs, qg);
figure;
lp.plot

xlim([-2,3]);
ylim([-3,3]);

legend(["Goal pose", "", "Lattice node", "Start pose", ...
    repmat("",1,1700), "Path"], Location="eastoutside")

rvcprint("painters", subfig="_b")
