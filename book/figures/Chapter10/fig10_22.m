%clear

lambda = [400:5:700]*1e-9;
macbeth = loadspectrum(lambda, 'macbeth');

d65 = loadspectrum(lambda, 'D65') * 3e9;

clear XYZ Lab

for i=1:18
    L = macbeth(:,i) .* d65;
    tristim = max( cmfrgb(lambda, L), 0);
    RGB = igamm(tristim, 0.45);
    if max(RGB) > 1
        error('scene is too bright')
    end
    
    XYZ(i,:) = colorspace('RGB->XYZ', RGB);
    Lab(i,:) = colorspace('RGB->Lab', RGB);
end




xy = XYZ(:,1:2) ./ (sum(XYZ,2)*[1 1]);
ab = Lab(:,2:3);

close all
figure
showcolorspace('xy', xy');

rvcprint('opengl', 'subfig', 'a');
xaxis(.15, .5); yaxis(.15, .5)
rvcprint('opengl', 'subfig', 'b');

figure
showcolorspace('Lab', ab');
rvcprint('subfig', 'c');
xaxis(-50, 50); yaxis(-50, 60)
rvcprint('subfig', 'd');