im = iread('notre-dame.jpg', 'double');

p1 =   [44.1364  377.0654; 94.0065  152.7850; 537.8506  163.4019;  611.8247  366.4486]';
idisp(im, 'nogui');
hold on

plot_poly(p1, 'wo', 'fill', 'b', 'alpha', 0.2);
mn = min(p1');
mx = max(p1');
p2 = [mn(1) mx(2); mn(1) mn(2); mx(1) mn(2); mx(1) mx(2)]';
plot_poly(p2, 'k', 'fill',  'r', 'alpha', 0.2)
plot_point(p1, 'wo');

rvcprint('svg')
