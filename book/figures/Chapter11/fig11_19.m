% Fig 11.19a
castle = im2double(imread('castle.png'));

L = fspecial('laplacian',0)
lap = imfilter(castle, fspecial('log', [], 2));
imshow(lap,[]);
xlabel('u (pixels)'); ylabel('v (pixels)')
axis on
rvcprint3('fig11_20a');

% Fig 11.20b
r = [550 630; 310 390];
imshow(lap, [])
xaxis(r(1,:)); yaxis(r(2,:));
xlabel('u (pixels)'); ylabel('v (pixels)')
grid on
axis on
rvcprint3('fig11_20b');

% Fig 11.20c
p = lap(360,570:600);
plot(570:600, p, '-o');
xlabel('u (pixels)')
ylabel('|Laplacian| at v=360')
grid on
axis on
rvcprint3('fig11_20c');

% Fig 11.20d
bw = edge(castle, 'log');
imshow(imcomplement(bw));
xaxis(r(1,:)); yaxis(r(2,:));
xlabel('u (pixels)'); ylabel('v (pixels)')
grid on
axis on
rvcprint3('fig11_20d');

close all