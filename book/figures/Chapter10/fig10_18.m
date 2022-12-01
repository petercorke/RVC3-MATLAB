%% Fig 10.18
clf
lambda = [400:10:700]'*1e-9;
R = loadspectrum(lambda, 'redbrick.dat');
sun = loadspectrum(lambda, 'solar.dat');
A = loadspectrum(lambda, 'water.dat');
d = 2
T = 10 .^ (-d*A);
L = sun  .* R .* T;
plot(lambda*1e9, L, 'b');
hold on
plot(lambda*1e9, sun .* R, 'r');
xaxis(400, 700);
h = legend('Underwater', 'In air', 'Location', 'northwest');
h.FontSize = 12;
xlabel('Wavelength (nm)');
ylabel('Luminance L(\lambda)')
grid on
rvcprint3('fig10_18', 'thicken', 1.5)

