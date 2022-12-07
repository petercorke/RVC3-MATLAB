%% Chapter 12

%% 12.1.1 Classification

% Fig 12.1
castle = im2double(imread("castle.png"));
imshow(castle)
rvcprint3('fig12_1a')
imshow(castle > 0.7)
rvcprint3('fig12_1b')

% Fig 12.2
imshow(castle)
rvcprint3('fig12_2a')

imhist(castle)
t = graythresh(castle);
xline(t, '--r', 'LineWidth', 2);
rvcprint3('fig12_2b')

imshow(imbinarize(castle, 0.7))
rvcprint3('fig12_2c')

imshow(imbinarize(castle, t))
rvcprint3('fig12_2d')

% Fig 12.3
castle = im2double(imread("castle2.png"));
imshow(castle)
rvcprint3('fig12_3a')

imhist(castle)
t = graythresh(castle);
xline(t, '--r', 'LineWidth', 2);
xline(0.75, '--b', 'LineWidth', 2);
rvcprint3('fig12_3b')

imshow(imbinarize(castle, t))
rvcprint3('fig12_3c')

imshow(imbinarize(castle, 0.75))
rvcprint3('fig12_3d')

% Fig 12.4 Adaptive thresholding
t = adaptthresh(castle, NeighborhoodSize=65);
imshow(t)
rvcprint3('fig12_4a')
imshow(imbinarize(castle, t))
rvcprint3('fig12_4b')

% Fig 12.5 MSER
[regions, CC] = detectMSERFeatures(castle, "RegionAreaRange", [100, 20000]);
regions.Count

L = labelmatrix(CC);
imshow(label2rgb(L));
axis on
rvcprint3('fig12_5')

%% 12.1.1.2 Color Classification

% Fig 12.6
imTargets = imread("yellowtargets.png");
imshow(imTargets, "Border","tight")
rvcprint3('fig12_6a')

im_lab = rgb2lab(imTargets);
im_ab = single(im_lab(:,:,2:3));
[L, cab] = imsegkmeans(im_ab, 2);
imshow(label2rgb(L), "Border","tight")
rvcprint3('fig12_6b')

cls2 = (L == 2);
imshow(cls2, "Border","tight")
rvcprint3('fig12_6c')

targetsBin = imopen(cls2, strel("disk", 2));
imshow(targetsBin, "Border","tight")
rvcprint3('fig12_6d')

% Fig 12.7
imGarden = imread("tomato_124.jpg");
imshow(imGarden, "Border","tight")
rvcprint3('fig12_7a')

im_lab = rgb2lab(imGarden);
im_ab = single(im_lab(:,:,2:3));
[L, cab] = imsegkmeans(im_ab, 3);
imshow(label2rgb(L), "Border","tight")
rvcprint3('fig12_7b')

cls3 = (L == 3);
imshow(cls3, "Border","tight")
rvcprint3('fig12_7c')

tomatoesBin = imclose(cls3, strel("disk", 15));
imshow(tomatoesBin, "Border","tight")
rvcprint3('fig12_7d')

%% k-means explanation
% =======================
rng(0);
a = rand(500,2);
[cls,center] = kmeans(a,3);
hold on
for i=1:3
    h = plot(a(cls==i,1), a(cls==i,2), "." , MarkerSize=8);
    % Maintain previous plot color
    h.Parent.ColorOrderIndex = h.Parent.ColorOrderIndex - 1;
    plot(center(i,1), center(i,2), ".", MarkerSize=32)    
end

axis equal
grid on
f = gcf;
f.Color="none";
f.Children.Color = "none";
f.Children.GridColor = [0.65 0.65 0.65];
f.Children.GridAlpha = 1;
f.Children.Box = "on";
f.Children.XLim = [0 1];
f.Children.YLim = [0 1];
xticks(0:0.2:1)
yticks(0.2:0.2:1)
f.InvertHardcopy = "off"; % Keep transparency!

rvcprint3('fig12_inline02')
close all;

%% 12.1.1.3 Semantic Segmentation

%% Fig a
I = imread("streetScene.png");
imshow(I)
rvcprint3('fig12_semantic_a')

%% Fig b
% Pretrained network
pretrainedURL = "https://ssd.mathworks.com/supportfiles/vision/data/deeplabv3plusResnet18CamVid.zip";
pretrainedFolder = fullfile(tempdir,"pretrainedNetwork");
pretrainedNetworkZip = fullfile(pretrainedFolder,"deeplabv3plusResnet18CamVid.zip"); 
if ~exist(pretrainedNetworkZip, "file")
    mkdir(pretrainedFolder);
    disp("Downloading pretrained network (58 MB)...");
    websave(pretrainedNetworkZip,pretrainedURL);
end
unzip(pretrainedNetworkZip, pretrainedFolder)

pretrainedNetwork = fullfile(pretrainedFolder,"deeplabv3plusResnet18CamVid.mat");
data = load(pretrainedNetwork);
net = data.net;

C = semanticseg(I, net);

% 11 classes
classes = ["Sky", "Building", "Pole", "Road", "Pavement", ...
    "Tree", "SignSymbol", "Fence", "Car", "Pedestrian", "Bicyclist"];
labels = 1:size(classes,2);
cmap = im2single(squeeze(label2rgb(labels, "colorcube")));

B = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.4);
imshow(B)
pixelLabelColorbar(cmap, classes);
rvcprint3('fig12_semantic_b')


%% 12.1.2 Representation

% Fig 12.8
im = imread("multiblobs.png");
imshow(im, "Border","tight")
rvcprint3('fig12_8a')

[label, m] = bwlabel(im);
imshow(label2rgb(label, 'jet', [0.8 0.8 0.8]), "Border","tight")
rvcprint3('fig12_8b')

imshow(label==1, "Border","tight")
rvcprint3('fig12_8c')

% Fig 12.9
targetsLabel = bwlabel(targetsBin);
imshow(label2rgb(targetsLabel, 'jet', [0.8 0.8 0.8]), "Border", "tight")
rvcprint3('fig12_9a')

tomatoesLabel = bwlabel(tomatoesBin);
imshow(label2rgb(tomatoesLabel, 'jet', [0.8 0.8 0.8]), "Border", "tight")
rvcprint3('fig12_9b')

%% 12.1.2.1 Graph-Based Segmentation

im = imread('58060.jpg');
imshow(im, "Border", "tight")
rvcprint3('fig12_10a')

im_lab = rgb2lab(im);

% Graph cut
L = superpixels(im_lab,872,'IsInputLab',true);

% Convert L*a*b* range to [0 1]
im_lab(:,:,1) = im_lab(:,:,1) / 100;  % L range is [0 100].
im_lab(:,:,2) = (im_lab(:,:,2) + 86.1827) / 184.4170;  % a* range is [-86.1827,98.2343].
im_lab(:,:,3) = (im_lab(:,:,3) + 107.8602) / 202.3382;  % b* range is [-107.8602,94.4780].

load graphSegMarkup.mat
BW = lazysnapping(im_lab,L,foregroundInd,backgroundInd);

imshow(imoverlay(im, BW), "Border", "tight")
rvcprint3('fig12_10b')

%% 12.1.3.1 Bounding Boxes
sharks = imread("sharks.png");
label = bwlabel(sharks);
blob = (label == 4);
imshow(sharks)
rvcprint3('fig12_11a')

[v,u] = find(blob);

umin = min(u)
umax = max(u)
vmin = min(v)
vmax = max(v)

imshow(insertShape(im2double(blob), "rectangle", [umin,vmin,umax-umin,vmax-vmin],...
    'LineWidth', 3), "Border", "tight")
rvcprint3('fig12_11b')

%% 12.1.3.2 Moments

% zeroth moment; area
m00 = sum(blob(:));

% center of mass
[v, u] = find(blob);
uc = sum(u(:))/m00;
vc = sum(v(:))/m00;

hold on; plot(uc, vc, 'bx', uc, vc, 'bo');

u20 = sum(u(:).^2) - sum(u(:))^2 / m00;
u02 = sum(v(:).^2) - sum(v(:))^2 / m00;
u11 = sum(u(:).*v(:)) - sum(u(:))*sum(v(:))/m00;

J = [u20 u11; u11 u02];

lambda = eig(J);

a = 2 * sqrt(lambda(2) / m00);
b = 2 * sqrt(lambda(1) / m00);

[x,lambda] = eig(J);
v = x(:,end);

orientation = atan(v(2)/v(1));

plotellipse([a b orientation], [uc vc], "r", LineWidth=2)

rvcprint3('fig12_12a')

xaxis(400, 600); yaxis(100, 300);

rvcprint3('fig12_12b')

%% 12.1.3.6 Shape from Perimeter

% Fig 12.14
sharks = imread("sharks.png");
fv = regionprops(sharks, "Perimeter", "Circularity", "Centroid");
b = bwboundaries(sharks);

imshow(sharks, 'Border','tight'); hold on
for k = 1:length(b)
    boundary = b{k};
    plot(boundary(:,2), boundary(:,1), "r", "LineWidth", 2)
    plot(fv(k).Centroid(1), fv(k).Centroid(2), "bx")
end
rvcprint3('fig12_14')

% Fig 12_adjacency
blobs = imread("multiblobs.png");
[B, L, N, A] = bwboundaries(blobs);

imshow(blobs, 'Border','tight');
hold on;
for k = 1:N
    % Boundary k is the parent of a hole if the k-th column
    % of the adjacency matrix A contains a non-zero element
    if nnz(A(:,k)) > 0
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'r', LineWidth=3);
        % Loop through the children of boundary k
        for l = find(A(:,k))'
            boundary = B{l};
            plot(boundary(:,2), boundary(:,1), 'g', LineWidth=3);
        end
    end
end

rvcprint3('fig12_adjacency')

% Fig 12.15
close all
sharks = imread("sharks.png");
fv = regionprops(sharks, "Perimeter", "Circularity", "Centroid");
b = bwboundaries(sharks);

idx = 1;
[r,th] = boundary2polar(b(idx), fv(idx));
plot([r th])
h = plotyy(1:400, r, 1:400, th);
ylabel(h(1), 'Radius (pixels)');
ylabel(h(2), 'Angle (radians)');
xlabel('Perimeter index')

rvcprint3('fig12_15a')

clf
hold on
for i=1:4
    [r,t] = boundary2polar(b(i), fv(i));
    if i == 3
        plot(r/sum(r), '--')
    else
        plot(r/sum(r));
    end
end
ylabel('Normalized radius');
xlabel('Perimeter index')

rvcprint3('fig12_15b')

%% Object Detection Using Deep Learning

% Derived from here: https://www.mathworks.com/help/vision/ug/multiclass-object-detection-using-yolo-v2-deep-learning.html

% /mathworks/devel/jobarchive/Bmain/.zfs/snapshot/Bmain.1915515.pass.ja1/
% current/build/matlab/examples/deeplearning_shared/data/indoorTest.jpg
% THIS DOES NOT EXIST IN INSTALLED VER OF ML? installed from Bvision!  xxx

I = imread("doorScene.jpg");
imshow(I);
rvcprint3('fig12_yolo_a')

pretrainedURL = "https://www.mathworks.com/supportfiles/" + ...
        "vision/data/yolov2IndoorObjectDetector.zip";
pretrainedFolder = fullfile(tempdir,"pretrainedNetwork");
pretrainedNetworkZip = fullfile(pretrainedFolder, ...
    "yolov2IndoorObjectDetector.zip"); 
if ~exist(pretrainedNetworkZip,"file")
    mkdir(pretrainedFolder);
    disp("Downloading pretrained network (98 MB)...");
    websave(pretrainedNetworkZip,pretrainedURL);
end
unzip(pretrainedNetworkZip, pretrainedFolder)

pretrainedNetwork = fullfile(pretrainedFolder,...
   "yolov2IndoorObjectDetector.mat");
pretrained = load(pretrainedNetwork);
I = imresize(I, pretrained.detector.TrainingImageSize);

[bbox, score, label] = detect(pretrained.detector, I);

% annotatedI = insertObjectAnnotation(I, "rectangle", bbox, label, ...
%     LineWidth=3, FontSize=14, TextBoxOpacity=0.4);
annotatedI = insertObjectAnnotation(I, "rectangle", bbox, ...
    "Label: " + string(label) + "; Score:" + string(score),...
    LineWidth=3, FontSize=14, TextBoxOpacity=0.4);
imshow(annotatedI)

rvcprint3('fig12_yolo_b')

%% 12.2 Line Features

% Fig 12.17
im = imread('5points.png');
imshow(im, "Border","tight", "InitialMagnification", 800);
rvcprint3('fig12_17a')

close all
figure;
theta = -90:0.5:89.5;
res = 0.5;
[h, t, r] = hough(im, "RhoResolution", res, "Theta", theta);
hi = imagesc(t, r, h);
set(hi, 'CDataMapping', 'scaled');
set(gca, 'YDir', 'normal');
grid on
ax = gca;
ax.GridColor = [0.8, 0.8, 0.8];
colormap(parula)
c = colorbar;
c.Label.String = 'Votes';
c.Label.FontSize = 15;
xlabel('\theta (degrees)', FontSize=15);
ylabel('\rho (pixels)', FontSize=15);
% Forces a redraw otherwise the xlabel is lost! Bug.
% hi.Parent.Position = hi.Parent.Position*1.1;
% fixed in 22b
rvcprint3('fig12_17b')

% Fig 12.19
im = zeros(256, "uint8");
im = insertShape(im, "filledrectangle", [64 64 128 128]);
im = imrotate(rgb2gray(im), 20);

edges = edge(im, "canny");
imshow(edges, 'Border','tight');
rvcprint3('fig12_19a')

close all
[A,theta,rho] = hough(edges);
imagesc(theta, rho, A);
set(gca, 'YDir', 'normal');
axis on, colormap(parula), 
ax = gca;
ax.GridColor = [0.8, 0.8, 0.8];
xlabel('\theta (degrees)', FontSize=15);
ylabel('\rho (pixels)', FontSize=15);
colormap(parula)
c = colorbar;
c.Label.String = 'Votes';
c.Label.FontSize = 15;
rvcprint3('opengl', 'fig12_19b')

axis([-24 -17 144 180]);
rvcprint3('opengl', 'fig12_19c')

close all
p = houghpeaks(A, 4);
lines = houghlines(edges,theta,rho,p);
imshow(im,"Border","tight"), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),LineWidth=2,Color="green");
    
    % plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'xy',LineWidth=2);
    plot(xy(2,1),xy(2,2),'xr',LineWidth=2);   
end
rvcprint3('fig12_19d')

% Fig 12.20
im = rgb2gray(imread("church.png"));
edges = edge(im, "sobel");
[A,theta,rho] = hough(edges);
p = houghpeaks(A, 15);
% p = houghpeaks(h, 30, "threshold", 0.4*max(h(:)));
lines = houghlines(edges,theta,rho,p);

imshow(im), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),LineWidth=2,Color="green");
    
    % plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'xy',LineWidth=2);
    plot(xy(2,1),xy(2,2),'xr',LineWidth=2);   
end
rvcprint3('fig12_20')

%% 12.3.1 Classical Corner Detectors


% Fig 12.21
b1 = imread("building2-1.png");
C = detectHarrisFeatures(b1);
imshow(b1, [0 500]), hold on
plot(C.selectUniform(200, size(b1)));
axis on
rvcprint3('fig12_21a')

xaxis(400, 900); yaxis(50, 350);
axis on
rvcprint3('fig12_21b')

b2 = imread("building2-2.png");
C2 = detectHarrisFeatures(b2);
imshow(b2, [0 500]), hold on
plot(C2.selectUniform(200, size(b2)));
axis on
rvcprint3('fig12_21c')

xaxis(200, 700); yaxis(50, 350);
rvcprint3('fig12_21d')

% Fig 12.23
subC = C.selectStrongest(200);
s = subC.Metric;
clf
histogram(s(:), 'Normalization', 'cdf', 'EdgeColor', 'none', 'NumBins',30)
yaxis(0.5, 1)
xline(max(s)*2/3, '--')
xlabel('Corner strength');
ylabel('Cumulative number of features');
rvcprint3('fig12_23')

%% 12.3.2 Scale-Space Feature Detectors

% Fig 12.28
sf1 = detectSURFFeatures(b1);
imshow(b1, [0 500], "Border", "tight"), hold on
plot(sf1.selectStrongest(200))
rvcprint3('fig12_28')

% Fig 12.29 in log scale
histogram(sf1.Scale, 'EdgeColor', 'none')
set(gca, 'yscale', 'log')
grid on
xlabel('Scale'); 
ylabel('Number of occurrences'); 
rvcprint3('fig12_29')


%% 12.4 Applications

%% 12.4.1 Character Recognition

% Fig 12.16
castle = imread("castle.png");
textBBoxes = detectTextCRAFT(castle)
txt = ocr(castle, textBBoxes);

imshow(castle, "Border", "tight");
hold on
showShape("rectangle", textBBoxes, Color="y", Label=[txt.Words], ...
    LabelFontSize=18, LabelOpacity=0.8)

rvcprint3('fig12_16')

%% 12.4.2 Image Retrieval

close all
images = imageDatastore(fullfile(rvctoolboxroot, "images","campus"));
montage(images, BorderSize=6)
hold on
x=18;
for i=1:4
    y = 50;    
    for j=1:5
        imgNum = (j-1)*4+i;
        text(x, y, string(imgNum), Color="b", FontSize=18, BackgroundColor="w")
        y = y+443;
    end
    x = x+660;
end
rvcprint3("fig12_bow_1")


rng(0)
bag = bagOfFeatures(images,TreeProperties=[2 200]);

img17 = images.readimage(17);
v17 = bag.encode(img17);

invIdx = indexImages(images,bag);

[simImageIdx, scores] = retrieveImages(img17,invIdx,NumResults=4);
simImageIdx'
scores'

for i=1:4
    imgIdx = double(simImageIdx(i));
    similarImages(:,:,:,i) = insertText(images.readimage(imgIdx), [1 1], ...
        "image #" + imgIdx + ";similarity " + scores(i), ...
        FontSize=24);
end
montage(similarImages, BorderSize=6)
rvcprint3("fig12_bow_2")

% Try the new 5 images
queryImages = imageDatastore(fullfile(rvctoolboxroot, "images", "campus", "holdout"));

imgQuery = queryImages.readimage(1);
closestIdx = retrieveImages(imgQuery, invIdx, NumResults=1)
montage(cat(4,imgQuery, images.readimage(double(closestIdx))), BorderSize=6);
rvcprint3("fig12_bow_3")




