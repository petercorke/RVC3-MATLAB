randinit
F = m.ransac(@fmatrix, 1e-4, 'verbose')
m.show

idisp({im1, im2} , 'nogui', 'dark');
m.inlier.subset(100).plot('g')
rvcprint('subfig', 'a', 'svg')

idisp({im1, im2} , 'nogui', 'dark');
m.outlier.subset(100).plot('r')

rvcprint('subfig', 'b', 'svg')