
cam = CentralCamera('default');
P = mkgrid( 2, 0.5, 'pose', trvec2tform([0,0,3]) );
C_T0 = se3(trvec2tform([1 1 -3])*tformrz(0.6));
Cd_T_G = se3(trvec2tform([0, 0, 1]));
pbvs = PBVS(cam, P=P, pose0=C_T0, posef=Cd_T_G, axis=[-1 2 -1 2 -3 0.5])

pbvs.run(1);


rvcprint('subfig', 'b', 'hidden', cam.h_imageplane.Parent)


figure(cam.h_3dview.Parent.Parent)
view(58,22);
lighting gouraud
light
rvcprint('subfig', 'a', 'opengl')




