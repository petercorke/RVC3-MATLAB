castle = im2double(imread('castle.png'));

fontSize = 22; % everything in 11.16* except quiver which is fontSize-6
% Fig 11.16a
Dv = fspecial('sobel')
Iv = imfilter(castle, Dv, 'conv');
imshow(Iv,[]);
xlabel('u (pixels)', FontSize=fontSize);
ylabel('v (pixles)', FontSize=fontSize);
colorbar(fontsize=fontSize);
rvcprint3('fig11_16a');

% Fig 11.16b
Iu = imfilter(castle, Dv', 'conv');
imshow(Iu,[]);
xlabel('u (pixels)', FontSize=fontSize);
ylabel('v (pixles)', FontSize=fontSize);
colorbar(fontsize=fontSize);
rvcprint3('fig11_16b');

derOfGKernel = imfilter(Dv, fspecial('gaussian', 5, 2), 'conv', 'full');
Iv = imfilter(castle, derOfGKernel, "conv");
Iu = imfilter(castle, derOfGKernel', "conv");

m = sqrt(Iu.^2 + Iv.^2);

% Fig 11.16c
imshow(m, []);
xlabel('u (pixels)', FontSize=fontSize);
ylabel('v (pixles)', FontSize=fontSize);
rvcprint3('fig11_16c');

% Fig 11.16d
th = atan2(Iv, Iu);
quiver(1:20:size(th,2), 1:20:size(th,1), ...
       Iu(1:20:end,1:20:end), Iv(1:20:end,1:20:end))
xaxis(1280)
yaxis(960)
smallerSize=10;
xlabel('u (pixels)', FontSize=fontSize-smallerSize); ylabel('v (pixels)', ...
    FontSize=fontSize-smallerSize)
rvcprint3('fig11_16d');
