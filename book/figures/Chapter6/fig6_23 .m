close all; clear;

[~,lidarData,lidarTimes,odoTruth] = g2oread("killian.g2o");
cellSize = 0.1; maxRange = 40;
p131 = lidarData(131);
p133 = lidarData(133);
pose = matchScansGrid(p133, p131);

og = occupancyMap(10,10,1/cellSize,...
    LocalOriginInWorld=[0 -5]);

%% Subfigure (a) - Occupancy map after the first scan
figure;
og.insertRay([0 0 0], p131, maxRange)
og.show
view(-90,90)
title("")

hold on;
plot(p131.Cartesian(:,1), p131.Cartesian(:,2), '.b')
ylim([-2 5])
l = legend("Scan 131");
l.Position = [0.3240 0.8426 0.1679 0.0671];

rvcprint("painters", "nogrid", subfig="_a")

%% Subfigure (b) - Occupancy map after the first scan
figure;
og.insertRay(pose, p133, maxRange)
og.show
view(-90,90)
title("")

p133T = transformScan(p133, pose);
hold on;
plot(p133T.Cartesian(:,1), p133T.Cartesian(:,2), '.r')
ylim([-2 5])
l = legend("Scan 133 (transformed)");
l.Position = [0.3790 0.8426 0.1879 0.0671];

rvcprint("painters", "nogrid", subfig="_b")

%% Subfigure (c) - With Colorbar
f = figure;
og.show
view(-90,90)
title("")
ylim([-2 5])

colormap("gray")
cb = colorbar(Direction="reverse");
cb.TickLabels = flip(cb.TickLabels);
f.Position = [1000, 918, 400, 420];

rvcprint("painters", "nogrid", subfig="_c")

