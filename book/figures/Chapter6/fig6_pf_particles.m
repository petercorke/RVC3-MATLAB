close all; clear;


% Particle filter
pf_setup

%% Subfigure (a) - Particles at first time step
figure;
pf.run(1);
xyzlabel
legend(getHandles, ["Landmark", "Particle", "Random waypoint", "True vehicle pose"])
rvcprint("painters", subfig="_a");

%% Subfigure (b) - Particles at XX time step
figure;
pf.run(10);
xyzlabel
legend(getHandles, ["Landmark", "Particle", "Random waypoint", "True vehicle pose"])
rvcprint("painters", subfig="_b");

%% Subfigure (c) - Particles at XX time step
figure;
pf.run(100);
xyzlabel
legend(getHandles, ["Landmark", "Particle", "Random waypoint", "True vehicle pose"])
rvcprint("painters", subfig="_c");

function plotHandles = getHandles
%getHandles Get graphics handles for objects we want to include in legend
plotHandles(1) = findobj(gca, Tag="map");
plotHandles(2) = findobj(gca, Tag="particles");
plotHandles(3) = findobj(gca, Marker="Diamond");
plotHandles(4) = findobj(gca, Type="Patch");
end