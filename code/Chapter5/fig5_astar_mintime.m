close all; clear;

data = jsondecode(fileread("queensland.json"));

%% Construct Graph
g = UGraph;
for name = string(fieldnames(data.places))'
    place = data.places.(name);
    g.add_node(place.utm, name=place.name);
end

% Add edges for connections
for route = data.routes'
    g.add_edge(route.start, route.end, route.distance);
end

%% Figure 5:astar-mintime (a) - A* with standard Euclidean heuristic (minimum distance)
figure;
path = g.path_Astar("Hughenden", "Brisbane");
gPlot = g.plot;
g.highlight_path(gPlot, path, labels=true);
xlabel("x");
ylabel("y");

moveNodeLabel(gPlot, "Barcaldine", 0, -25)
moveNodeLabel(gPlot, "Charleville", 0, 30)

% Save subfigure a
rvcprint("subfig", "_a", "painters");

%% Figure 5:astar-mintime (b) - A* with time heuristic (minimum time)
g = UGraph;
for name = string(fieldnames(data.places))'
    place = data.places.(name);
    g.add_node(place.utm, name=place.name);
end
for route = data.routes'
    g.add_edge(route.start, route.end, route.distance / route.speed);
end
g.measure = @(x1, x2) vecnorm(x1 - x2) / 100;

figure;
path = g.path_Astar("Hughenden", "Brisbane");
gPlot = g.plot;
g.highlight_path(gPlot, path, labels=true);
xlabel("x");
ylabel("y");

moveNodeLabel(gPlot, "Barcaldine", 0, -25)
moveNodeLabel(gPlot, "Charleville", 0, 30)
moveNodeLabel(gPlot, "Longreach", 0, 40)

% Save subfigure b
rvcprint("subfig", "_b", "painters");
