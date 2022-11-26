[du,dv] = isobel( castle, kdgauss(2) );
idisp(m, 'invert', 'nogui');
axis([400 700 300 600])
rvcprint('subfig', 'b', 'svg');

edges = icanny(castle, 2);
idisp( edges, 'invert', 'nogui');
axis([400 700 300 600])
rvcprint('subfig', 'a', 'svg');
