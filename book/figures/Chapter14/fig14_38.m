%di = istereo(Lr, Rr, [5 120], 4, 'interp');
%di = istereo(Lr, Rr, [180 470], 4, 'interp');
di = istereo(Lr, Rr, [180 530], 7, 'interp');
di(isnan(di)) = Inf;

idisp(di, 'nogui')
c=colormap;
c=[c; 1 0 0];
colormap(c)
h = colorbar;
h.Label.String = 'Disparity (pixels)';
h.Label.FontSize = 10;

rvcprint('svg')