[di,sim,peak] = istereo(L, R, [40 90], 3, 'interp');

di(isnan(di)) = Inf;
idisp(di, 'nogui')
c=colormap;
c=[c; 1 0 0];
colormap(c)
h = colorbar;
h.Label.String = 'Disparity (pixels)';
h.Label.FontSize = 10;

rvcprint('subfig', 'a', 'svg')

A = peak.A;
A(isnan(A)) = Inf;
idisp(abs(A), 'nogui')
c=colormap;
c=[c; 1 0 0];
colormap(c)
h = colorbar;
h.Label.String = '|A| (peak sharpness)';
h.Label.FontSize = 10;

rvcprint('subfig', 'b', 'svg')