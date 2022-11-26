%%
clf
lambda = [300:10:1000]*1e-9;

sun = blackbody(lambda, 5778);
scale=.58e-4
sun_ground = loadspectrum(lambda, 'solar.dat');
set(gcf, 'defaultAxesColorOrder', [0 0 1; 1 0 0]);

yyaxis left
plot(lambda*1e9, sun_ground, '-', lambda*1e9, sun*scale, '--')
ylabel('E(\lambda) (W sr^{-1} m^{-2} m^{-1})');

yyaxis right
plot(lambda*1e9, rluminos(lambda))


xlabel('Wavelength (nm)');

xaxis(300,1000)
legend('sun at ground level', 'sun blackbody', 'human eye response')
rvcprint('subfig', 'a', 'thicken', 1.5)

%%
clf
[A, lambda] = loadspectrum([400:10:700]*1e-9, 'water.dat');
d = 5;
T = 10.^(-A*d);
plot(lambda*1e9, T);
grid on
xaxis(400, 700)
xlabel('Wavelength (nm)')
ylabel('T(\lambda)')
rvcprint('subfig', 'b', 'thicken', 1.5)