clf
lambda = [350:750]*1e-9;
cmf = cmfxyz(lambda);
plot(lambda*1e9, cmf);
h = legend('CIE X', 'CIE Y', 'CIE Z');
h.FontSize = 12;
xlabel('Wavelength (nm)')
ylabel('Color matching function');
rvcprint('subfig', 'a', 'thicken', 1.5);

[x,y] = lambda2xy(lambda);
plot(x, y);
showcolorspace('xy')
rvcprint('opengl', 'subfig', 'b')
