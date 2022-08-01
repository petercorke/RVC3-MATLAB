close all; clear;

load house
floorMap = binaryOccupancyMap(flipud(floorplan));

% Create inflated map
dx = DistanceTransformPlanner(floorMap);
dx.plan(places.kitchen);
p = dx.query(places.br3);
dx.plot3d(p, "nogoal", "nostart", pathmarker={"MarkerEdgeColor", "g", "LineWidth", 1, "MarkerSize", 6})

z = get(gca, 'ZLim'); z = z(1);
hold on
plot2([p(:,1:2) z*ones(size(p,1),1)], 'Color', 0.8*[1 1 1]);

colormap(bone)
brighten(0.7)

view(128,40)

% add the place name
for location=fieldnames(places)'
    xy = places.(location{1})
    z = dx.distancemap(xy(2), xy(1))
    plot3(xy(1), xy(2), z+ 10, 'py', 'MarkerSize', 12, 'MarkerFaceColor', 'y');
    if string(location{1}) == "driveway"
        ht = text(xy(1) - 30, xy(2) - 15, z+ 20, ['  ' location{1}], 'Color', 'k');
    else
        ht = text(xy(1), xy(2), z+ 20, ['  ' location{1}], 'Color', 'k');
    end
    ht.Units = 'normalized';  % put text on the top
end
hold off

rvcprint("opengl")