%%
clf
[R, lambda] = loadspectrum([100:10:10000]*1e-9, 'redbrick.dat');
plot(lambda*1e6, R);
xlabel('Wavelength (\mu m)');
ylabel('R(\lambda)');
hold on
vertline(0.4);
vertline(0.7);
rvcprint('subfig', 'a', 'thicken', 1.5)

%%
[R2, lambda2] = loadspectrum([300:10:700]*1e-9, 'redbrick.dat');
plot(lambda2*1e9, R2); xaxis(400, 700);
xlabel('Wavelength (nm)');
ylabel('R(\lambda)');
rvcprint('subfig', 'b', 'thicken', 1.5)
