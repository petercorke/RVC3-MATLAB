clf
lambda = [350:750]*1e-9;
cmf = cmfrgb(lambda);
clf; hold on
plot(lambda*1e9, cmf(:,1), 'r');
plot(lambda*1e9, cmf(:,2), 'g');
plot(lambda*1e9, cmf(:,3), 'b');
xlabel('Wavelength (nm)')
ylabel('Color matching function');
h = legend('CIE red', 'CIE green', 'CIE blue');
h.FontSize = 12;
rvcprint('thicken', 1.5);
