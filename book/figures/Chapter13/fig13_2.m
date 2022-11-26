castle = iread('castle.png', 'double');

idisp(castle, 'nogui')
rvcprint('subfig', 'a', 'svg');

t = otsu(castle)


clf
ihist(castle, 'b')
vertline(0.7)
vertline(t, 'r--')
rvcprint('subfig', 'b', 'thicken', 1.5);


idisp(castle>=0.7, 'nogui', 'black', 0.3)
rvcprint('subfig', 'c', 'svg');


idisp(castle>=t, 'nogui', 'black', 0.3)
rvcprint('subfig', 'd', 'svg');