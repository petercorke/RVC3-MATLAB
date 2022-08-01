castle = iread('castle.png');
roi = [420 300 580 420];
t = ocr(castle, roi);
idisp(castle, 'nogui')
plot_box('matlab', roi, 'r--', 'LineWidth', 2)

plot_box('matlab', t.WordBoundingBoxes, 'y', 'LineWidth', 2)

rvcprint('svg')