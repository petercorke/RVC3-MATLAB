
clf
histogram(sim(:), 'Normalization', 'cdf', 'EdgeColor', 'none')
xlabel('ZNCC similarity'); ylabel('Cumulative distribution');
vertline(0.6)
vertline(0.9)

rvcprint('thicken', 1.5)