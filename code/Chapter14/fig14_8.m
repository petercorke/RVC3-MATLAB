E = cam1.E(F)
sol = cam1.invE(E)
inv(cam1.T) * cam2.T
Q = [0 0 10]';
cam1.project(Q)'
cam1.move(sol(1).T).project(Q)'
cam1.move(sol(2).T).project(Q)'
sol = cam1.invE(E, Q)
randinit;  % ensure repeatable results
P = homtrans( transl(-1, -1, 2), 2*rand(3,20) );
p1 = cam1.project(P);
p2 = cam2.project(P);
F = fmatrix(p1, p2)
rank(F)
cam2.plot(P);
cam2.plot_epiline(F, p1, 'r')
cam2.clf
cam2.plot(P);
cam2.hold
cam2.plot_epiline(F, p1, 'r')
cam2.plot( cam1.centre, 'Marker', 'd', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')

rvcprint('hidden', cam2.h_image.Parent) 