close all; clear;

% Set start and goal pose
qs = [0 0 pi/2];
qg = [1 0 pi/2];

% Get clothoid curvature along path
p = referencePathFrenet([qs;qg]);
clothCurv = p.curvature((0:0.05:p.PathLength)');
clothDistNorm = linspace(0,1,size(clothCurv,1))';

% Get Dubins curvature along path
dubins = dubinsConnection(MinTurningRadius=1);
[paths, length] = dubins.connect(qs,qg);
dubinsPath = paths{1};
dubinsCurv = 1/dubins.MinTurningRadius ...
    * [1 1 0 0 1 1];
cs = cumsum(dubinsPath.MotionLengths);
dubinsDistNorm = [0.0, cs(1) cs(1) cs(2) cs(2) cs(3)] ./ dubinsPath.Length;

figure;
plot(clothDistNorm, clothCurv);
hold on
plot(dubinsDistNorm, dubinsCurv);

xlabel("Normalized path distance s")
ylabel("Curvature \kappa")

legend("Clothoid", "Dubins", Location="northwest")
rvcprint("painters", thicken=1.5)