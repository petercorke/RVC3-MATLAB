im_garden = iread('tomato_124.jpg'); %, 'gamma', 'sRGB');
idisp(im_garden, 'nogui')
rvcprint('subfig', 'a', 'svg');

randinit
nc = 3;
[cls, cab,resid] = colorkmeans(im_garden, nc, 'Lab');
cab
resid

clf
idisp(cls, 'nogui')
colormap( flag(nc) )
c = colorbar;
c.Label.String = 'Class';
c.Label.FontSize = 10;
c.TicksMode = 'manual';
c.Ticks = [1:nc]*(nc-1)/nc-(nc-1)/(2*nc)+1;
lab = {};
for i=1:nc
    lab = [lab num2str(i)];
end
c.TickLabels = lab;
rvcprint('subfig', 'b', 'svg');

colorname(cab(:,2)', 'ab')

clf
showcolorspace('Lab', cab);
rvcprint('subfig', 'c', 'svg');

cls2 = (cls == 2);
idisp(cls2, 'nogui', 'black', 0.3)
rvcprint('subfig', 'd', 'svg');

tomatoes_binary = cls2;
tomatoes_binary = iclose(tomatoes_binary, kcircle(15));
idisp(tomatoes_binary, 'nogui', 'black', 0.3)
rvcprint('subfig', 'e', 'svg');
