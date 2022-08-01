lambda = [350:750]*1e-9;

human = luminos(lambda);
plot(lambda*1e9,  human)
luminos(450e-9) / luminos(550e-9)
clf
plot(lambda*1e9,  human)

ylabel('lm/W');
xlabel('Wavelength (nm)');
rvcprint('subfig', 'a', 'thicken', 1.5)

clf
cones = loadspectrum(lambda, 'cones.dat');
plot(lambda*1e9, cones)
plot(lambda*1e9, cones(:,1), 'r')
hold on
plot(lambda*1e9, cones(:,2), 'g')
plot(lambda*1e9, cones(:,3), 'b')
grid on

xlabel('Wavelength nm)')
ylabel('Cone response')
h = legend('red (L) cone', 'green (M) cone', 'blue (S) cone');
h.FontSize = 12;
rvcprint('subfig', 'b', 'thicken', 1.5)
