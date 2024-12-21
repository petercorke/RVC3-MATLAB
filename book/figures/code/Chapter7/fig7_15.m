close all
clear

% Load poses 
% row 1 - default pose
% row 2 - The Heisman
% row 3 - The Karate Kid
% row 4 - The Yogi
% row 5 - The Dab
% row 7 - The Arnold
% row 8 - The Apolo Anton Ohno
load atlasPoses.mat

atlas = loadrobot("atlas", DataFormat="row");
figure;
atlas.show(atlasPosesData(8,:), Frames="off")

xlim([-1 1])
ylim([-1 1])
zlim([-1 1.25])

view(61.34,13.45)

%camlight

rvcprint("opengl")