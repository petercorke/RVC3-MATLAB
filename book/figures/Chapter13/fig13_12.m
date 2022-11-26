

m00 = mpq(blob, 0, 0)
uc = mpq(blob, 1, 0) / m00
vc = mpq(blob, 0, 1) / m00

u20 = upq(blob, 2, 0); u02 = upq(blob, 0, 2); u11 = upq(blob, 1, 1);
J = [ u20 u11; u11 u02]
lambda = eig(J)
ab = 2 * sqrt(lambda / m00)
ab(1)/ab(2)
[x,lambda] = eig(J);
x
v = x(:,end);
atan2( v(2), v(1) )

clf
idisp(blob, 'nogui', 'black', 0.3);
hold on
plot(uc, vc, 'x'); plot(uc, vc, 'o');


plot_box(umin, vmin, umax, vmax, 'g')
plot_ellipse(4*J/m00, [uc, vc], 'edgecolor', 'b', 'LineWidth', 2);


rvcprint('subfig', 'a', 'svg');

xaxis(400, 600); yaxis(100, 300);
rvcprint('subfig', 'b', 'thicken', 2, 'svg');