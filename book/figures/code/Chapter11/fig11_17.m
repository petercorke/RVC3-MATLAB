% Fig 11.17

castle = im2double(imread('castle.png'));

Dv = fspecial('sobel');

derOfGKernel = imfilter(Dv, fspecial('gaussian', 5, 2), 'conv', 'full');
Iv = imfilter(castle, derOfGKernel, "conv");
Iu = imfilter(castle, derOfGKernel', "conv");

m = sqrt(Iu.^2 + Iv.^2);

surfl(318:408, 550:622, m(318:408,550:622)')
colormap(bone)
shading interp
xlabel('u')
ylabel('v')

xaxis(318,408)
yaxis(550,622)
zlabel('Edge magnitude')
view(104, 61)


rvcprint3('opengl', 'fig11_17');
