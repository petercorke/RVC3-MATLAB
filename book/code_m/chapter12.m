%[text] %[text:anchor:F4CCA683] # Robotics, Vision & Control 3e: for MATLAB
%[text] %[text:anchor:CAAB408D] # Chapter 12: Image Feature Extraction
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%[text] %[text:anchor:03F5A57B] # 
%[text] Copyright 2022\-2023 Peter Corke, Witold Jachimczyk, Remo Pillat
%[text] %[text:anchor:T_C71FAC46] ## 12\.1 Region Features
%[text] %[text:anchor:ECD56869] ### 12\.1\.1 Pixel Classification
%[text] %[text:anchor:4C43DE6E] #### 12\.1\.1\.1 Grayscale Image Classification

castle = im2double(imread("castle.png"));

imshow(castle > 0.7)
% The following 2 lines open an interactive app. Uncomment if you want to
% run it.
%imageSegmenter(castle)
%imageSegmenter(castle*0.8)

imhist(castle);

t = graythresh(castle)

castle = im2double(imread("castle2.png"));

t = graythresh(castle)

t = adaptthresh(castle,NeighborhoodSize=65);
imshow(t)

imshow(imbinarize(castle,t))

[regions,CC] = detectMSERFeatures(castle, ...
   RegionAreaRange=[100 20000]);

regions.Count

L = labelmatrix(CC);
imshow(label2rgb(L));

%[text] %[text:anchor:CB6F2559] #### 12\.1\.1\.2 Color Image Classification

imTargets = imread("yellowtargets.png");

imGarden = imread("tomato_124.jpg");

im_lab = rgb2lab(imTargets);
im_ab = single(im_lab(:,:,2:3));  % imsegkmeans requires single type input
[L,cab] = imsegkmeans(im_ab,2);

cab

colorname(cab(2,:),"ab")

imshow(label2rgb(L))

cls2 = (L==2);

imshow(cls2)

targetsBin = imopen(cls2,strel("disk",2));
imshow(targetsBin)

im_lab = rgb2lab(imGarden);
im_ab = single(im_lab(:,:,2:3));
[L,cab] = imsegkmeans(im_ab,3);
cab

colorname(cab(3,:),"ab")

cls3 = (L==3);
imshow(cls3)

rng(0)  % set random seed for repeatable results
a = rand(500,2);

[cls,center] = kmeans(a,3);

hold on
for i=1:3
  h = plot(a(cls==i,1),a(cls==i,2),".");
  % Maintain previous plot color while showing cluster center
  h.Parent.ColorOrderIndex = h.Parent.ColorOrderIndex-1;
  plot(center(i,1),center(i,2),".",MarkerSize=32)
end

tomatoesBin = imclose(cls3,strel("disk",15));
imshow(tomatoesBin)

%[text] %[text:anchor:6D3C331A] #### 12\.1\.1\.3 Semantic Segmentation

I = imread("streetScene.png");
imshow(I)

pretrainedURL = "https://ssd.mathworks.com/supportfiles" + ...
  "/vision/data/deeplabv3plusResnet18CamVid.zip";
pretrainedFolder = fullfile(tempdir,"pretrainedNetwork");
pretrainedNetworkZip = fullfile(pretrainedFolder, ...
  "deeplabv3plusResnet18CamVid.zip"); 
mkdir(pretrainedFolder);
disp("Downloading pretrained network (58 MB)...")
websave(pretrainedNetworkZip,pretrainedURL);
unzip(pretrainedNetworkZip, pretrainedFolder);

pretrainedNetwork = fullfile(pretrainedFolder, ...
  "deeplabv3plusResnet18CamVid.mat");
data = load(pretrainedNetwork);
C = semanticseg(I,data.net);

classes = ["Sky","Building","Pole","Road","Pavement", ...
  "Tree","SignSymbol","Fence","Car","Pedestrian","Bicyclist"];
labels = 1:size(classes,2);
cmap = im2single(squeeze(label2rgb(labels,"colorcube")));
B = labeloverlay(I,C,Colormap=cmap,Transparency=0.4);
imshow(B)
pixelLabelColorbar(cmap,classes);

road = (C == "Road");
%[text] %[text:anchor:28C01A3F] ### 12\.1\.2 Representation: Distinguishing Multiple Objects
%[text] %[text:anchor:C4E79B01] #### 12\.1\.2\.1 Creating Binary Blobs

im = imread("multiblobs.png");

imshow(im)

[label,m] = bwlabel(im);

m

imshow(label2rgb(label))

reg1 = (label==1);
imshow(reg1)

sum(reg1(:))

targetsLabel = bwlabel(targetsBin);
imshow(label2rgb(targetsLabel));

tomatoesLabel = bwlabel(tomatoesBin);
imshow(label2rgb(tomatoesLabel));

%[text] %[text:anchor:B9DE0E3B] #### 12\.1\.2\.2 Graph\-Based Segmentation

im = imread("58060.jpg");

im_lab = rgb2lab(im);

L = superpixels(im_lab,872,IsInputLab=true);

im_lab(:,:,1) = im_lab(:,:,1)/100;
im_lab(:,:,2) = (im_lab(:,:,2)+86.1827)/184.4170;
im_lab(:,:,3) = (im_lab(:,:,3)+107.8602)/202.3382;

exemplars = load("graphSegMarkup.mat");
BW = lazysnapping(im_lab,L,exemplars.foregroundInd, ...
  exemplars.backgroundInd);
imshow(imoverlay(im, BW))
%[text] %[text:anchor:71C01E67] ### 12\.1\.3 Description
%[text] %[text:anchor:646E62BD] #### 12\.1\.3\.1 Bounding Boxes

sharks = imread("sharks.png");

[label,m] = bwlabel(sharks);
blob = (label==4);

sum(blob(:))

[v,u] = find(blob);

size(u)

umin = min(u)
umax = max(u)
vmin = min(v)
vmax = max(v)

imshow(insertShape(im2double(blob),"rectangle", ...
    [umin,vmin,umax-umin,vmax-vmin]))

%[text] %[text:anchor:4A05ED69] #### 12\.1\.3\.2 Moments

m00 = sum(blob(:))

[v,u] = find(blob);
uc = sum(u(:))/m00
vc = sum(v(:))/m00

hold on
plot(uc,vc,"gx",uc,vc,"go");

u20 = sum(u(:).^2)-sum(u(:))^2/m00;
u02 = sum(v(:).^2)-sum(v(:))^2/m00;
u11 = sum(u(:).*v(:))-sum(u(:))*sum(v(:))/m00;
J = [u20 u11; u11 u02]

lambda = eig(J)

a = 2*sqrt(lambda(2)/m00)
b = 2*sqrt(lambda(1)/m00)

b/a

[x,lambda] = eig(J);
x

v = x(:,end);

orientation = atan(v(2)/v(1));
rad2deg(orientation)

plotellipse([a b orientation],[uc vc],"r",LineWidth=2)

%[text] %[text:anchor:6CDFF2DB] #### 12\.1\.3\.3 Blob Descriptors
f = regionprops(blob,"Area","Centroid","Orientation", ...
 "MajorAxisLength","MinorAxisLength")

f.Area
f.Orientation

fv = regionprops("table",sharks,"Area","BoundingBox", ...
                 "Orientation")

bbox = fv.BoundingBox

imshow(sharks), hold on
showShape("rectangle",bbox);

cleared_tomatoes = imclearborder(tomatoesBin);

L = bwlabel(sharks);
stats = regionprops(L,"Area","Orientation");
idx = find([stats.Area] > 10000 & [stats.Orientation] > 0);
filtered_sharks = ismember(L,idx);
imshow(filtered_sharks)

%[text] %[text:anchor:9E410A1C] #### 12\.1\.3\.4 Shape from Object Boundary

sharks = imread("sharks.png");
fv = regionprops(sharks,"Perimeter","Circularity","Centroid");
fv(1)

b = bwboundaries(sharks);
size(b{1})

b{1}(1:5,:)

imshow(sharks); hold on
for k = 1:length(b)
   boundary = b{k};
   plot(boundary(:,2),boundary(:,1),"r",LineWidth=2)
   plot(fv(k).Centroid(1),fv(k).Centroid(2),"bx")
end

[fv.Circularity]

blobs = imread("multiblobs.png");
[B,L,N,A] = bwboundaries(blobs);

imshow(blobs);
hold on;
for k = 1:N
  if nnz(A(:,k)) > 0
    boundary = B{k};
    plot(boundary(:,2),boundary(:,1),"r",LineWidth=3);
    for l = find(A(:,k))'
      boundary = B{l};
      plot(boundary(:,2),boundary(:,1),"g",LineWidth=3);
    end
  end
end

[r,th] = boundary2polar(b(1),fv(1));
plot([r th])

hold on
for i = 1:size(b,1)
  [r,t] = boundary2polar(b(i),fv(i));
  plot(r/max(r));
end

r_all = boundary2polar(b,fv);

boundmatch(r_all(:,1),r_all)

%[text] %[text:anchor:D2B17FA6] #### 12\.1\.3\.5 Object Detection using Deep Learning

pretrainedURL = "https://www.mathworks.com/supportfiles/" + ...
        "vision/data/yolov2IndoorObjectDetector.zip";
pretrainedFolder = fullfile(tempdir,"pretrainedNetwork");
pretrainedNetworkZip = fullfile(pretrainedFolder, ...
    "yolov2IndoorObjectDetector.zip"); 
mkdir(pretrainedFolder);
disp("Downloading pretrained network (98 MB)...");
websave(pretrainedNetworkZip,pretrainedURL);
unzip(pretrainedNetworkZip, pretrainedFolder);
pretrainedNetwork = fullfile(pretrainedFolder, ...
   "yolov2IndoorObjectDetector.mat");
pretrained = load(pretrainedNetwork);

I = imread("doorScene.jpg");
imshow(I);

I = imresize(I,pretrained.detector.TrainingImageSize);
[bbox,score,label] = detect(pretrained.detector,I);
annotatedI = insertObjectAnnotation(I,"rectangle",bbox, ...
   "Label: "+string(label)+"; Score:"+string(score), ...
   LineWidth=3,FontSize=14,TextBoxOpacity=0.4);
imshow(annotatedI)
%[text] %[text:anchor:E19D07C3] ### 12\.1\.4 Summary
%%
%[text] %[text:anchor:75F46076] ## 12\.2 Line Features
im = imread("5points.png");

im = zeros(256,"uint8");
im = insertShape(im,"filledrectangle",[64 64 128 128]);
im = imrotate(rgb2gray(im),20);

edges = edge(im,"canny");

[A,theta,rho] = hough(edges);

imagesc(theta,rho,A);
set(gca,YDir="normal");

p = houghpeaks(A,4);
lines = houghlines(edges,theta,rho,p)

imshow(im), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),LineWidth=2,Color="green");
    plot(xy(1,1),xy(1,2),"xy",LineWidth=2);
    plot(xy(2,1),xy(2,2),"xr",LineWidth=2);   
end

im = rgb2gray(imread("church.png"));
edges = edge(im,"sobel");
[A,theta,rho] = hough(edges);
p = houghpeaks(A,15);
lines = houghlines(edges,theta,rho,p);

imshow(im), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),LineWidth=2,Color="green");
    plot(xy(1,1),xy(1,2),"xy",LineWidth=2);
    plot(xy(2,1),xy(2,2),"xr",LineWidth=2);   
end
%[text] %[text:anchor:28810A87] ## 12\.3 Point Features
%[text] %[text:anchor:D0EE6AEB] ### 12\.3\.1 Classical Corner Detectors
b1 = imread("building2-1.png");
imshow(b1)

C = detectHarrisFeatures(b1)

imshow(b1,[0 500]), hold on
plot(C.selectUniform(200,size(b1)))

length(C)

C(1:4)

C(1:4).Metric' % transpose for display
C(1).Location

imshow(b1, [0 500]), hold on
C(1:5:800).plot()

b2 = imread("building2-2.png");

C2 = detectHarrisFeatures(b2);
imshow(b2,[0 500]),hold on
plot(C2.selectUniform(200,size(b2)));
%[text] %[text:anchor:7AED535B] ### 12\.3\.2 Scale\-Space Feature Detectors
sf1 = detectSURFFeatures(b1)

sf1(1)

imshow(b1,[0 500]), hold on
plot(sf1.selectStrongest(200))

hist(sf1.Scale,100);
%%
%[text] %[text:anchor:8341E6A3] ## 12\.4 Applications
%[text] %[text:anchor:937C58CC] ### 12\.4\.1 Character Recognition
% The following section requires the installation of the Computer Vision
% Toolbox Model for Text Detection support package. Uncomment the lines if
% you have the support package installed.

%castle = imread("castle.png");
%textBBoxes = detectTextCRAFT(castle)

%txt = ocr(castle,textBBoxes);

%string([txt.Words])

%[txt.WordConfidences]

%imshow(castle)
%showShape("rectangle",textBBoxes,Color="y",Label=[txt.Words], ...
%    LabelFontSize=18,LabelOpacity=0.8)
%[text] %[text:anchor:0F5B86C8] ### 12\.4\.2 Image Retrieval
images = imageDatastore(fullfile(rvctoolboxroot,"images","campus"));

montage(images)

rng(0) % set random seed for repeatable results
bag = bagOfFeatures(images,TreeProperties=[2 200])

img17 = images.readimage(17);
v17 = bag.encode(img17);
size(v17)

invIdx = indexImages(images,bag);

[simImgIdx,scores] = retrieveImages(img17,invIdx,NumResults=4);
simImgIdx' % transpose for display
scores'

for i=1:4
  imgIdx = double(simImgIdx(i));
  similarImages(:,:,:,i) = insertText(images.readimage(imgIdx),[1 1], ...
    "image #" + imgIdx + ";similarity " + scores(i),FontSize=24); 
end
montage(similarImages, BorderSize=6)

queryImages = imageDatastore(fullfile(rvctoolboxroot,"images", ...
   "campus","holdout"));

imgQuery = queryImages.readimage(1);
closestIdx = retrieveImages(imgQuery,invIdx,NumResults=1)
montage(cat(4,imgQuery,images.readimage(double(closestIdx))), ...
        BorderSize=6);
%%
%[text] %[text:anchor:H_41E2F4AF] Suppress syntax warnings in this file
%#ok<*NOANS>
%#ok<*MINV>
%#ok<*NASGU>
%#ok<*NBRAK2>
%#ok<*MRPBW>
%#ok<*HIST>
%#ok<*SAGROW>

%[appendix]
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
