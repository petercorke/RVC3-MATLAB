close all; clear;

rng("default");
mm = odometryMotionModel;
newPose = [0.5 0.2 pi/4];
numParticles = 500;

%% Subfigure (a) - Default noise
figure;
mm.Noise = [0.2 0.2 0.1 0.1];
mm.showNoiseDistribution(OdometryPoseChange=newPose, NumSamples=numParticles);
xlim([-0.2 0.8]);
ylim([-0.6 0.6]);
l = legend;
l.Location = "southwest";
rvcprint("painters", subfig="_a")

%% Subfigure (b) - Large rotational noise
figure;
mm.Noise = [1 1 0.05 0.05];
mm.showNoiseDistribution(OdometryPoseChange=newPose, NumSamples=numParticles);
xlim([-0.2 0.8]);
ylim([-0.6 0.6]);
l = legend;
l.Location = "southwest";
rvcprint("painters", subfig="_b")

%% Subfigure (c) - Large translational noise
figure;
mm.Noise = [0.2 0.2 0.4 0.4];
mm.showNoiseDistribution(OdometryPoseChange=newPose, NumSamples=numParticles);
xlim([-0.2 0.8]);
ylim([-0.6 0.6]);
l = legend;
l.Location = "southwest";
rvcprint("painters", subfig="_c")
