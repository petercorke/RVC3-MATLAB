im = testpattern('squares', 256, 256, 128);
im = irotate(im, -0.3);
edges = icanny(im);
idisp(edges, 'nogui', 'black', 0.3);
rvcprint('subfig', 'a', 'svg')

h = Hough(edges)
h.show();
c = colorbar
c.Label.String = 'Votes';
c.Label.FontSize = 10;
rvcprint('subfig', 'b', 'svg')
rvcprint('subfig', 'b', 'opengl')

axis([-1.40 -1.1 -190 -110]);
rvcprint('subfig', 'c', 'svg')
rvcprint('subfig', 'c', 'opengl')

lines = h.lines()
h = Hough(edges, 'suppress', 5)
lines = h.lines()
idisp(im, 'nogui', 'black', 0.3);
h.plot('g')
rvcprint('subfig', 'd', 'svg')
