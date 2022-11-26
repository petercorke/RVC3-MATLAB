
b = 0.160; % m
f = 3740; % pixels
di = di*2 + 274;
[U,V] = imeshgrid(L);
u0 = size(L,2)/2; v0 = size(L,1)/2;

X = b*(U-u0) ./ di; Y = b*(V-v0) ./ di; Z = f * b ./ di;
clf
surf(Z)
shading interp;
view(-84, 44)
set(gca,'ZDir', 'reverse'); set(gca,'XDir', 'reverse')
colormap(parula)
h = colorbar
h.Label.String = 'Distance (m)';
h.Label.FontSize = 10;
xyzlabel


rvcprint('svg')