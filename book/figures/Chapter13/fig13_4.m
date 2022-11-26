castle = iread('castle2.png', 'double');

t = niblack(castle, -0.1, 30);

idisp(t, 'nogui')
rvcprint('subfig', 'a', 'svg');

idisp(castle >= t, 'nogui', 'black', 0.3)


rvcprint('subfig', 'b', 'svg');