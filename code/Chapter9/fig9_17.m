J = p560.jacob0(qn);
M = p560.inertia(qn);
Mx = (J * inv(M) * inv(M)' * J');
Mx = Mx(1:3, 1:3);
clf
axis([-.4 .4 -.4 .4 -.4 .4])
daspect([1 1 1])
plotellipse( Mx, 'fillcolor', 'g', 'shadow' )
xyzlabel; view(140, 20)
grid on

rvcprint

sqrt(eig(Mx))
min(ans)/max(ans)
p560.manipulability(qn, 'asada')