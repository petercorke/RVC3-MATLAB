p1b = homtrans(inv(H), p2);
Q = [
   -0.2302   -0.0545    0.2537
    0.3287    0.4523    0.6024
    0.4000    0.5000    0.6000  ];
figure
axis([-1 1 -1 1 -0.2 1.8])
plot_sphere(P, 0.05, 'b')
plot_sphere(Q, 0.05, 'r')
cam1.plot_camera('color', 'b', 'label')
cam2.plot_camera('color', 'r', 'label')
view(-22,12);
grid
xyzlabel


rvcprint