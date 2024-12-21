%% Fig 10.5

clf
lambda = [400:10:700]*1e-9;        % visible spectrum
E = loadspectrum(lambda, 'solar.dat');
R = loadspectrum(lambda, 'redbrick.dat');
L = E .* R;
plot(lambda*1e9, L);
xlabel('Wavelength (nm)')
ylabel('W sr^{-1} m^{-2} m^{-1}');
xaxis(400, 700);
grid on
rvcprint3('fig10_5', 'thicken', 1.5)
