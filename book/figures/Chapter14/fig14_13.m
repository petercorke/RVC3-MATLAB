cam1.clf
p1 = cam1.plot([P Q], 'o');

rvcprint('subfig', 'a', 'hidden', cam1.h_image.Parent)

cam2.clf
p2 = cam2.plot([P Q], 'o');
p2h = homtrans(H, p1);
cam2.hold
cam2.plot(p2h, '+')

rvcprint('subfig', 'b', 'hidden', cam2.h_image.Parent)