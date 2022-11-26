close all; clear;

% [~,lidarData,lidarTimes,odoTruth] = g2oread("killian.g2o");
% cellSize = 0.1; maxRange = 40;

%% Subfigure (a) - Full occupancy map
% ogfull = buildMap(num2cell(lidarData), odoTruth, 1/cellSize, maxRange);
load ogfull.mat

figure;
ogfull.show
title("")
xlim([-75 230]);
ylim([-40 225]);
co = colororder;
plot_box(-70.0765, 37.0321, -26.3492, 76.7230, Color=co(4,:), LineWidth=2)
legend("Area of detail", Location="northwest")

rvcprint("painters", "nogrid", subfig="_a")


%% Subfigure (b) - Detail of central section
figure;
ogfull.show
title("")
% xlim([25 45]);
% ylim([50 70]);
xlim([-70.0765, -26.3492]);
ylim([37.0321, 76.7230]);

rvcprint("painters", "nogrid", subfig="_b")
