sharks = iread('sharks.png');
[label, m] = ilabel(sharks);

blob = (label == 2);

sum(blob(:))
[v,u] = find(blob);
about(u)

umin = min(u)
umax = max(u)
vmin = min(v)
vmax = max(v)
m00 = mpq(blob, 0, 0)
uc = mpq(blob, 1, 0) / m00
vc = mpq(blob, 0, 1) / m00


idisp(sharks, 'nogui', 'black', 0.3);

rvcprint('subfig', 'a', 'svg');

%
idisp(blob, 'nogui', 'black', 0.3);

plot_box(umin, vmin, umax, vmax, 'g')
hold on; plot(uc, vc, 'gx', uc, vc, 'go');
rvcprint('subfig', 'b', 'thicken', 1.5, 'svg');

% idisp(blob, 'nogui', 'black', 0.3);
% plot_box(umin, vmin, umax, vmax, 'g')
% 
% rvcprint('subfig', 'a', 'svg');
% 
% xaxis(300, 450); yaxis(150, 300);
% rvcprint('subfig', 'b', 'thicken', 1.5, 'svg');