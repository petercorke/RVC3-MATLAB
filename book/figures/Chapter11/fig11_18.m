% Fig 11.18 a,b

castle = im2double(imread('castle.png'));

% Fig 11.18a
edges = edge(castle, 'canny');
imshow(imcomplement(edges));
xlabel('u (pixels)'); ylabel('v (pixels)')
axis([400 700 300 600])
grid on
axis on
rvcprint3('fig11_18a');


% Fig 11.18b
Dv = fspecial('sobel');
derOfGKernel = imfilter(Dv, fspecial('gaussian', 5, 2), 'conv', 'full');
Iv = imfilter(castle, derOfGKernel, "conv");
Iu = imfilter(castle, derOfGKernel', "conv");

m = sqrt(Iu.^2 + Iv.^2);

imshow(imcomplement(m>graythresh(m)));
xlabel('u (pixels)'); ylabel('v (pixels)')
axis([400 700 300 600])
grid on
axis on
rvcprint3('fig11_18b');

