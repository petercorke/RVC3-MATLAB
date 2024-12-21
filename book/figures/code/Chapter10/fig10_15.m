%% Fig 10.15

flowers = im2double(imread('flowers4.png'));
imshow(flowers, 'Border', 'tight')
rvcprint3('fig10_15a');

hsv = rgb2hsv(flowers);
imshow(hsv(:,:,1), 'Border', 'tight')
rvcprint3('fig10_15b');

imshow(hsv(:,:,2), 'Border', 'tight')
rvcprint3('fig10_15c');

lab = rgb2lab(flowers);
imshow(lab(:,:,1), [], 'Border', 'tight')
rvcprint3('fig10_15d');

imshow(lab(:,:,2), [], 'Border', 'tight')
rvcprint3('fig10_15e');

imshow(lab(:,:,3), [], 'Border', 'tight')
rvcprint3('fig10_15f');

