b1 = iread('building2-1.png', 'grey', 'double');

C = icorner(b1, 'nfeat', 200);
idisp(b1, 'nogui',  'dark');
C.plot('ws');
rvcprint('subfig', 'a', 'svg');

xaxis(400, 900); yaxis(50, 350);
rvcprint('subfig', 'b', 'svg');

Cs = icorner(b1, 'nfeat', 200, 'suppress', 10);

C(1:4)
C(1:5).strength
C(1).u

b2 = iread('building2-2.png', 'grey', 'double');
C2 = icorner(b2,  'nfeat', 200);
idisp(b2, 'nogui',  'dark')
C2.plot('ws');
rvcprint('subfig', 'c', 'svg');

xaxis(200, 700); yaxis(50, 350);
rvcprint('subfig', 'd', 'svg');
