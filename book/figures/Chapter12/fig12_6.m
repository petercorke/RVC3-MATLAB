
church = iread('church.png', 'grey');
clf
ihist( church, 'b' )
grid on
vertline(180)
rvcprint('subfig', 'a', 'thicken', 1.5)

clf
ihist(church, 'cdf', 'b');
nn=inormhist(church);
hold on
[n,v] = ihist(nn, 'cdf');
plot(v, n, 'r');
h = legend('original', 'normalized', 'Location', 'Southeast')
h.FontSize = 12;
grid
xaxis(0, 255);
ylabel('cumulative number of pixels')

rvcprint('subfig', 'b', 'thicken', 1.5)
