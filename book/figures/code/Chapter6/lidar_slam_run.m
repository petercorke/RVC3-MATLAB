load("indoorSLAMData.mat");
maxLidarRange = 9;
mapResolution = 20;
slam = lidarSLAM(mapResolution, maxLidarRange);

slam.LoopClosureThreshold = 200;  
slam.LoopClosureSearchRadius = 8;

numScans = 70;

% Run SLAM. This can take ~1 minute.
for i = 1:numScans
    slam.addScan(scans{i});
end

xl = [-9.2964 13.2430];
yl = [-9.7719 7.9864];

xlpg = [-6 11];
ylpg = [-6 4];