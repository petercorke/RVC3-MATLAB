
di(status>1) = NaN;
im = ipixswitch(isnan(di), 'red', di/90);
idisp(im, 'nogui')

rvcprint('svg')