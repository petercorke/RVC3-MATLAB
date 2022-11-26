fisheye = iread('fisheye_target.png', 'double', 'grey');
u0 = 528.1214; v0 = 384.0784;
l=2.7899;
m=996.4617;
[Ui,Vi] = imeshgrid(fisheye);
n = 500;
theta_range = linspace(0, pi, n);
phi_range = linspace(-pi, pi, n);
[Phi,Theta] = meshgrid(phi_range, theta_range);

r = (l+m)*sin(Theta) ./ (l-cos(Theta));
U = r.*cos(Phi) + u0;
V = r.*sin(Phi) + v0;
spherical = interp2(Ui, Vi, fisheye, U, V);

%% render perspective image
W = 1000;
m = W / 2 / tan(45/2*pi/180)
l = 0;
u0 = W/2; v0 = W/2;
[Uo,Vo] = meshgrid(0:W-1, 0:W-1);


[phi,r] = cart2pol(Uo-u0, Vo-v0);

Phi_o = phi;
Theta_o = pi - atan(r/m);

perspective = interp2(Phi, Theta, spherical, Phi_o, Theta_o);
idisp(perspective, 'nogui')
rvcprint('subfig', 'a', 'nogrid')

%% different view

spherical0 = spherical;
spherical = sphere_rotate(spherical0, se3(rotmy(0.9))*se3(rotmz(-1.5)));

W = 1000;
m = W / 2 / tan(45/2*pi/180)
l = 0;
u0 = W/2; v0 = W/2;
[Uo,Vo] = meshgrid(0:W-1, 0:W-1);


[phi,r] = cart2pol(Uo-u0, Vo-v0);

Phi_o = phi;
Theta_o = pi - atan(r/m);

perspective = interp2(Phi, Theta, spherical, Phi_o, Theta_o);
idisp(perspective, 'nogui')

rvcprint('subfig', 'b', 'nogrid')
