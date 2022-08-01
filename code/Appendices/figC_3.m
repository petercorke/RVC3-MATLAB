%% C.1.4.2 drawing an ellipse

E = [1 1; 1 2];

clf


th = linspace(0, 2*pi, 50);
y = [cos(th);  sin(th)];
plot(y(1,:), y(2,:), 'r--');
hold on

% x = (sqrtm(E) * y)';
% plot(x(:,1), x(:,2), 'b');
plotellipse(E, 'b')

[x,e] = eig(E)

r = 1 ./ sqrt(diag(e))
p = x(:,1)*r(1);
quiver(0, 0, p(1), p(2), 0, 'k');
p = x(:,2)*r(2);
quiver(0, 0, p(1), p(2), 0, 'k');

axis equal
xlabel('x'); ylabel('y');
grid on
legend('unit circle', 'ellipse', '', '')

rvcprint('here')