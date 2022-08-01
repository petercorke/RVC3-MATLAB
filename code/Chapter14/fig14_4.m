[m,corresp] = sf1.match(sf2);
corresp(:,1:5)
m2 = sf1.match(sf2, 'thresh', []);
histogram(m2.distance, 'Normalization', 'cdf')
xlabel('SURF descriptor distance'); ylabel('Cumulative distributon')
vertline(0.05)

rvcprint('thicken', 1.5)