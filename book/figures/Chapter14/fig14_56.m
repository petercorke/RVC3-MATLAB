im = iread('bridge-l/*.png', 'roi', [20 750; 20 480]);


c = icorner(im, 'nfeat', 200, 'patch', 7);

ianimate(im, c, 'npoints', 200, 'only', 15, 'showopt')
rvcprint


