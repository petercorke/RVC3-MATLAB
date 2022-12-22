close all; clear;

load killian.mat
load ogfull.mat

rng("default")

mcl = monteCarloLocalization(UseLidarScan=true);
mcl.GlobalLocalization = 1;
mcl.ParticleLimits = [500 20000];

% Assign sensor model to Monte Carlo Localization object
sm = likelihoodFieldSensorModel;
sm.Map = ogfull;
mcl.SensorModel = sm;

numIterations = 50;
numParticles = zeros(1,numIterations);
timePerIt = zeros(1,numIterations);

for i = 100:100+numIterations-1
    tic; 
    mcl(odoTruth(i,:), lidarData(i));
    timePerIt(i-99) = toc;
    numParticles(i-99) = size(mcl.getParticles,1);
end

figure
yyaxis left
plot(1:numIterations, numParticles);
ylabel("Number of particles")
set(gca, 'YTickLabel',get(gca,'YTick'))
yyaxis right
plot(1:numIterations, timePerIt, LineStyle="--");
ylabel("Iteration time (s)")

xlabel("Iteration");

legend("Number of particles", "Iteration time (s)")


% xlim([-70.0765, -26.3492]);
% ylim([37.0321, 76.7230]);
% set(f, "Position", [969   827   591   511]);
% legend("Particles", "True pose")

rvcprint("painters", thicken=2)
