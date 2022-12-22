close all; clear;

% [~,lidarData,lidarTimes,odoTruth] = g2oread("killian.g2o");
% cellSize = 0.1; maxRange = 40;
% 
% %% Subfigure (a) - Full occupancy map
% ogfull = buildMap(num2cell(lidarData), odoTruth, 1/cellSize, maxRange);

load ogfull.mat

rng("default")

% Create a Monte Carlo Localization object
mcl = monteCarloLocalization(UseLidarScan=true);
mcl.GlobalLocalization = 1;
mcl.ParticleLimits = [500 20000];

% Assign sensor model to Monte Carlo Localization object
sm = likelihoodFieldSensorModel;
sm.Map = ogfull;
mcl.SensorModel = sm;

%% Subfigure (a) - Step 100
[isUpdated, pose, covariance] = mcl(odoTruth(100,:), lidarData(100));
particles = mcl.getParticles;
f = figure;
ogfull.show; hold on;
plot(particles(:, 1), particles(:,2), '.');
plot(odoTruth(100,1), odoTruth(100,2), 'r+', MarkerSize=10, LineWidth=1.5);
xlim([-70.0765, -26.3492]);
ylim([37.0321, 76.7230]);
set(f, "Position", [969   827   591   511]);
legend("Particles", "True pose")
title("")

rvcprint("painters", "nogrid", subfig="_a")
close(f);

% Create plotting object
mp = mclPlot(ogfull);

%% Subfigure (b) - Step with multiple hypotheses (125)
for i = 101:125
    [isUpdated, pose, covariance] = mcl(odoTruth(i,:), lidarData(i));
    mp.plot(mcl, pose, odoTruth(i,:), lidarData(i));
    drawnow limitrate
end
xlim([-70.0765  -26.3492]);
ylim([37.0321   76.7230]);
set(gcf, "Position", [969   827   591   511]);
legend("Particles", "Estimated pose", "", "Lidar scan (transformed to estimated pose)", "True pose")
title("")

rvcprint("painters", "nogrid", subfig="_b")

%% Subfigure (c) - Step with convergence (150)

% Estimate robot pose and covariance
for i = 126:150
    [isUpdated, pose, covariance] = mcl(odoTruth(i,:), lidarData(i));
    mp.plot(mcl, pose, odoTruth(i,:), lidarData(i));
    drawnow limitrate
end
xlim([-70.0765  -26.3492]);
ylim([37.0321   76.7230]);
set(gcf, "Position", [969   827   591   511]);
legend("Particles", "Estimated pose", "", "Lidar scan (transformed to estimated pose)", "True pose")
title("")

rvcprint("painters", "nogrid", subfig="_c")