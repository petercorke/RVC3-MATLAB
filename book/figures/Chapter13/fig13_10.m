im = iread('58060.jpg');
idisp(im, 'nogui');
rvcprint('subfig', 'a', 'svg');

[label, m] = igraphseg(im, 1500, 100, 0.5);
m
nc = m;
idisp(label, 'colormap', jet(nc), 'nogui')
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
