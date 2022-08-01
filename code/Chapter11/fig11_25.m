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

sphere
h=findobj('Type', 'surface');
set(h,'cdata', spherical, 'facecolor', 'texture');
colormap(gray)
set(h,'CData', flipud(spherical), 'FaceColor', 'texture');

brighten(0.2);

xyzlabel
view(-53, -9)

rvcprint()