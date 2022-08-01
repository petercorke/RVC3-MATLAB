close all; clear;

% Set start and goal pose
qs = [0 0 pi/2];
qg = [1 0 pi/2];

p = referencePathFrenet([qs;qg], DiscretizationDistance=0.01);
figure
p.show;
axis equal
xlim([-0.05 1.05])
ylim([-0.2 0.2])
xlabel("x")
ylabel("y")

% Plot orientation. This hard-codes the pi/2 orientation
hold on
plot([qs(1); qs(1)], [qs(2); qs(2) + 0.1], ...
    Color="black", LineWidth=2)
plot([qg(1); qg(1)], [qg(2); qg(2) + 0.1], ...
    Color="black", LineWidth=2)

% Make start and goal more prominent
plotStartGoal(qs, qg, 12, 16);

legend(["","Path","Heading","","Start pose","Goal pose"], Location="eastoutside")
grid on
rvcprint("painters", thicken=1.5)
