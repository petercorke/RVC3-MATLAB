im = iread('church.png', 'grey', 'double');
edges = icanny(im);
h = Hough(edges, 'suppress', 10);
lines = h.lines();
lines = lines.seglength(edges, 5);
lines(1)

idisp(im, 'nogui', 'dark');

lines(1:10).plot('g');

k = find( lines.length > 80);

lines(k).plot('b--');



rvcprint('thicken', 1.5, 'svg')

% im = iread('church.png', 'grey', 'double');
% edges = isobel(im);
% t=otsu(edges)
% 
% 
% idisp(edges>t)
% 
% h = Hough(edges, 'suppress', 5);
% lines = h.lines();
% lines = lines.seglength(edges, 10);
% lines(1)
% 
% idisp(im, 'nogui', 'dark');
% 
% lines(1:10).plot('g');
% 
% % k = find( lines.length > 80);
% % 
% % lines(k).plot('b--');
% 
% 
% 
% rvcprint('thicken', 1.5)