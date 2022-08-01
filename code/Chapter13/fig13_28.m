b1 = iread('building2-1.png', 'grey', 'double');
sf1 = isurf(b1, 'nfeat', 200)
sf1(1)
idisp(b1, 'nogui', 'dark');
sf1.plot_scale('g', 'clock')

rvcprint('svg')