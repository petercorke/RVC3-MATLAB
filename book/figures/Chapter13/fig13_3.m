castle = iread('castle2.png', 'double');

idisp(castle, 'nogui')
rvcprint('subfig', 'a', 'svg');

t = otsu(castle)

clf
ihist(castle, 'b')
vertline(0.75);
vertline(t, 'r--');

rvcprint('subfig', 'b');


idisp(castle>=0.75, 'nogui', 'black', 0.3)
rvcprint('subfig', 'c', 'svg');

idisp(castle>=t, 'nogui', 'black', 0.3)
rvcprint('subfig', 'd', 'svg');