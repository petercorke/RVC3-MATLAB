T1 = transl(-0.1, 0, 0) * troty(0.4);
cam1 = CentralCamera('name', 'camera 1', 'default', ...
    'focal', 0.002, 'pose', T1)
T2 = transl(0.1, 0,0)*troty(-0.4);
cam2 = CentralCamera('name', 'camera 2', 'default', ...
    'focal', 0.002, 'pose', T2);
figure
axis([-0.4 0.6 -0.5 0.5 -0.2 1])
cam1.plot_camera('color', 'b', 'label')
cam2.plot_camera('color', 'r', 'label')
P=[0.5 0.1 0.8]';
plot_sphere(P, 0.03, 'b');
grid on
xyzlabel
view(-24, 26)

rvcprint