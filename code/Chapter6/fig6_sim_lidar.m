close all; clear;

load killian.mat
load ogfull.mat

rng("default");
lidar = rangeSensor;
lidar.Range = [0 50];
lidar.HorizontalAngle = deg2rad([-90 90]);
lidar.HorizontalAngleResolution = deg2rad(1);

[ranges, angles] = lidar(odoTruth(131,:), ogfull);

%% Subfigure (a) - Full scan
figure
lidarScan(ranges,angles).plot
hold on
lidarData(131).plot
ylim([-2 5]);
xlim([0 8]);
title("")

% Zoom area specified as xlower, ylower, xupper, yupper
zoomArea = [3 0.5 4.5 2.5];
co = colororder;
plot_box(zoomArea(1), zoomArea(2), zoomArea(3), zoomArea(4), Color=co(4,:), LineWidth=1)

l = legend("Scan 131 (sim)", "Scan 131 (real)", "Area of detail");
l.Position = [0.2990 0.8026 0.1679 0.0871];

rvcprint("painters", subfig="_a")

%% Subfigure (b) - Partial scan area
figure;
markerSize = 14;
pl1 = lidarScan(ranges,angles).plot;
pl1.MarkerSize = markerSize;
hold on
pl2 = lidarData(131).plot;
pl2.MarkerSize = markerSize;
ylim([zoomArea(2) zoomArea(4)]);
xlim([zoomArea(1) zoomArea(3)]);
title("")

% TODO: Add occupancy map. We need to enumerate each grid cell in the
% zoomed area and plot each polygon separately, since we look at the grid
% at an angle.
cellSize = 1 / ogfull.Resolution;
odo = se2(tform2d(odoTruth(131,:)));
cellCoord = ...
    [-cellSize/2 cellSize/2; ...
    -cellSize/2 -cellSize/2; ...
    cellSize/2 -cellSize/2; ...
    cellSize/2 cellSize/2]';
alreadyPlotted = double.empty(0,2);
for x = zoomArea(1):cellSize/2:zoomArea(3)
    for y = zoomArea(2):cellSize/2:zoomArea(4)
        % Convert to world coordinates
        worldCoord = odo.transform([x; y], IsCol=true);
        if ogfull.checkOccupancy(worldCoord') ~= 1
            continue;
        end
        
        % Only plot occupied cells
        % Get grid cell corner coordinates from center.
        cellCenterWorld = ogfull.grid2world(ogfull.world2grid(worldCoord'));
        if ~isequal(size(setdiff(alreadyPlotted, cellCenterWorld, "rows")), size(alreadyPlotted))
            % Only plot each occupied cell once
            continue;
        else
            alreadyPlotted = [alreadyPlotted; cellCenterWorld]; %#ok<AGROW> 
        end
        
        cellCoordWorld = cellCoord + cellCenterWorld';
        cellCoordLidar = inv(odo).transform(cellCoordWorld, IsCol=true);
        plot_poly(cellCoordLidar, fillcolor="k", alpha=0.3);

    end
end

% Redraw the Lidar points, so they show up on top
pl3 = plot(pl1.XData, pl1.YData, ".");
pl3.MarkerSize = markerSize;
pl3.Color = pl1.Color;
pl4 = plot(pl2.XData, pl2.YData, ".");
pl4.MarkerSize = markerSize;
pl4.Color = pl2.Color;


l = legend("Scan 131 (sim)", "Scan 131 (real)", "Occupied cells");
l.Position = [0.1790 0.7826 0.1679 0.0871];

rvcprint("painters", subfig="_b")
