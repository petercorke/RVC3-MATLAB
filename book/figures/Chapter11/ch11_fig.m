
%% Section 11.2 Image Histograms

% Fig 11.6a
church = rgb2gray(imread('church.png'));
[counts, x] = imhist(church);
figure; bar(x, counts);
grid on

xlabel('Pixel values')
ylabel('Number of pixels')

rvcprint3('fig11_6a');
close all;

%% Section 11.3 Monadic Operations

imd = im2double(church);
im = im2uint8(imd);

flowers = rgb2gray(imread('flowers8.png'));
color = repmat(flowers, [1 1 3]);

color = zeros(size(color), 'like', color);
color(:,:,1) = flowers;

bright = (church >= 180);
imtool(bright)

im = histeq(church);
counts = imhist(church);
plot(cumsum(counts))

% Fig 11.6b
x = imhist(im);
cdf = cumsum(x);
hold on
plot(cdf,'r')
h = legend('Original', 'Normalized', 'Location', 'Southeast');
h.FontSize = 12;
xaxis(0,256);
xlabel('Pixel values')
ylabel('Cumulative number of pixels')
grid

rvcprint3('fig11_6b');


%gc = vision.GammaCorrector(1/0.45, 'Correction', 'De-gamma', 'LinearSegment', false);
%im = gc.step(church);
im = imadjust(church,[],[],1/0.45);

%gc = vision.GammaCorrector(2.4, 'Correction', 'De-gamma', 'BreakPoint', 0.04045);
%im = gc.step(church);

%% Section 11.4 Diadic Operations

subject = im2double(imread('greenscreen.jpg'));

% Fig 11.10a
imshow(subject);
rvcprint3('fig11_10a');
close all;

imlab = rgb2lab(subject);
astar = imlab(:,:,2);
histogram(astar(:))

mask = astar > -15;

% Fig 11.10b
xlabel('a*');
ylabel('Number of pixels');
rvcprint3('fig11_10b');
close all;

% Fig 11.10c
imshow(mask)
rvcprint3('fig11_10c');
close all;

% Fig 11.10d
imshow(mask .* subject);
bg = im2double(imread('desertRoad.png'));

bg = imresize(bg, size(subject, [1 2]));
imshow(bg .* (1-mask))

imshow(subject.*mask + bg.*(1-mask))

rvcprint3('fig11_10d');
close all;

%% Fig 11.11 abc generation
vid = VideoReader('traffic_sequence.mpg');
bg = im2single(im2gray((vid.readFrame)));

sigma = 0.02;
count = 0;
while 1
    im = im2single(im2gray((vid.readFrame)));
	if isempty(im) break; end; % end of file?
	d = im-bg;
	d = max(min(d, sigma), -sigma); % apply c(.)
	bg = bg + d;
	imshow(bg);
    
    count = count + 1;
    if count > 200
        break;
    end
end

imshow(im)
axis on
rvcprint3('fig11_11a');

imshow(bg)
axis on
rvcprint3('fig11_11b');

% Used idisp because it sets up the funky colormap, red for neg, blue for
% pos.; not bothering to recreate it.
idisp(im-bg, 'invsigned', 'nogui')
rvcprint3('fig11_11c');

close all
% End of 11.11 fig generation


%% Section 11.5.1.1 Image Smoothing

mona = rgb2gray(imread("monalisa.png"));

% Fig 11.13 a,b,c
imshow(mona);
rvcprint3('fig11_13a');

K = ones(21,21) / 21^2;
imshow(imfilter(mona,K, "conv", "replicate"));
rvcprint3('fig11_13b');

K = fspecial('gaussian', 31, 5);
imshow(imfilter(mona, K, "replicate"));
rvcprint3('fig11_13c');

% Fig 11.14a
imshow(K, [], 'InitialMagnification', 800);
axis on;
xlabel('u (pixels)'); ylabel('v (pixels)');
rvcprint3('fig11_14a');
close all

surfl(-15:15, -15:15, K)

% Fig 11.14b
h = 15;
surf(-h:h, -h:h, K, K);  shading faceted; 
set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
rvcprint3('fig11_14b');

K = fspecial('disk',8);

% Fig 11.14c
K = padarray(K, [7 7], 0, 'both');
surf(-h:h, -h:h, K, K);  shading faceted; 
set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
rvcprint3('fig11_14c');

% Fig 11.14d
K = kdgauss(5);
surf(-h:h, -h:h, K, K);  shading faceted; 
set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
rvcprint3('fig11_14d');


% Fig 11.14e
K = fspecial('log',31, 5);
% K = padarray(K, [7 7], 0, 'both');
surf(-h:h, -h:h, K, K);  shading faceted; 
set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
rvcprint3('fig11_14e');

% Fig 11.4f
K = kdog(5);
surf(-h:h, -h:h, K, K);  shading faceted; 
set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
rvcprint3('fig11_14f');

close all;

%% Section 11.5.1.2 Boundary Effects

%% Section 11.5.1.3 Edge Detection
castle = im2double(imread('castle.png'));

% Fig 11.16a
imshow(castle);
axis on;
yline(360, 'g', LineWidth=2)
rvcprint3('fig11_16a');

% Fig 11.16b
p = castle(360,:);
plot(p);
grid on;
xaxis(0, size(castle,2))
xlabel('u (pixels)');
ylabel('Pixel value');
rvcprint3('fig11_16b');

% Fig 11.16c
plot(p, '-o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b')
xaxis(560,610)
ylabel('Pixel value')
xlabel('u (pixels)')
grid on;
rvcprint3('fig11_16c');

plot(diff(p))

% Fig 11.16d p381
plot(diff(p), '-o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b')
xaxis(560,610)
xlabel('u (pixels)')
ylabel('Derivative of grey value')
grid on;
rvcprint3('fig11_16d');

close all


fontSize = 22; % everything in 11.17* except quiver which is fontSize-6
% Fig 11.17a
Dv = fspecial('sobel')
Iv = imfilter(castle, Dv, 'conv');
imshow(Iv,[]);
xlabel('u (pixels)', FontSize=fontSize);
ylabel('v (pixles)', FontSize=fontSize);
colorbar(fontsize=fontSize);
rvcprint3('fig11_17a');

% Fig 11.17b
Iu = imfilter(castle, Dv', 'conv');
imshow(Iu,[]);
xlabel('u (pixels)', FontSize=fontSize);
ylabel('v (pixles)', FontSize=fontSize);
colorbar(fontsize=fontSize);
rvcprint3('fig11_17b');

derOfGKernel = imfilter(Dv, fspecial('gaussian', 5, 2), 'conv', 'full');
Iv = imfilter(castle, derOfGKernel, "conv");
Iu = imfilter(castle, derOfGKernel', "conv");

m = sqrt(Iu.^2 + Iv.^2);

% Fig 11.17c
imshow(m, []);
xlabel('u (pixels)', FontSize=fontSize);
ylabel('v (pixles)', FontSize=fontSize);
rvcprint3('fig11_17c');

% Fig 11.17d
th = atan2(Iv, Iu);
quiver(1:20:size(th,2), 1:20:size(th,1), ...
       Iu(1:20:end,1:20:end), Iv(1:20:end,1:20:end))
xaxis(1280)
yaxis(960)
smallerSize=10;
xlabel('u (pixels)', FontSize=fontSize-smallerSize); ylabel('v (pixels)', ...
    FontSize=fontSize-smallerSize)
rvcprint3('fig11_17d');

% Fig 11.18
close all
surfl(318:408, 550:622, m(318:408,550:622)')
colormap(bone)
shading interp
xlabel('u')
ylabel('v')

xaxis(318,408)
yaxis(550,622)
zlabel('Edge magnitude')
view(104, 61)
rvcprint3('opengl', 'fig11_18');

close all

% Fig 11.19 a,b

% Fig 11.19a
edges = edge(castle, 'canny');
imshow(imcomplement(edges));
xlabel('u (pixels)'); ylabel('v (pixels)')
axis([400 700 300 600])
grid on
axis on
rvcprint3('fig11_19a');


% Fig 11.19b
imshow(imcomplement(m>graythresh(m)));
xlabel('u (pixels)'); ylabel('v (pixels)')
axis([400 700 300 600])
grid on
axis on
rvcprint3('fig11_19b');

close all



% Fig 11.20a
L = fspecial('laplacian',0)
lap = imfilter(castle, fspecial('log', [], 2));
imshow(lap,[]);
xlabel('u (pixels)'); ylabel('v (pixels)')
axis on
rvcprint3('fig11_20a');

% Fig 11.20b
r = [550 630; 310 390];
imshow(lap, [])
xaxis(r(1,:)); yaxis(r(2,:));
xlabel('u (pixels)'); ylabel('v (pixels)')
grid on
axis on
rvcprint3('fig11_20b');

% Fig 11.20c
p = lap(360,570:600);
plot(570:600, p, '-o');
xlabel('u (pixels)')
ylabel('|Laplacian| at v=360')
grid on
axis on
rvcprint3('fig11_20c');

% Fig 11.20d
bw = edge(castle, 'log');
imshow(imcomplement(bw));
xaxis(r(1,:)); yaxis(r(2,:));
xlabel('u (pixels)'); ylabel('v (pixels)')
grid on
axis on
rvcprint3('fig11_20d');

close all

%% Section 11.5.2 Template Matching

% Waldo example
crowd = imread('wheres-wally.png');
imshow(crowd)

wally = imread('wally.png');
imshow(wally);

S = normxcorr2(wally, crowd);
imshow(S, []), colorbar

peakFinder = vision.LocalMaximaFinder('MaximumNumLocalMaxima',...
    5, 'NeighborhoodSize', [3 3], 'Threshold', min(S(:)));
uvLoc = peakFinder.step(S);
vals = S(sub2ind(size(S), uvLoc(:,2), uvLoc(:,1)))'

% show best locations in 
labels = "Wally " + string(1:5) + ": " + string(vals);
markedSim = insertObjectAnnotation(S, 'circle', [uvLoc, 10*ones(5,1)], labels , 'FontSize', 21);
imshow(markedSim)

% Original image locations with Wally
% locs = double(uvLoc)-floor(size(wally,[2,1])/2);
% annOriginal = insertObjectAnnotation(crowd, 'circle', [locs, 8*ones(5,1)], labels , 'FontSize', 18, 'color', 'red');
% imshow(annOriginal)

% Fig 11.22
axis on
xlabel('u (pixles)')
ylabel('v (pixles)')
rvcprint3('fig11_22');

close all

%% 11.5.3 Nonlinear Operations

out = nlfilter(mona, [7 7], @(x)var(x(:)) );

mx = ordfilt2(mona, 1, ones(5,5));

med = ordfilt2(mona, 12, ones(5,5));

spotty = imnoise(mona, 'salt & pepper');
imshow(spotty)

% Fig 11.24a
rvcprint3('fig11_24a');


imshow(medfilt2(spotty, [3, 3]))

% Fig 11.24b
rvcprint3('fig11_24b');

%% 11.6 Mathematical Morphology

load eg_morph1.mat
imshow(im, InitialMagnification=800)

S = strel("square", 5);

mn = imerode(im, S);
mx = imdilate(mn, S);

% Fig 11.26 I recreated the figure that's in the book.  eg_morph1 was bad
% xxx Should I redo Fig 11.26?  Maybe, not urgent 5/31/22
% S1 = ones(5);
% e1 = imorph(im, S1, 'min');
% d1 = imorph(e1, S1, 'max');
% 
% S2 = ones(7);
% e2 = imorph(im, S2, 'min');
% d2 = imorph(e2, S2, 'max');
% 
% S3 = ones(1,14);
% e3 = imorph(im, S3, 'min');
% d3 = imorph(e3, S3, 'max');
% 
% f1
% vsep = ones(numrows(im), 1);
% hsep = ones(1,3*numcols(im)+3);
% %idisp([e1 vsep e2 vsep e3; hsep; d1 vsep d2 vsep d3]);
% 
% p1 = bg*ones(numrows(vsep)+1, 25);
% p1 = ipaste(p1, icolor(S1, [1 0 0]), [5,15]);
% p2 = bg*ones(numrows(vsep)+1, 25);
% p2 = ipaste(p2, icolor(S2, [1 0 0]), [5,15]);
% p3 = bg*ones(numrows(vsep), 25);
% p3 = ipaste(p3, icolor(S3, [1 0 0]), [5,15]);
% panel = cat(1, p1, p2, p3);
% 
% results = icolor([im vsep e1 vsep d1 vsep; hsep;  im vsep e2 vsep d2 vsep; hsep; im vsep e3 vsep d3 vsep]);
% 
% idisp( cat(2, results, panel), 'noaxes', 'nogui', 'square')
% 
% rvcprint

% Re-do Fig 11.27? NO

%% 11.6.1 Noise Removal

objects = imread('segmentation.png');
S = strel('disk', 4);
S.Neighborhood

% Fig 11.28 a,b,c,d
imshow(imcomplement(objects));
axis on
rvcprint3('fig11_28a');

closed = imclose(objects, S);
imshow(imcomplement(closed));
axis on
rvcprint3('fig11_28b');

clean = imopen(closed, S);
imshow(imcomplement(clean));
axis on
rvcprint3('fig11_28c');

opened = imopen(objects, S);
closed = imclose(opened, S);
imshow(imcomplement(closed));
axis on
rvcprint3('fig11_28d');

% end of fig generation

%% 11.6.2 Boundary Detection

eroded = imerode(clean, strel('disk', 1));
imshow(clean-eroded)

% Fig 11.29
imshow(imcomplement(clean-eroded));
axis on
rvcprint3('fig11_29');
close all

%% 11.6.3 Hit or Miss Transform

% New figure from me
interval = [-1 1 0; 1 1 1; -1 1 -1];
imshow(interval)
impixelregion
set(0, 'showhiddenhandles','on')
f = gcf;
delete(f.Children(7))
f.Position = [f.Position(1:2) 560 600]
fontsize(f, scale=3)

rvcprint3('fig11_30a');
close all

% Create an example image
img = [0 1 0 1 1 1; 1 1 1 1 1 1; 0 1 0 1 1 1];
imshow(img)
impixelregion
f = gcf;
delete(f.Children(7))
f.Position = [f.Position(1:2) 1100 600]
fontsize(f, scale=3)

rvcprint3('fig11_30b');
close all

out = bwhitmiss(img, interval);
imshow(out)
impixelregion
f = gcf;
delete(f.Children(7))
f.Position = [f.Position(1:2) 1100 600]
fontsize(f, scale=3)

rvcprint3('fig11_30c');
close all

% On to thinning.
objects = imread("segmentation.png");
S = strel("disk", 4);
closed = imclose(objects, S);
clean = imopen(closed, S);

skeleton = bwmorph(clean, 'skel', Inf);
outSkel = imoverlay(imcomplement(clean*0.5), skeleton, 'yellow');
imshow(outSkel)
axis on
rvcprint3('fig11_31a');

% Endpoints
ends = bwmorph(skeleton, 'endpoints');
outEnds = imoverlay(outSkel, ends, 'red');
imshow(outEnds)
set(gca, 'XLimMode', 'manual', 'Xlim', [200 320], 'YLimMode', 'manual', 'Ylim', [270 350]);
axis on
rvcprint3('fig11_31b');

% Tripple points
joints = bwmorph(skeleton, 'branchpoints');
outEnds = imoverlay(outSkel, joints, 'red');
imshow(outEnds)
set(gca, 'XLimMode', 'manual', 'Xlim', [200 320], 'YLimMode', 'manual', 'Ylim', [270 350]);
axis on
rvcprint3('fig11_31c');

%% 11.6.4 Distance Tranform

im = zeros(256);
im = insertShape(im, 'FilledRectangle', [64, 64, 128, 128],...
    'Color', 'w', 'Opacity', 1);
im = imrotate(im(:,:,1), 15, 'crop');
edges = edge(im, 'canny');

dx = bwdist(edges); 

% Fig 11.32a
imshow(edges, InitialMagnification=200)
axis on
a = gcf;
a.Children.FontSize=13;
rvcprint3('fig11_32a');

% Fig 11.32b
imshow(dx, [], 'InitialMagnification', 200);
cb = colorbar();
cb.Label.String = 'Euclidean distance (pixels)';
cb.Label.FontSize = 12;
corners = [-1 -1; 1 -1; 1 1; -1 1; -1 -1]' ;
corners = corners*64 + 128;
hold on
plot2(corners', 'r')
axis on

rvcprint3('fig11_32b');

clf
surf(dx,dx)
shading interp
colormap(parula)
view(-10, 48)
hold on
plot2([corners; 20 20 20 20 20]', 'r')
xlabel('u (pixels)')
ylabel('v (pixels)')
zlabel('Euclidean distance (pixels)')

rvcprint3('fig11_32c');

close all

%% 11.7 Shape Changing

%% 11.7.1 Cropping

mona = imread('monalisa.png');
smile = imcrop(mona, [265, 264, 77, 22]);

% Fig 11.33 a, b
imshow(mona);
rvcprint3('fig11_33a');

imshow(smile, 'InitialMagnification', 500);
rvcprint3('fig11_33b');


%% Image Resizing

roof = rgb2gray(imread('roof.jpg'));

smaller = roof(1:7:end, 1:7:end);

smaller = imresize(roof, 1/7);

bigger = imresize(smaller, 7);

% Fig 11.34 a, b, c, d
imshow(roof, 'InitialMagnification', 50);
axis on
rvcprint3('fig11_34a');

smaller = roof(1:7:end, 1:7:end);
imshow(smaller, 'InitialMagnification', 200);
axis on
rvcprint3('fig11_34b');

smaller = imresize(roof, 1/7);
imshow(smaller, 'InitialMagnification', 200);
axis on
rvcprint3('fig11_34c');

bigger = imresize(smaller, 7);
imshow(bigger, 'InitialMagnification', 50);
axis on
rvcprint3('fig11_34d');
% end of figure generation

%% 11.7.3 Image Pyramids

mona = imread('monalisa.png');
p0 = impyramid(rgb2gray(mona), 'reduce');
p1 = impyramid(p0, 'reduce');
p2 = impyramid(p1, 'reduce');
p3 = impyramid(p2, 'reduce');

% Fig 11.35
p = {p0,p1,p2,p3};
w = 0;
for i=1:length(p)
    w = w + numcols(p{i});
end
im = 0.3*255*ones(numrows(p{1}), w, 'uint8');
u = 1;
for i=1:length(p)
    [nr,nc] = size(p{i});
    im(1:nr,u:u+nc-1) = p{i};
    u = u + nc;
end
imshow(im);
rvcprint3('fig11_35');


%% 11.7.4 Image Warping

% Fig 11.36
mona = im2double(rgb2gray(imread('monalisa.png')));
[Ui, Vi] = meshgrid(1:size(mona,2), 1:size(mona,1));

[Up, Vp] = meshgrid(1:400, 1:400);

U = 4*(Up-100); V = 4*(Vp-200);

little_mona = interp2(Ui, Vi, mona, U, V);
little_mona(isnan(little_mona)) = Inf;

h = imshow(little_mona);
c=[colormap(h.Parent); 1 0 0];
colormap(c)
axis on

rvcprint3('fig11_36a')
close all

[Up, Vp] = meshgrid(1:size(mona,2), 1:size(mona,1));

R = rotm2d(pi/6);
uc = 256; vc = 256;
U = R(1,1)*(Up-uc) + R(2,1)*(Vp-vc) + uc;
V = R(1,2)*(Up-uc) + R(2,2)*(Vp-vc) + vc;
twisted_mona = interp2(Ui, Vi, mona, U, V);

twisted_mona(isnan(twisted_mona)) = Inf;

h=imshow(twisted_mona);
c=[colormap(h.Parent); 1 0 0];
colormap(c)

axis on

rvcprint3('fig11_36b')
close all


%% Image dewarping

distorted = imread(fullfile(toolboxdir("vision"), "visiondata",...
    "calibration", "mono", "image01.jpg"));
distorted = im2double(rgb2gray(distorted));
[Ui,Vi] = imeshgrid(distorted);
Up = Ui; Vp = Vi;

d = load("cameraIntrinsics");

k = [d.intrinsics.RadialDistortion 0];
p = d.intrinsics.TangentialDistortion;
u0 = d.intrinsics.PrincipalPoint(1) - 1;
v0 = d.intrinsics.PrincipalPoint(2) - 1;
fpix_u = d.intrinsics.FocalLength(1); 
fpix_v = d.intrinsics.FocalLength(2);

u = (Up-u0) / fpix_u;
v = (Vp-v0) / fpix_v;

r = sqrt( u.^2 + v.^2 );

delta_u = u .* (k(1)*r.^2 + k(2)*r.^4 + k(3)*r.^6) + ...
    2*p(1)*u.*v + p(2)*(r.^2 + 2*u.^2);
delta_v = v .* (k(1)*r.^2 + k(2)*r.^4 + k(3)*r.^6) + ... 
    p(1)*(r.^2 + 2*v.^2) + 2*p(2)*u.*v;

ud = u + delta_u; vd = v + delta_v;

U = ud * fpix_u + u0;
V = vd * fpix_v + v0;

undistorted = interp2(Ui, Vi, distorted, U, V);

% Fig 11.38a,b
imshow(distorted)
rvcprint3('fig11_38a');
imshow(undistorted)
rvcprint3('fig11_38b');


