

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


