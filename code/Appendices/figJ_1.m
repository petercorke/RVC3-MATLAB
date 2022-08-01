load peakfit1
plot(y,  '-o', 'MarkerFaceColor', 'b')
xlabel('k'); ylabel('y_k');

rvcprint('here', 'subfig', 'a', 'thicken', 1.5)

[ypk,k] = max(y)
[ypk,k] = peak(y)
ypk(2)/ypk(1)
[ymax,k] = peak(y, 'interp', 2)
clf; peak(y, 'interp', 2, 'plot')
xaxis(5,11)
xlabel('k'); ylabel('y_k');
legend('data', 'fitted parabola', 'estimated peak')

rvcprint('here', 'subfig', 'b', 'thicken', 1.5)


peak(y, 'scale', 5)
z
[zmax,i] = max(z(:))
[ymax,xmax] = ind2sub(size(z), i)
[zm,xy]=peak2(z)
[zm,xy]=peak2(z, 'interp')