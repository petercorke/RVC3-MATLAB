% Section 11.4 Diadic Operations

subject = im2double(imread('greenscreen.jpg'));

%% Fig 11.9a
imshow(subject);
rvcprint3('fig11_9a');
close all;

imlab = rgb2lab(subject);
astar = imlab(:,:,2);
histogram(astar(:))

mask = astar > -15;

%% Fig 11.9b
xlabel('a*');
ylabel('Number of pixels');
rvcprint3('fig11_9b');
close all;

%% Fig 11.9c
imshow(mask)
rvcprint3('fig11_9c');
close all;

%% Fig 11.9d
imshow(mask .* subject);
bg = im2double(imread('desertRoad.png'));

bg = imresize(bg, size(subject, [1 2]));
imshow(bg .* (1-mask))

imshow(subject.*mask + bg.*(1-mask))

rvcprint3('fig11_9d');

