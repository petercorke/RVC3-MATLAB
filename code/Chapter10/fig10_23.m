im = iread('parks.jpg', 'gamma', 'sRGB');
gs = invariant(im, 0.7, 'noexp');
idisp(gs, 'nogui')

rvcprint