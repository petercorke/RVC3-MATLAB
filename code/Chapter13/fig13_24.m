im = iread('scale-space.png', 'double');
idisp(im, 'nogui', 'square', 'black', 0.3);
rvcprint('subfig', 'a', 'svg')

[G,L,s] = iscalespace(im, 60, 2);
k=5
idisp(L(:,:,k), 'invsigned', 'nogui', 'square');  text(10, 180, sprintf('sigma = %.3g', s(k))); hold on; plot(64, 64, 'k+'); plot(128, 64, 'k+'); plot(64, 128, 'k+'); plot(128, 128, 'k+'); hold off; 
rvcprint('subfig', 'b', 'svg')


k=20
idisp(L(:,:,k), 'invsigned', 'nogui', 'square');  text(10, 180, sprintf('sigma = %.3g', s(k))); hold on; plot(64, 64, 'k+'); plot(128, 64, 'k+'); plot(64, 128, 'k+'); plot(128, 128, 'k+'); hold off; 
rvcprint('subfig', 'c', 'svg')

k=35
idisp(L(:,:,k), 'invsigned', 'nogui', 'square');  text(10, 180, sprintf('sigma = %.3g', s(k))); hold on; plot(64, 64, 'k+'); plot(128, 64, 'k+'); plot(64, 128, 'k+'); plot(128, 128, 'k+'); hold off; ;
rvcprint('subfig', 'd', 'svg')

k=55
idisp(L(:,:,k), 'invsigned', 'nogui', 'square');  text(10, 180, sprintf('sigma = %.3g', s(k))); hold on; plot(64, 64, 'k+'); plot(128, 64, 'k+'); plot(64, 128, 'k+'); plot(128, 128, 'k+'); hold off; 
rvcprint('subfig', 'e', 'svg')


clf; plot(s(1:end-1), -[squeeze(L(64,64,:)) squeeze(L(64,128,:)) squeeze(L(128,64,:)) squeeze(L(128,128,:))])
xaxis(s(end))
grid; xlabel('Scale'); ylabel('||LoG||'); 
h = legend('5x5', '9x9', '17x17', '33x33')
h.FontSize = 12;

rvcprint('subfig', 'f', 'thicken', 1.5)


s(5)
f = iscalemax(L, s)
idisp(im)
idisp(im, 'nogui');
f(1:4).plot('g*')
f(1:4).plot_scale('r')