s = linspace(-3, 3, 20);

[X,Y] = meshgrid(s, s);

[th,r] = cart2pol(X, Y);

d = 1- r;

clf
surf(X,Y, d)
hold on
surf(X,Y, d*0, 'FaceColor', [1 0 0], 'FaceAlpha', 0.5, 'EdgeColor', 'none')
zaxis(-3, 1)
xlabel('x'); ylabel('y')
zlabel('signed distance function')

rvcprint('-opengl');