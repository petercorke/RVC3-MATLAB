%[text] %[text:anchor:F4CCA683] # Robotics, Vision & Control 3e: for MATLAB
%[text] %[text:anchor:CAAB408D] # Chapter 11: Images and Image Processing
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%[text] %[text:anchor:DD428C66] # 
%[text] Copyright 2022\-2023 Peter Corke, Witold Jachimczyk, Remo Pillat
%[text] %[text:anchor:C44A23DD] ## 11\.1 Obtaining an Image
%[text] %[text:anchor:5AD1F85D] ### 11\.1\.1 Images from Files
street = imread("street.png");

whos street

street(200,300)

a = uint8(100)
b = uint8(200)

a+b
a-b

a/b

streetd = im2double(street);
class(streetd)

imtool(street)

flowers = imread("flowers8.png");
imtool(flowers)
whos flowers

pix = flowers(276,318,:)

size(pix)

squeeze(pix)' % transpose for display

imtool(flowers(:,:,1))

md = imfinfo("roof.jpg")

md.DigitalCamera
%[text] %[text:anchor:8EAC253F] ### 11\.1\.2 Images from an Attached Camera
% Not runnable section.
% The following code only works if you have a webcam attached to your
% computer. Uncomment if you want to run it.

%webcamlist % list webcams available on a local computer

%cam = webcam("name") % name is a placeholder for a local webcam

%cam.Resolution

%im = cam.snapshot;

%cam.preview
%[text] %[text:anchor:13D2568B] ### 11\.1\.3 Images from a Video File
vid = VideoReader("traffic_sequence.mpg");

vid.NumFrames

[vid.Width,vid.Height]

im = vid.readFrame();
whos im

videoPlayer = vision.VideoPlayer;
cont = vid.hasFrame;
while cont
  im = vid.readFrame;
  videoPlayer.step(im);
  cont = vid.hasFrame && videoPlayer.isOpen;
  pause(0.05);
end
%[text] %[text:anchor:54CABEB2] ### 11\.1\.4 Images from the Web
img = imread("http://uk.jokkmokk.jp/photo/nr4/latest.jpg");

size(img)

imshow(img)
%[text] %[text:anchor:5B5701F4] ### 11\.1\.5 Images from Code
im = testpattern("rampx",256,2);
im = testpattern("siny",256,2);
im = testpattern("squares",256,50,25);
im = testpattern("dots",256,256,100);

canvas = zeros(1000,1000);

canvas = insertShape(canvas,"FilledRectangle",[100 100 150 150], ...
  Opacity=1,Color=[0.5 0.5 0.5]);
canvas = insertShape(canvas,"FilledRectangle",[300 300 80 80], ...
  Opacity=1,Color=[0.9 0.9 0.9]);

canvas = insertShape(canvas,"FilledCircle",[700 300 120], ...
  Opacity=1,Color=[0.7 0.7 0.7]);

canvas = insertShape(canvas,"Line",[100 100 800 800], ...
  Opacity=1,Color=[0.8 0.8 0.8]);

imshow(canvas)
%%
%[text] %[text:anchor:61BDB3A2] ## 11\.2 Image Histograms
church = rgb2gray(imread("church.png"));
imhist(church)

[counts,x] = imhist(church);

[~,p] = findpeaks(counts,x); % ignore peak values and obtain peak indices
size(p)

[~,p] = findpeaks(counts,x,MinPeakDistance=60);
p' % transpose for display
%%
%[text] %[text:anchor:9736A4AD] ## 11\.3 Monadic Operations
imd = im2double(church);

im = im2uint8(imd);

flowers = rgb2gray(imread("flowers8.png"));

flowersRGB = repmat(flowers,[1 1 3]);

flowersRGB = zeros(size(flowersRGB),like=flowersRGB);
flowersRGB(:,:,1) = flowers;

bright = (church >= 180);
imshow(bright)

im = imadjust(church);

im = histeq(church);

counts = imhist(church);
plot(cumsum(counts))

im = imadjust(church,[],[],1/0.45);

im = lin2rgb(church);

imshow(church/64,[])
%%
%[text] %[text:anchor:38013E66] ## 11\.4 Dyadic Operations
subject = im2double(imread("greenscreen.jpg"));
imshow(subject)

imlab = rgb2lab(subject);
astar = imlab(:,:,2);

histogram(astar(:))

mask = astar > -15;
imshow(mask)

imshow(mask.*subject);

bg = im2double(imread("desertRoad.png"));

bg = imresize(bg,size(subject,[1 2]));

imshow(bg.*(1-mask))

imshow(subject.*mask + bg.*(1-mask))
%[text] %[text:anchor:EDFF06F1] ### 11\.4\.1 Application: Motion detection
vid = VideoReader("traffic_sequence.mpg");

bg = im2double(im2gray(vid.readFrame())); 

sigma = 0.02;
while vid.hasFrame()
  im = im2double(im2gray(vid.readFrame()));
  d = im-bg;
  d = max(min(d,sigma),-sigma); % apply c(x)
  bg = bg+d;
  imshow(bg);
end
%%
%[text] %[text:anchor:AE329B49] ## 11\.5 Spatial Operations
%[text] %[text:anchor:1A46459C] ### 11\.5\.1 Linear Spatial Filtering
%Y = imfilter(X,K,"conv");

%[text] %[text:anchor:348E58ED] #### 11\.5\.1\.1 Image Smoothing

K = ones(21,21) / 21^2;

mona = rgb2gray(imread("monalisa.png"));
imshow(imfilter(mona,K,"conv","replicate"));

K = fspecial("gaussian",31,5);
imshow(imfilter(mona,K,"replicate"));

imshow(imgaussfilt(mona,5))

imshow(K,[],InitialMagnification=800);

surfl(-15:15,-15:15,K);

K = fspecial("disk",8);

%[text] 
%[text] %[text:anchor:855F2550] #### 11\.5\.1\.3 Edge Detection

castle = im2double(imread("castle.png"));

p = castle(360,:);

plot(p);

plot(diff(p))

K = [0.5 0 -0.5];
imshow(imfilter(castle,K,"conv"),[]);

Dv = fspecial("sobel")

imshow(imfilter(castle,Dv,"conv"),[])

imshow(imfilter(castle,Dv',"conv"),[])
% Not runnable.
%Xv = imfilter(Dv,fspecial("gaussian",hsize,sigma), ...
%              "conv","full");

derOfGKernel = imfilter(Dv,fspecial("gaussian",5,2), ...
  "conv","full");
Xv = imfilter(castle,derOfGKernel,"conv");
Xu = imfilter(castle,derOfGKernel',"conv");

m = sqrt(Xu.^2 + Xv.^2);

th = atan2(Xv,Xu);

quiver(1:20:size(th,2), 1:20:size(th,1), ...
  Xu(1:20:end,1:20:end), Xv(1:20:end,1:20:end))

edges = edge(castle,"canny");

shape = 0;
L = fspecial("laplacian",shape)

lap = imfilter(castle,fspecial("log",[],2));

p = lap(360,570:600);
plot(570:600,p,"-o");

bw = edge(castle,"log");
%[text] %[text:anchor:3FAEB9E9] ### 11\.5\.2 Template Matching
mona = im2double(rgb2gray(imread("monalisa.png")));
A = mona(170:220,245:295);

sad = @(I1,I2)(sum(abs(I1(:)-I2(:))));
ssd = @(I1,I2)(sum((I1(:)-I2(:)).^2));
ncc = @(I1,I2)(dot(I1(:),I2(:))/ ...
  sqrt(sum(I1(:).^2)*sum((I2(:)).^2)));
B = A;
sad(A,B)
ssd(A,B)
ncc(A,B)

B = 0.9*A;
sad(A,B)
ssd(A,B)


B = A+0.1;
sad(A,B)
ssd(A,B)
ncc(A,B)

submean = @(I)(I-mean(I(:)));
zsad = @(I1,I2)(sad(submean(I1),submean(I2)));
zssd = @(I1,I2)(ssd(submean(I1),submean(I2)));
zncc = @(I1,I2)(ncc(submean(I1),submean(I2)));
zsad(A,B)
zssd(A,B)
zncc(A,B)

B = 0.9*A + 0.1;
zncc(A,B)

crowd = imread("wheres-wally.png");
imshow(crowd)

wally = imread("wally.png");
imshow(wally);

S = normxcorr2(wally,crowd);

imshow(S,[]), colorbar

peakFinder = vision.LocalMaximaFinder(MaximumNumLocalMaxima=5, ...
  NeighborhoodSize=[3 3],Threshold=min(S(:)));
uvLoc = peakFinder.step(S);
vals = S(sub2ind(size(S),uvLoc(:,2),uvLoc(:,1)))'

labels = "Wally " + string(1:5) + ": " + string(vals);
markedSim = insertObjectAnnotation(S,"circle",[uvLoc, ...
  10*ones(5,1)],labels,FontSize=21);
imshow(markedSim)
%[text] %[text:anchor:5981651E] ### 11\.5\.3 Nonlinear Operations
out = nlfilter(mona,[7 7],@(x)var(x(:)));

mx = ordfilt2(mona,1,ones(5,5));

med = ordfilt2(mona,12,ones(5,5));

spotty = imnoise(mona,"salt & pepper");
imshow(spotty)

imshow(medfilt2(spotty,[3 3]))

M = ones(3,3);
M(2,2) = 0
mxn = ordfilt2(mona,1,M);

imshow(mona > mxn)
%%
%[text] %[text:anchor:8A53ACA5] ## 11\.6 Mathematical Morphology
load eg_morph1.mat
imshow(im,InitialMagnification=800)

S = strel("square",5);

mn = imerode(im,S);

morphdemo(im,S,"min")

mx = imdilate(mn,S);
%[text] %[text:anchor:9676C371] ### 11\.6\.1 Noise Removal
objects = imread("segmentation.png");

S = strel("disk",4);
S.Neighborhood

closed = imclose(objects,S);

clean = imopen(closed,S);

opened = imopen(objects,S);
closed = imclose(opened,S);
%[text] %[text:anchor:27B57E39] ### 11\.6\.2 Boundary Detection
eroded = imerode(clean,strel("disk",1));

imshow(clean-eroded)
%[text] %[text:anchor:16339476] ### 11\.6\.3 Hit or Miss Transform
skeleton = bwmorph(clean,"skel",Inf);

ends = bwmorph(skeleton,"endpoints");

joints = bwmorph(skeleton,"branchpoints");
%[text] %[text:anchor:3CB666F7] ### 11\.6\.4 Distance Transform
im = zeros(256);
im = insertShape(im,"FilledRectangle",[64 64 128 128], ...
  Color="w",Opacity=1);
im = imrotate(im(:,:,1),15,"crop");
edges = edge(im,"canny");

dx = bwdist(edges);
%%
%[text] %[text:anchor:8649171A] ## 11\.7 Shape Changing
%[text] %[text:anchor:F52A212B] ### 11\.7\.1 Cropping
mona = imread("monalisa.png");

% The following 3 lines are interactive.
%[eyes,roi] = imcrop(mona);
%imshow(eyes)
%roi

smile = imcrop(mona,[265 264 77 22]);
%[text] %[text:anchor:564539E5] ### 11\.7\.2 Image Resizing
roof = rgb2gray(imread("roof.jpg"));
whos roof

smaller = roof(1:7:end,1:7:end);

smaller = imresize(roof,1/7);

bigger = imresize(smaller,7);
%[text] %[text:anchor:57A9E901] ### 11\.7\.3 Image Pyramids
p0 = impyramid(rgb2gray(mona),"reduce");
p1 = impyramid(p0,"reduce");
p2 = impyramid(p1,"reduce");
p3 = impyramid(p2,"reduce");
%[text] %[text:anchor:46D85206] ### 11\.7\.4 Image Warping
mona = im2double(rgb2gray(imread("monalisa.png")));
[Ui,Vi] = meshgrid(1:size(mona,2),1:size(mona,1));

[Up,Vp] = meshgrid(1:400,1:400);

U = 4*(Up-100); V = 4*(Vp-200);

little_mona = interp2(Ui,Vi,mona,U,V);

[Up,Vp] = meshgrid(1:size(mona,2),1:size(mona,1));

R = rotm2d(pi/6);
uc = 256; vc = 256;
U = R(1,1)*(Up-uc)+R(2,1)*(Vp-vc)+uc;
V = R(1,2)*(Up-uc)+R(2,2)*(Vp-vc)+vc;
twisted_mona = interp2(Ui,Vi,mona,U,V);

twisted_mona = imrotate(mona,-rad2deg(pi/6),"crop");

distorted = imread(fullfile(toolboxdir("vision"),"visiondata", ...
   "calibration","mono","image01.jpg"));
distorted = im2double(rgb2gray(distorted));
[Ui,Vi] = imeshgrid(distorted);
Up = Ui; Vp = Vi;

d = load("cameraIntrinsics");

k = [d.intrinsics.RadialDistortion 0];
p = d.intrinsics.TangentialDistortion;
u0 = d.intrinsics.PrincipalPoint(1);
v0 = d.intrinsics.PrincipalPoint(2);
fpix_u = d.intrinsics.FocalLength(1); 
fpix_v = d.intrinsics.FocalLength(2);

u = (Up-u0)/fpix_u;
v = (Vp-v0)/fpix_v;

r = sqrt(u.^2+v.^2);

delta_u = u.*(k(1)*r.^2 + k(2)*r.^4 + k(3)*r.^6) + ...
  2*p(1)*u.*v + p(2)*(r.^2 + 2*u.^2);
delta_v = v.*(k(1)*r.^2 + k(2)*r.^4 + k(3)*r.^6) + ...
  p(1)*(r.^2 + 2*v.^2) + 2*p(2)*u.*v;

ud = u+delta_u; vd = v+delta_v;

U = ud*fpix_u + u0;
V = vd*fpix_v + v0;

undistorted = interp2(Ui,Vi,distorted,U,V);
imshowpair(distorted,undistorted,"montage")
%%
%[text] Suppress syntax warnings in this file
%#ok<*NOANS>
%#ok<*MINV>
%#ok<*NASGU>
%#ok<*NBRAK2>


%[appendix]
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
