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

%% Figure 5:astar-explored - Show visited nodes when running A*
figure;
[~,~,searchTree] = g.path_Astar("Hughenden", "Brisbane");
visited = string(searchTree.Nodes.Name)';
gPlot = g.plot(labels=true);
g.highlight_node(gPlot, visited, NodeColor=[0.9290 0.6940 0.1250]);

xlabel("x")
ylabel("y")

% Move labels slightly to avoid overlap
moveNodeLabel(gPlot, "Longreach", 0, 40)
moveNodeLabel(gPlot, "Barcaldine", 0, -25)
moveNodeLabel(gPlot, "Charleville", 0, 30)
moveNodeLabel(gPlot, "Mount Isa", -5, -35)

% Save figure (without axes box)
rvcprint("painters");
