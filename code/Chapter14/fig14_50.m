images = iread('campus/*.jpg', 'mono');
sf = isurf(images, 'thresh', 0);
sf{1}
sf = [sf{:}]
sf(259)
idisp(images(:,:,1), 'nogui')
sf(259).plot('g+')
sf(259).plot_scale('g', 'clock')
rvcprint('subfig', 'a', 'svg')

clf
z = sf(259).support(images);
idisp(z, 'nogui')

rvcprint('subfig', 'b', 'svg')


