crowd = iread('wheres-wally.png', 'double');
idisp(crowd)

T = iread('wally.png', 'double');
idisp(T)

S = isimilarity(T, crowd, @zncc);
idisp(S, 'nogui')
c = colorbar
c.Label.String = 'similarity';
c.Label.FontSize = 10;

[p,mx] = peak2(S, 1, 'npeaks', 5);
p
plot_circle(mx, 30, 'g', 'LineWidth', 2)
plot_point(mx, 'w', 'sequence', 'bold', 'textsize', 24, 'textcolor', 'y')

rvcprint('opengl')

% clf
% idisp(crowd, 'nogui');
% plot_circle(p, 30, 'fillcolor', 'b', 'alpha', 0.3, 'edgecolor', 'none')
% plot_point(p, 'sequence', 'bold', 'textsize', 24, 'textcolor', 'k')
