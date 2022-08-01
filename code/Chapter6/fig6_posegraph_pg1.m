close all; clear;

pg = g2oread("pg1.g2o");

%% Subfigure (a) - Initial pose graph
figure
ax = pg.show(IDs="nodes");
xlim([-1 12]);
ylim([-1 18.5]);

l = legend("Edge", "Node", "Loop closure");
l.Position = [0.5087    0.7946    0.2196    0.1262];

% Increase size of node markers
nodesHg = ax.Children(7);
nodesHg.MarkerSize = 14;

% Change position of node IDs to make them more visible
for i = 3:6
    textHg = ax.Children(i);
    textHg.FontSize = 12;
    textHg.Position = textHg.Position + [0.15 0.5 0];
end

rvcprint("painters", subfig="_a", thicken=1.5)

%% Subfigure (b) - Pose graph optimization iterations
[pgopt, info] = optimizePoseGraph(pg);

% Run optimization iteration by iteration to capture intermediate pose
% graphs.
numGraphs = info.Iterations + 1;
pgo = cell(1,numGraphs);
pgo{1} = copy(pg);
for i = 1:info.Iterations
    pgo{i+1} = optimizePoseGraph(pgo{i}, MaxIterations=1, VerboseOutput="on");
end

figure;
for i = 1:numGraphs
    grayValue = [1 1 1] - i/numGraphs;
    nodes = pgo{i}.nodeEstimates;
    nodes(end+1,:) = nodes(1,:); %#ok<SAGROW> 
    plot(nodes(:,1), nodes(:,2), Color=grayValue, LineStyle="-")
    plot(nodes(:,1), nodes(:,2), ".", MarkerSize=14, Color=grayValue)
    hold on
end

% Label nodes for optimized graph
nids = 1:size(nodes,1)-1;
text(nodes(1:end-1,1) + 0.1, nodes(1:end-1,2) + 0.4, num2str(nids'), ...
    Color="k", FontWeight="bold", FontSize=12);

axis equal;
xlim([-8 11]);
ylim([-1 14]);
xyzlabel;

rvcprint("painters", subfig="_b", thicken=1.5)