%% Fig 10.22

lambda = [400:5:700]*1e-9;
macbeth = loadspectrum(lambda, 'macbeth');

d65 = loadspectrum(lambda, 'D65') * 3e9;

clear XYZ Lab

for i=1:18
    L = macbeth(:,i) .* d65;
    tristim = max( cmfrgb(lambda, L), 0);
    RGB = imadjust(tristim, [], [], 0.45);
    if max(RGB) > 1
        error('scene is too bright')
    end
    
    XYZ(i,:) = rgb2xyz(RGB);
    Lab(i,:) = rgb2lab(RGB);
end

xy = XYZ(:,1:2) ./ (sum(XYZ,2)*[1 1]);
ab = Lab(:,2:3);

close all
figure
showcolorspace(xy, "xy");

rvcprint3('fig10_22a');
xaxis(.15, .5); yaxis(.15, .5)
rvcprint3('fig10_22b');

figure
showcolorspace(ab, 'Lab');
rvcprint3('fig10_22c');

xaxis(-50, 50); yaxis(-50, 60)
rvcprint3('fig10_22d');
