%% Fig 10.10

clf
lambda = [350:750]*1e-9;
cmf = cmfrgb(lambda);
clf; hold on
plot(lambda*1e9, cmf(:,1), 'r');
plot(lambda*1e9, cmf(:,2), 'g');
plot(lambda*1e9, cmf(:,3), 'b');
xlabel('Wavelength (nm)')
ylabel('Color matching functions');
h = legend('CIE red', 'CIE green', 'CIE blue');
h.FontSize = 12;
grid on
rvcprint3('fig10_10', 'thicken', 1.5);