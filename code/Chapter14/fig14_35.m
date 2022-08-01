X = b*(U-u0) ./ di;  Y = b*(V-v0) ./ di; Z = 3740 * b ./ di;
Lcolor = iread('rocks2-l.png');
clf
surface(X, Y, Z, Lcolor, 'FaceColor', 'texturemap', ...
   'EdgeColor', 'none', 'CDataMapping', 'direct')
xyzlabel
set(gca,'ZDir', 'reverse'); set(gca,'XDir', 'reverse')
view(-84, 44)

rvcprint('svg')