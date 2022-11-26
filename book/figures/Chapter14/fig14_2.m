
im1 = iread('eiffel2-1.jpg', 'mono', 'double');
im2 = iread('eiffel2-2.jpg', 'mono', 'double');
harris = icorner(im1, 'nfeat', 200);
idisp(im1); harris.plot('gs');
idisp(im1, 'nogui', 'dark'); 
harris.plot('gs')
rvcprint('subfig', 'a', 'svg')

sf = isurf(im1, 'nfeat', 200);
sf.plot_scale('g');
idisp(im1, 'nogui', 'dark')
sf.plot('g+');
sf.plot_scale('g');

rvcprint('subfig', 'b', 'svg')