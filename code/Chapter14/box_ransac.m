x = linspace(0, 10, 10);
y = 3*x - 10;
clf
plot(x,y)
grid
pause(1)

randinit
k=randi([2 length(x)-2], 5, 1)
y(k) = y(k) + randn(size(k'))*00 + rand(size(k'))*10;
% y(4) = 15;
plot(x,y, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8)
[m,c]=regres(x,y)
hold on
plot(x, m*x+c, 'b--')

[th,inliers] = ransac(@linefit, [x; y], 1e-3)

plot(x, th(1)*x+th(2), 'k')

grid
ylabel('$y = 3x-10$', 'Interpreter', 'latex', 'Fontsize', 16)
xlabel('$x$', 'Interpreter', 'latex', 'Fontsize', 16)
h = legend('data', 'least squares', 'RANSAC', 'Location', 'southeast')
h.FontSize = 14;

rvcprint('thicken', 1.5)