castle = im2double(imread('castle.png'));

% Fig 11.15a
imshow(castle);
axis on;
yline(360, 'g', LineWidth=2)
rvcprint3('fig11_15a');

% Fig 11.15b
p = castle(360,:);
plot(p);
grid on;
xaxis(0, size(castle,2))
xlabel('u (pixels)');
ylabel('Pixel value');
rvcprint3('fig11_15b');

% Fig 11.15c
plot(p, '-o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b')
xaxis(560,610)
ylabel('Pixel value')
xlabel('u (pixels)')
grid on;
rvcprint3('fig11_15c');

plot(diff(p))

% Fig 11.15d
plot(diff(p), '-o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b')
xaxis(560,610)
xlabel('u (pixels)')
ylabel('Derivative of grey value')
grid on;
rvcprint3('fig11_15d');
