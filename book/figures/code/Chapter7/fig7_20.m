close all
clear

figure
abb = loadrobot("abbIrb1600", DataFormat="row");
abb.show

camlight left

xlim([-0.5 1]);
ylim([-0.5 0.5]);
zlim([-0.1 1]);

rvcprint("opengl")