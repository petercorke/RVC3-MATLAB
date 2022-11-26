p1 = cam1.plot(P)
p2 = cam2.plot(P)
cam1.hold
e1 = cam1.plot( cam2.centre, 'Marker', 'd', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
cam2.hold
e2 = cam2.plot( cam1.centre, 'Marker', 'd', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
F = cam1.F( cam2 )
rank(F)
null(F)'
e1 = h2e(ans)'
null(F');
e2 = h2e(ans)'
cam2.plot_epiline(F, p1, 'r')
cam2.figure()
rvcprint('subfig', 'b', 'hidden', cam2.h_image.Parent)

cam1.plot_epiline(F', p2, 'r');
cam1.figure()
rvcprint('subfig', 'a', 'hidden', cam1.h_image.Parent)
