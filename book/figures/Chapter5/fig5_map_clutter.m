close all; clear;

rng(0);
map = mapClutter(10, ["Box", "Circle"], MapResolution=20);
figure; 
show(map)

% Standardize labels
xlabel("x")
ylabel("y")
title("")

% Make areas outside axes transparent
f = gcf;
f.Color="none";
ax = gca;
ax.Color="none";
ax.GridColor = [0.65 0.65 0.65];
ax.GridAlpha = 1;
ax.Box = "on";
f.InvertHardcopy = "off";

rvcprint