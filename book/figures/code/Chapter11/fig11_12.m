% Section 11.5.1.1 Image Smoothing

mona = rgb2gray(imread("monalisa.png"));

%% Fig 11.12 a,b,c
imshow(mona);
rvcprint3('fig11_12a');

K = ones(21,21) / 21^2;
imshow(imfilter(mona,K, "conv", "replicate"));
rvcprint3('fig11_12b');

K = fspecial('gaussian', 31, 5);
imshow(imfilter(mona, K, "replicate"));
rvcprint3('fig11_12c');
