L = klaplace()
lap = iconv( castle, klog(2) );
idisp(lap, 'invsigned', 'nogui');
rvcprint('subfig', 'a', 'svg');

r = [550 630; 310 390];
idisp(lap, 'invsigned', 'nogui')
xaxis(r(1,:)); yaxis(r(2,:));
rvcprint('subfig', 'b', 'svg');

p = lap(360,570:600);
plot(570:600, p, '-o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
xlabel('u (pixels)')
ylabel('|Laplacian| at v=360')
rvcprint('subfig', 'c');

zc = zcross(lap);
idisp(zc, 'nogui', 'invert');
xaxis(r(1,:)); yaxis(r(2,:));
rvcprint('subfig', 'd', 'svg');
