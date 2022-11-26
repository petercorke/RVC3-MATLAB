close all; clear;

% Particle filter
pf_setup

%% Subfigure (a) - Path 
pf.run(300, "noplot");

figure;
map.plot;
robot.plotxy("b", LineStyle="--");
pf.plotxy("r");
xyzlabel
legend(["Landmark", "True path", "Particle filter mean"])

rvcprint("painters", thicken=1.5, subfig="_a")

%% Subfigure (b) - Covariance
figure;
plot(1:100,pf.std(1:100,1), LineStyle="-"); hold on;
plot(1:100,pf.std(1:100,2), LineStyle="--")
plot(1:100,pf.std(1:100,3)*10, LineStyle=":")
xlabel("Time step")
ylabel("Standard deviation")
l = legend("x", "y", "\theta (x 10)");
grid on
rvcprint("painters", thicken=1.5, subfig="_b")
