clf
subplot(311)
l = [350:5:800]*1e-9;
E = loadspectrum(l, 'solar.dat');
R = loadspectrum(l, 'redbrick.dat');
C = loadspectrum(l, 'cones.dat');

plot(l*1e9, E, 'linewidth', 1.5)
xaxis(350,750);  ylabel('illuminance')
grid on

subplot(312)
plot(l*1e9, E.*R, 'linewidth', 1.5)
xaxis(350,750); ylabel('luminance')
grid on

subplot(313)

C(isnan(C)) = 0;
alpha = 0.7;
L = E.*R;
% for some reason area() doesn't work for this particular curve...
area(l*1e9, L.*C(:,1), 'FaceColor', [1 0 0], 'FaceAlpha', alpha, 'EdgeColor', 'none')
hold on
area(l*1e9, L.*C(:,2), 'FaceColor', [0 1 0], 'FaceAlpha', alpha, 'EdgeColor', 'none')
area(l*1e9, L.*C(:,3), 'FaceColor', [0 0 1], 'FaceAlpha', alpha, 'EdgeColor', 'none')
xaxis(350,750); xlabel('Wavelength (nm)'); ylabel('cone response')
grid on

rvcprint('opengl')