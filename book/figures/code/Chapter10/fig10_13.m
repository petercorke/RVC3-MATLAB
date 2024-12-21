%% Fig 10.13

% a
clf
lambda = [350:750]*1e-9;
cmf = cmfxyz(lambda);
plot(lambda*1e9, cmf);
h = legend('CIE X', 'CIE Y', 'CIE Z');
h.FontSize = 12;
xlabel('Wavelength (nm)')
ylabel('Color matching function');
grid on;
rvcprint3('fig10_13a', 'thicken', 1.5);

% b
[x,y] = lambda2xy(lambda);
plot(x, y);
plotChromaticity
rvcprint3('fig10_13b')
