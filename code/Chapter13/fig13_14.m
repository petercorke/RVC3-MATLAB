sharks = iread('sharks.png');


idisp(sharks, 'nogui', 'black', 0.3)

fv = iblobs( sharks, 'boundary', 'class', 1)

%fv.plot_box('g', 'LineWidth', 2);
fv.plot_boundary('r', 'MarkerSize', 10, 'LineWidth', 3)
plot_point(fv.p, 'ko'); plot_point(fv.p, 'kx'); 

rvcprint('svg')