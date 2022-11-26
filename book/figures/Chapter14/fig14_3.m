sf1 = isurf(im1)
sf2 = isurf(im2)
m = sf1.match(sf2)
m(1:5)

idisp({im1, im2}, 'nogui', 'dark')
m.subset(100).plot('w')

rvcprint('svg')