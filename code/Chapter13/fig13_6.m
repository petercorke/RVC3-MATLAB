im_targets = iread('yellowtargets.png'); %, 'gamma', 'sRGB');
idisp(im_targets, 'nogui')
rvcprint('subfig', 'a', 'svg');

randinit
nc = 2;
[cls, cab,resid] = colorkmeans(im_targets, nc, 'Lab');
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

clf
showcolorspace('Lab', cab);
rvcprint('subfig', 'c', 'svg');

colorname(cab(:,1)', 'ab')


cls1 = (cls == 1);
idisp(cls1, 'nogui', 'black', 0.3)
rvcprint('subfig', 'd', 'svg');

targets_binary = iopen(cls1, kcircle(2));
idisp(targets_binary, 'nogui', 'black', 0.3)
rvcprint('subfig', 'e', 'svg');
