close all
clear

panda = loadrobot("frankaEmikaPanda", DataFormat="row");

TE = se3(trvec2tform([0.7 0.2 0.1])) * ...
    se3(oa2tform([0 1 0], [0 0 -1]));

ik = inverseKinematics(RigidBodyTree=panda); 
rng(0);
qsol = ik("panda_hand", TE.tform, ones(1,6), panda.homeConfiguration);

figure;
panda.show(qsol)

xlim([-0.5 1])
ylim([-0.5 0.5])
zlim([-0.1 0.5])

view(138.43, 13.56)
set(gca,"CameraViewAngle",8)

rvcprint("opengl")