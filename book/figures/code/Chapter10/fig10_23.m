%% Fig 10.23

im = imread('parks.jpg');
imshow(im);
im = rgb2lin(im);
rvcprint3('fig10_23a');

gs = shadowRemoval(im, 0.7, "noexp");
imshow(gs, [], 'border','tight')
rvcprint3('fig10_23b');

