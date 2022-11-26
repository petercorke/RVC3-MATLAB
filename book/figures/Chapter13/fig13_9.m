[targets_label,m] = ilabel(targets_binary);
m

clf
nc = m;
idisp(targets_label, 'colormap', jet(nc), 'nogui')
c = colorbar;
c.Label.String = 'Label';
c.Label.FontSize = 10;
c.TicksMode = 'manual';
c.Ticks = [1:nc]*(nc-1)/nc-(nc-1)/(2*nc)+1;
lab = {};
for i=1:nc
    lab = [lab num2str(i)];
end
c.TickLabels = lab;
rvcprint('subfig', 'a', 'svg');

[tomatoes_label,m] = ilabel(tomatoes_binary);
m

clf
nc = m;
idisp(tomatoes_label, 'colormap', jet(nc), 'nogui')
c = colorbar;
c.Label.String = 'Label';
c.Label.FontSize = 10;
c.TicksMode = 'manual';
c.Ticks = [1:nc]*(nc-1)/nc-(nc-1)/(2*nc)+1;
lab = {};
for i=1:nc
    lab = [lab num2str(i)];
end
c.TickLabels = lab;
rvcprint('subfig', 'b', 'svg');
