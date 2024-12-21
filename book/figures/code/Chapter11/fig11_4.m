%% Fig 11.4

% fig A
clf

subplot(2,2,1)
im = testpattern('rampx', 256, 2);
imshow(im, 'Border', 'tight');

subplot(2,2,2)
im = testpattern('siny', 256, 2);
imshow(im, 'Border', 'tight');

subplot(2,2,3)
im = testpattern('squares', 256, 50, 25);
imshow(im, 'Border', 'tight');

subplot(2,2,4)
im = testpattern('dots', 256, 256, 100);
imshow(im, 'Border', 'tight');

rvcprint3('subfig', 'fig11_4a');

% fig B
canvas = zeros(1000, 1000);
canvas = insertShape(canvas,'FilledRect',[100,100,150,150], 'Opacity', 1, 'Color', [0.5 0.5 0.5]);
canvas = insertShape(canvas,'FilledRect',[300,300,80,80], 'Opacity', 1, 'Color', [0.9 0.9 0.9]);
canvas = insertShape(canvas,'FilledCircle', [700,300,120], 'Opacity', 1, 'Color', [0.7 0.7 0.7]);
canvas = insertShape(canvas,'Line', [100,100,800,800], 'Opacity', 1, 'Color', [0.8 0.8 0.8]);
imshow(canvas)

rvcprint3('fig11_4b');
close all;

