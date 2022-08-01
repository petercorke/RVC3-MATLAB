d = istereo(L, R, [40, 90], 3);
d(isnan(d)) = Inf;
idisp(d, 'nogui')
c=colormap;
c=[c; 1 0 0];
colormap(c)
h = colorbar;
h.Label.String = 'Disparity (pixels)';
h.Label.FontSize = 10;

rvcprint('svg')
rvcprint('opengl')