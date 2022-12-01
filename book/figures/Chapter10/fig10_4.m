%% Fig 10.4

% a
clf
[R, lambda] = loadspectrum([100:10:10000]*1e-9, 'redbrick.dat');
plot(lambda*1e6, R, "r");
xlabel('Wavelength (\mu m)');
ylabel('R(\lambda)');
hold on
xline(0.4, '--');
xline(0.7, '--');
grid on
rvcprint3('fig10_4a', 'thicken', 1.5)

% b
[R2, lambda2] = loadspectrum([300:10:700]*1e-9, 'redbrick.dat');
plot(lambda2*1e9, R2, "r") 
xaxis(400, 700);
xlabel('Wavelength (nm)');
ylabel('R(\lambda)');
grid on
rvcprint3('fig10_4b', 'thicken', 1.5)