castle = iread('castle2.png', 'double');

[mser,nsets] = imser(castle, 'area', [100 20000]);
nsets
idisp(mser, 'colormap', 'jet', 'nogui')


rvcprint('svg');
