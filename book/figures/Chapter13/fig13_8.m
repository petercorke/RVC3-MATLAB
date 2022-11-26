im = iread('multiblobs.png');
idisp(im, 'nogui', 'black', 0.3)
rvcprint('subfig', 'a', 'svg');


[label,m] = ilabel(im);

nc = m;
clf
idisp(label, 'nogui')
colormap( jet(nc) )
c = colorbar;
c.Label.String = 'Label';
c.TicksMode = 'manual';
c.Label.FontSize = 10;
c.Ticks = [1:nc]*(nc-1)/nc-(nc-1)/(2*nc)+1;
lab = {};
for i=1:nc
    lab = [lab num2str(i)];
end
c.TickLabels = lab;
rvcprint('subfig', 'b', 'svg');

reg3 = label == 3;
idisp(reg3, 'nogui', 'black', 0.3)
rvcprint('subfig', 'c', 'svg');

sum(reg3(:))


[label, m, parents, cls] = ilabel(im);

parents'
cls'
