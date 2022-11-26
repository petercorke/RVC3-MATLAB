[C,strength] = icorner(b1, 'nfeat', 200);
s = C.strength;

clf
histogram(s(:), 'Normalization', 'cdf', 'EdgeColor', 'none')
%xaxis(max(x)); yaxis(0.8, 1);
yaxis(0.5, 1)
vertline(max(s)/2)
xlabel('Corner strength');
ylabel('Cumulative number of features');

%(1-interp1(x, ch, strongest/2))*100

rvcprint

