[di,sim,peak] = istereo(L, R, [40 90], 3, 'interp');

status = ones(size(d));
[U,V] = imeshgrid(L);
status(U<=90) = 2;
status(sim<0.8) = 3;
status(peak.A>=-0.1) = 4;
status(isnan(d)) = 5;

idisp(status, 'nogui')
colormap( colorname({'lightgreen', 'cyan', 'blue', 'orange', 'red'}) )
nc = 5;
c = colorbar;

c.TicksMode = 'manual';
c.Ticks = [1:nc]*(nc-1)/nc-(nc-1)/(2*nc)+1;
lab = {};

c.TickLabels = {'OK', 'no overlap', 'weak pk', 'broad pk', 'NaN'};

sum(status(:) == 1) / prod(size(status)) * 100


rvcprint('svg')