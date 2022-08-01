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

%% Figure 5:search-compare (a) - BFS planning
figure;
path = g.path_BFS("Hughenden", "Brisbane");
gPlot = g.plot;
g.highlight_path(gPlot, path, labels=true);
xlabel("x");
ylabel("y");

moveNodeLabel(gPlot, "Barcaldine", 0, -25)

% Save subfigure a
rvcprint("subfig", "_a", "painters");

%% Figure 5:search-compare (b) - UCS / A* planning
figure;
path = g.path_UCS("Hughenden", "Brisbane");
gPlot = g.plot;
g.highlight_path(gPlot, path, labels=true);
xlabel("x");
ylabel("y");

moveNodeLabel(gPlot, "Barcaldine", 0, -25)
moveNodeLabel(gPlot, "Charleville", 0, 30)

% Save subfigure b
rvcprint("subfig", "_b", "painters");
