clf
Tgrid = transl(0,0,1)*trotx(0.1)*troty(0.2);
P = mkgrid(3, 1.0, 'pose', Tgrid);
cam1.clf(); cam2.clf();
p1 = cam1.plot(P, 'o');
rvcprint('subfig', 'a', 'hidden', cam1.h_image.Parent)

p2 = cam2.plot(P, 'o');
H = homography(p1, p2)
p2b = homtrans(H, p1);
cam2.hold()
cam2.plot(p2b, '+')

rvcprint('subfig', 'b', 'hidden', cam2.h_image.Parent)