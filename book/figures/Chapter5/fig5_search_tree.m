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

%% Figure 5:search-tree - Show search tree from UCS planning
figure;
[~,~,searchTree] = g.path_UCS("Hughenden", "Brisbane");
gPlot = searchTree.plot("LineWidth", 2.0, "MarkerSize", 8, "ArrowSize", 10, "NodeFontSize", 10);
g.highlight_node(gPlot, ["Hughenden", "Brisbane"]);

% Save figure (without axes box)
axis off;
rvcprint("painters");
