%% Fig 10.16

lambda = [400:10:700]'*1e-9;
R = loadspectrum(lambda, 'redbrick.dat');
sun = loadspectrum(lambda, 'solar.dat');
lamp = blackbody(lambda, 2600);
xy_sun = lambda2xy(lambda, sun .* R)

%showcolorspace('xy');
plotChromaticity
hold on
grid on
h(1) = plot2(xy_sun, 'kp', 'MarkerSize', 9);
xy_lamp = lambda2xy(lambda, lamp .* R)
h(2) = plot2(xy_lamp, 'ko', 'MarkerSize', 7);
[R,lambda] = loadspectrum([400:5:700]*1e-9, 'redbrick.dat');
sun = loadspectrum(lambda, 'solar.dat');
A = loadspectrum(lambda, 'water.dat');
d = 2
T = 10 .^ (-d*A);
L = sun  .* R .* T;
xy_water = lambda2xy(lambda, L)
h(3) = plot2(xy_water, 'kd', 'MarkerSize', 7);
h = legend(h, 'sun', 'tungsten', 'underwater', 'Location', 'northeast');
h.FontSize = 12;
rvcprint3('fig10_16'); 
