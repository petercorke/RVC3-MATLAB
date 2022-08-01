b1 = iread('building2-1.png', 'grey', 'double');

[C,strength] = icorner(b1, 'nfeat', 200);
idisp(strength,  'invsigned', 'nogui')
C.plot('ks')
axis([300 500 300 500]);
rvcprint('subfig', 'a', 'svg')



x = 465:500;
y = 400:435;

x = 385:420;
y = 340:375;

x = 310:345;
y = 440:475;
s = strength(y,x);
h = surf(x, y, s, s)
invsignedmap(s)
xlabel('u (pixels)')
ylabel('v (pixels)');
zlabel('Corner strength')
view(122, 49)

% idisp(strength, 'nogui')
% C.plot('g+')
% axis([460 475 150 165])
% brighten(0.2)

rvcprint('subfig', 'b', 'svg')

