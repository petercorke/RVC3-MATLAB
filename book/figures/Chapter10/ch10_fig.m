%% Chapter 10

%% Chapter 10.1










%% Fig 10.3

% a
close all
lambda = [300:10:1000]*1e-9;

sun = blackbody(lambda, 5778);
scale = 0.58e-4;
sunGround = loadspectrum(lambda, 'solar.dat');
set(gcf, 'defaultAxesColorOrder', [0 0 1; 1 0 0]);

yyaxis left
plot(lambda*1e9, sunGround, '-', lambda*1e9, sun*scale, '--')
ylabel('E(\lambda) (W sr^{-1} m^{-2} m^{-1})');

yyaxis right
plot(lambda*1e9, rluminos(lambda))


xlabel('Wavelength (nm)');

xaxis(300,1000)
legend('sun at ground level', 'sun blackbody', 'human perceived brightness')

grid on
rvcprint3('fig10_3a', 'thicken', 1.5)

% b
clf
[A, lambda] = loadspectrum([400:10:700]*1e-9, 'water.dat');
d = 5;
T = 10.^(-A*d);
plot(lambda*1e9, T);
grid on
xaxis(400, 700)
xlabel('Wavelength (nm)')
ylabel('T(\lambda)')

grid on
rvcprint3('fig10_3b', 'thicken', 1.5)

%% Fig 10.4

% a
clf
[R, lambda] = loadspectrum([100:10:10000]*1e-9, 'redbrick.dat');
plot(lambda*1e6, R, "r");
xlabel('Wavelength (\mu m)');
ylabel('R(\lambda)');
hold on
xline(0.4, '--');
xline(0.7, '--');
grid on
rvcprint3('fig10_4a', 'thicken', 1.5)

% b
[R2, lambda2] = loadspectrum([300:10:700]*1e-9, 'redbrick.dat');
plot(lambda2*1e9, R2, "r") 
xaxis(400, 700);
xlabel('Wavelength (nm)');
ylabel('R(\lambda)');
grid on
rvcprint3('fig10_4b', 'thicken', 1.5)

%% Fig 10.5

clf
lambda = [400:10:700]*1e-9;        % visible spectrum
E = loadspectrum(lambda, 'solar.dat');
R = loadspectrum(lambda, 'redbrick.dat');
L = E .* R;
plot(lambda*1e9, L);
xlabel('Wavelength (nm)')
ylabel('W sr^{-1} m^{-2} m^{-1}');
xaxis(400, 700);
grid on
rvcprint3('fig10_5', 'thicken', 1.5)

%% Fig 10.6

% illustration of rod cells and cone cells in human eye

%% Fig 10.7

lambda = [350:750]*1e-9;

human = luminos(lambda);
plot(lambda*1e9,  human)
luminos(450e-9) / luminos(550e-9)
clf
plot(lambda*1e9,  human)

ylabel('lm/W');
xlabel('Wavelength (nm)');
grid on
rvcprint3('fig10_7a', 'thicken', 1.5)

clf
cones = loadspectrum(lambda, 'cones.dat');
plot(lambda*1e9, cones)
plot(lambda*1e9, cones(:,1), 'r')
hold on
plot(lambda*1e9, cones(:,2), 'g')
plot(lambda*1e9, cones(:,3), 'b')
grid on

xlabel('Wavelength (nm)')
ylabel('Cone response (normalized)')
h = legend('red (L) cone', 'green (M) cone', 'blue (S) cone');
h.FontSize = 12;
grid on
rvcprint3('fig10_7b', 'b', 'thicken', 1.5)

%% Fig 10.8 

% Bayer pattern filter

%% Fig 10.9

% tristimulus illustrations

%% Fig 10.10

clf
lambda = [350:750]*1e-9;
cmf = cmfrgb(lambda);
clf; hold on
plot(lambda*1e9, cmf(:,1), 'r');
plot(lambda*1e9, cmf(:,2), 'g');
plot(lambda*1e9, cmf(:,3), 'b');
xlabel('Wavelength (nm)')
ylabel('Color matching functions');
h = legend('CIE red', 'CIE green', 'CIE blue');
h.FontSize = 12;
grid on
rvcprint3('fig10_10', 'thicken', 1.5);

%% Fig 10.11
 
clf
% show locus

[r,g] = lambda2rg( [400:700]*1e-9 );
plot(r, g)
rg_addticks
hold on

% show and label primaries
prim = lambda2rg(cie_primaries);

plot_poly( prim', '--k')
plot(prim(1,1), prim(1,2), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 12);
plot(prim(2,1), prim(2,2), 'ko', 'MarkerFaceColor', 'g', 'MarkerSize', 12);
plot(prim(3,1), prim(3,2), 'ko', 'MarkerFaceColor', 'b', 'MarkerSize', 12);
text(prim(1,1), prim(1,2), '  R', 'FontSize', 12);
text(prim(2,1), prim(2,2), '  G', 'FontSize', 12);
text(prim(3,1), prim(3,2)-0.06, '  B', 'FontSize', 12);

xlabel('r');
ylabel('g');
grid on
rvcprint3('fig10_11', 'thicken', 1.5)

%% Fig 10.12

clf

green_cc = lambda2rg(500e-9);
white_cc = tristim2cc([1 1 1]);

% show locus
[r,g] = lambda2rg( [400:700]*1e-9 );
plot(r, g)
hold on

% show and label primaries
prim = lambda2rg([600, 555, 450]*1e-9);
plot_poly( prim', '--k')
plot(prim(1,1), prim(1,2), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 12);
plot(prim(2,1), prim(2,2), 'ko', 'MarkerFaceColor', 'g', 'MarkerSize', 12);
plot(prim(3,1), prim(3,2), 'ko', 'MarkerFaceColor', 'b', 'MarkerSize', 12);
text(prim(1,1), prim(1,2), '  R''', 'FontSize', 12);
text(prim(2,1), prim(2,2), '  G''', 'FontSize', 12);
text(prim(3,1), prim(3,2)-0.06, '  B''', 'FontSize', 12);

xlabel('r');
ylabel('g');

plot([green_cc(1) white_cc(1)], [green_cc(2) white_cc(2)], 'g')

green_cc = lambda2rg(500e-9);
plot2(green_cc, 'kp', 'MarkerFaceColor', 'g', 'MarkerSize', 10)

white_cc = tristim2cc([1 1 1]);
plot2(white_cc, 'ko', 'MarkerSize', 9)


green = cmfrgb(500e-9);
w = -min(green);
white = [w w w ];

% feasible green
feasible_green = green + white;
feasible_green_cc = tristim2cc(feasible_green);
plot2(feasible_green_cc, 'ks', 'MarkerFaceColor', 'g', 'MarkerSize', 10)

% gamut boundary 
%  - found by picking coordinates from graph
plot2([0.1229 0.4885], 'kv', 'MarkerFaceColor', 'g', 'MarkerSize', 9)

grid on
rvcprint3('fig10_12', 'thicken', 1.5)

%% Fig 10.13

% a
clf
lambda = [350:750]*1e-9;
cmf = cmfxyz(lambda);
plot(lambda*1e9, cmf);
h = legend('CIE X', 'CIE Y', 'CIE Z');
h.FontSize = 12;
xlabel('Wavelength (nm)')
ylabel('Color matching function');
grid on;
rvcprint3('fig10_13a', 'thicken', 1.5);

% b
[x,y] = lambda2xy(lambda);
plot(x, y);
plotChromaticity
rvcprint3('fig10_13b')

%% Fig 10.14

% Plot with annotations on top

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

%% Fig 10.16

lambda = [400:10:700]'*1e-9;
R = loadspectrum(lambda, 'redbrick.dat');
sun = loadspectrum(lambda, 'solar.dat');
lamp = blackbody(lambda, 2600);
xy_sun = lambda2xy(lambda, sun .* R)

%showcolorspace('xy');
plotChromaticity
hold on
grid on
h(1) = plot2(xy_sun, 'kp', 'MarkerSize', 9);
xy_lamp = lambda2xy(lambda, lamp .* R)
h(2) = plot2(xy_lamp, 'ko', 'MarkerSize', 7);
[R,lambda] = loadspectrum([400:5:700]*1e-9, 'redbrick.dat');
sun = loadspectrum(lambda, 'solar.dat');
A = loadspectrum(lambda, 'water.dat');
d = 2
T = 10 .^ (-d*A);
L = sun  .* R .* T;
xy_water = lambda2xy(lambda, L)
h(3) = plot2(xy_water, 'kd', 'MarkerSize', 7);
h = legend(h, 'sun', 'tungsten', 'underwater', 'Location', 'northeast');
h.FontSize = 12;
rvcprint3('fig10_16'); 

%% Fig 10.17 

% NASA color calibration target

%% Fig 10.18
clf
lambda = [400:10:700]'*1e-9;
R = loadspectrum(lambda, 'redbrick.dat');
sun = loadspectrum(lambda, 'solar.dat');
A = loadspectrum(lambda, 'water.dat');
d = 2
T = 10 .^ (-d*A);
L = sun  .* R .* T;
plot(lambda*1e9, L, 'b');
hold on
plot(lambda*1e9, sun .* R, 'r');
xaxis(400, 700);
h = legend('Underwater', 'In air', 'Location', 'northwest');
h.FontSize = 12;
xlabel('Wavelength (nm)');
ylabel('Luminance L(\lambda)')
grid on
rvcprint3('fig10_18', 'thicken', 1.5)

%% Fig 10.19

% Dichromatic reflection

%% Fig 10.20

wedge = [0:0.1:1];
clf
idisp(wedge, 'nogui', 'xydata', {wedge, [0 0.1]})
xlabel(''); ylabel('');
set(gca, 'YTick', [])
daspect([1 1.5 1])

rvcprint3('fig10_20')

%% Fig 10.21

% Mcbeth chart

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

%% Fig 10.23

im = imread('parks.jpg');
imshow(im);
im = rgb2lin(im);
rvcprint3('fig10_23a');

gs = shadowRemoval(im, 0.7, "noexp");
imshow(gs, [], 'border','tight')
rvcprint3('fig10_23b');




