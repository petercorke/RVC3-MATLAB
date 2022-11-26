%% Fig 10.2

lambda = [300:10:1000]*1e-9;

for T=1000:1000:6000
plot( lambda*1e9, blackbody(lambda, T)), hold on
end

xaxis(300,1000)
h = legend('3000K', '4000K', '5000K', '6000K');
h.FontSize = 12;
xlabel('Wavelength (nm)')
ylabel('E(\lambda) (W sr^{-1} m^{-2} m^{-1})');
grid on

% 10.2a
rvcprint3('eps', 'fig10_2a', 'thicken', 1.5)

clf
lamp = blackbody(lambda, 2600);
sun = blackbody(lambda, 5778);
plot(lambda*1e9, [lamp/max(lamp) sun/max(sun)])
hold on
plot(lambda*1e9, rluminos(lambda), 'g--');
xlabel('Wavelength (nm)');
ylabel('Normalized E(\lambda)');
xaxis(300,1000)
yaxis(0,1)
legend('Tungsten lamp (2600K)', 'Sun (5778K)', 'Human perceived brightness', 'Location', 'southeast');
grid on

% 10.2b
rvcprint3('eps', 'fig10_2b', 'thicken', 1.5)