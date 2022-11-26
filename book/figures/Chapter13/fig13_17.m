im = iread('5points.png', 'double');
idisp(im, 'nogui', 'black', 0.3);
rvcprint('subfig', 'a', 'opengl')

h = Hough(im);
h.show();
c = colorbar
c.Label.String = 'Votes';
c.Label.FontSize = 10;

rvcprint('subfig', 'b', 'svg')
rvcprint('subfig', 'b', 'opengl')