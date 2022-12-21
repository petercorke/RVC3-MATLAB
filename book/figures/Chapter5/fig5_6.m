close all; clear;

%% Graph plot
data = jsondecode(fileread("queensland.json"));

u = UGraph;

% Add nodes for each place
for place = string(fieldnames(data.places))'
    placeName = data.places.(place).name;
    placeCoord = data.places.(place).utm;
    u.add_node(placeCoord, name=placeName);
end

% Add edges for connections
for route = data.routes'
    u.add_edge(route.start, route.end, route.distance);
end

% Plot graph
figure;
pl = u.plot("labels", "noedgelabels", "NodeFontSize", 11);
xlabel("x");
ylabel("y");
% axis equal

% Move labels slightly to avoid overlap
moveNodeLabel(pl, "Longreach", 0, 40)
moveNodeLabel(pl, "Barcaldine", 0, -25)
moveNodeLabel(pl, "Charleville", 0, 30)
moveNodeLabel(pl, "Mount Isa", -5, -35)

% Save subfigure a
rvcprint("subfig", "_a", "painters");


%% Occupancy grid plot

load house
bug = Bug2(floorplan);
figure;
bug.plot;

% Save subfigure b
rvcprint("subfig", "_b", "grid");
