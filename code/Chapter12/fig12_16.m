castle = iread('castle_sign.jpg', 'double', 'grey');
idisp(castle, 'nogui'); hold on; plot([0,size(castle,2)], [360 360], 'g')
rvcprint('subfig', 'a','thicken', 1.5, 'svg')

clf
p = castle(360,:);
plot(p);
xlabel('u (pixels)')
ylabel('Pixel value')
xaxis(0, size(castle,2))
rvcprint('subfig', 'b', 'thicken', 1.5)


plot(p, '-o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b')
xaxis(560,610)
ylabel('Pixel value')
xlabel('u (pixels)')
rvcprint('subfig', 'c', 'thicken', 1.5)

plot(diff(p), '-o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b')
xaxis(560,610)
xlabel('u (pixels)')
ylabel('Derivative of grey value')
rvcprint('subfig', 'd', 'thicken', 1.5)
