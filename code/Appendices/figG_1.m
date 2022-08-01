
x = linspace(-6, 6, 500);

clf
plot(x, gaussfunc(0, 1, x), 'r' )
hold on
plot(x, gaussfunc(0, 2^2, x), 'b')
xlabel('x');
ylabel('g(x)');
s = 1; g1=1/(s*sqrt(2*pi))*exp(-(s).^2/2/s^2);
g = gaussfunc(0, s^2, x);
plot([-6 6], [g1 g1], 'r--')
k = find( zcross(g-g1));
plot(x(k), g(k), 'o', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
s = 2; g2=1/(s*sqrt(2*pi))*exp(-(s).^2/2/s^2);
g = gaussfunc(0, s^2, x);
plot([-6 6], [g2 g2], 'b--')
k = find( zcross(g-g2));
plot(x(k), g(k), 'o', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
h = legend('\sigma=1', '\sigma=2');
h.FontSize = 12;
rvcprint('here');
