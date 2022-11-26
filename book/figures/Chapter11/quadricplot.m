d=[-10:0.2:10];
[X,Y,Z]=meshgrid(d,d,d);
F=X.*X + Y.*Y + Z.*Z -2*X+2*Y-4*Z + 5.5*ones(size(X));
isosurface(X,Y,Z,F,0)

zaxis(0, 10)
xaxis(-5, 5)
yaxis(-5, 5)
grid