flowers = iread('flowers4.png', 'double');
idisp(flowers, 'nogui', 'noaxes')
rvcprint('subfig', 'a', 'format', 'png');

XYZ = colorspace('RGB->XYZ', flowers);
[x,y] = tristim2cc(XYZ);
% vx = [0 0.01 100];  vy = [0 0.01 100];
% [h,vx,vy] = hist2d(x, y, vx, vy);
[N,X,Y] = histcounts2(x,y);
dx = X(2)-X(1); dy = Y(2)-Y(1);
clf
xycolorspace
hold on
contour(Y(2:end)-dy/2, X(2:end)-dx/2, N)
rvcprint('subfig', 'b')

randinit
[cls, cxy] = colorkmeans(flowers, 6);
idisp(cls, 'colormap', 'jet', 'nogui', 'noaxes')
rvcprint('subfig', 'c', 'format', 'png')


xycolorspace
plot_point(cxy, '*', 'sequence', 'textsize', 10, 'textcolor', 'b')
grid
xlabel('x')
ylabel('y')
rvcprint('subfig', 'd')

%idisp(ipixswitch(cls==1|cls==2, flowers, 1), 'nogui', 'noaxes')
idisplabel(flowers, cls, 5, 'nogui', 'noaxes')
rvcprint('subfig', 'e', 'format', 'png')

colorname(cxy', 'xy')