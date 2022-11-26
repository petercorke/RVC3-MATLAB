close all; clear;

load killian.mat
p131 = lidarData(131);
p133 = lidarData(133);

%% Subfigure (a) - Simple scans
figure;
p131.plot;
hold on;
p133.plot;
title("");
ylim([-4 7]);
xlim([0 10]);
l = legend(["Scan 131", "Scan 133"]);
l.Position = [0.1890 0.8226 0.1879 0.0871];

rvcprint("painters", subfig="_a", thicken = 1.5)

%% Subfigure (b) - Alignment with matchScans 
poseB = matchScans(p133, p131);
p133B = transformScan(p133, poseB);

figure;
p131.plot;
hold on;
p133B.plot;
title("");
ylim([-4 7]);
xlim([0 10]);
l = legend(["Scan 131", "Scan 133 (transformed)"]);
l.Position = [0.1890 0.8226 0.3179 0.0871];

rvcprint("painters", subfig="_b", thicken = 1.5)

%% Subfigure (c) - Alignment with matchScans with initial guess
poseC = matchScans(p133, p131, InitialPose=[1 0 0]);
p133C = transformScan(p133, poseC);

figure;
p131.plot;
hold on;
p133C.plot;
title("");
ylim([-4 7]);
xlim([0 10]);
l = legend(["Scan 131", "Scan 133 (transformed)"]);
l.Position = [0.1890 0.8226 0.3179 0.0871];

rvcprint("painters", subfig="_c", thicken = 1.5)


%% Subfigure (d) - Alignment with matchScansGrid
poseD = matchScansGrid(p133, p131);
p133D = transformScan(p133, poseD);

figure;
p131.plot;
hold on;
p133D.plot;
title("");
ylim([-4 7]);
xlim([0 10]);
l = legend(["Scan 131", "Scan 133 (transformed)"]);
l.Position = [0.1890 0.8226 0.3179 0.0871];

rvcprint("painters", subfig="_d", thicken = 1.5)
