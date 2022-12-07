%% Chapter 14

%% Section 14.1 Feature Correspondence

% Fig 14.1
im1 = imread("eiffel2-1.jpg");
imshow(im1, Border="tight");
rvcprint3('fig14_1a')

im2 = imread("eiffel2-2.jpg");
imshow(imresize(im2,[size(im1,1),NaN]), Border="tight");
rvcprint3('fig14_1b')

% Fig 14.2
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);

hf = detectHarrisFeatures(im1);
imshow(im1, "Border", "tight"); hold on
plot(hf.selectStrongest(200))
rvcprint3('fig14_2a')

sf = detectSURFFeatures(im1);
imshow(im1, "Border", "tight"); hold on
plot(sf.selectStrongest(200))
rvcprint3('fig14_2b')

% Fig 14.3
sf1  = detectSURFFeatures(im1);
[sfd1, vsf1] = extractFeatures(im1, sf1);

sf2 = detectSURFFeatures(im2);
[sfd2, vsf2] = extractFeatures(im2, sf2);

[idx, s] = matchFeatures(sfd1, sfd2);

matchedPts1 = vsf1(idx(:,1));
matchedPts2 = vsf2(idx(:,2));
showMatchedFeatures(im1, im2, vsf1(idx(:,1)), vsf2(idx(:,2)));
rvcprint3('fig14_3')

%% Section 14.2 Geometry of Multiple Views

% Fig 14.6
% Simulation of two cameras and a target point.
% T1 = SE3(-0.1, 0, 0) * SE3.Ry(0.4);
T1 = se3(eul2rotm([0, 0.4, 0]), [-0.1, 0, 0]);
cam1 = CentralCamera('name', 'camera 1', 'default', ...
    'focal', 0.002, 'pose', T1);

% T2 = SE3(0.1, 0,0)*SE3.Ry(-0.4);
T2 = se3(eul2rotm([0, -0.4, 0]), [0.1, 0, 0]);
cam2 = CentralCamera('name', 'camera 2', 'default', ...
    'focal', 0.002, 'pose', T2);

axis([-0.4 0.6 -0.5 0.5 -0.2 1])
cam1.plot_camera('color', 'b', 'label')
cam2.plot_camera('color', 'r', 'label')

P=[0.5 0.1 0.8];
plotsphere(P, 0.03, 'b');
grid on, view([-34 26])

rvcprint3('fig14_6')

% Fig 14.7

% Epipolar geometry simulation
set(0,"ShowHiddenHandles", true)

p1 = cam1.plot(P)
p2 = cam2.plot(P)
cam1.hold
e1 = cam1.plot( cam2.center, 'Marker', 'd', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
cam2.hold
e2 = cam2.plot( cam1.center, 'Marker', 'd', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')


%% 14.2.1 The Fundamental Matrix

F = cam1.F( cam2 )
cam2.plot_epiline(F, p1, 'r')
cam2.figure()
legend("Perspective projection of point P", "Projection of the other camera's center", "Epipolar line")
rvcprint3('fig14_7a')

cam1.plot_epiline(F', p2, 'r');
cam1.figure()
legend("Perspective projection of point P", "Projection of the other camera's center", "Epipolar line")
rvcprint3('fig14_7b')

%% Section 14.2.3 Estimating the Fundamental Matrix from Real Image Data

% Fig 14.8
tform = rigidtform3d([0, 0, 0], [-1, -1, 2]);
rng(0)
P = tform.transformPointsForward(2*rand(20, 3));
p1 = cam1.project(P);
p2 = cam2.project(P);
F = estimateFundamentalMatrix(p1, p2, Method="Norm8Point");

cam2.plot(P);
cam2.hold
cam2.plot_epiline(F, p1, 'r')
cam2.plot(cam1.center, 'Marker', 'd', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')

set(0, "ShowHiddenHandles", "on");

rvcprint3('fig14_8')
close all

%% RANSAC fitting note (excurse)
%% Fig 14.2 inline
% RANSAC fitting note

% Load and plot a set of noisy 2-D points.
load 'pointsForLineFitting.mat';
plot(points(:,1), points(:,2), '.r', 'MarkerSize', 22);
hold on

% Fit a line using linear least squares.
modelLeastSquares = polyfit(points(:,1), points(:,2), 1);
x = [min(points(:,1)), max(points(:,1))];
y = modelLeastSquares(1)*x + modelLeastSquares(2);
plot(x, y, 'b--', LineWidth=1.5);

% Fit a line to the points using M-estimator SAmple Consensus algorithm.
sampleSize = 2; maxDistance = 2;
fitLineFcn  = @(points) polyfit(points(:,1), points(:,2), 1);
evaluateFitFcn = ...
    @(model, points) sum((points(:, 2) - polyval(model, points(:,1))).^2, 2);

rng(0)
[ab, inliers] = ransac(points, fitLineFcn, evaluateFitFcn, sampleSize, maxDistance);

% Display the line.
y = ab(1)*x + ab(2);
plot(x, y, "b-", LineWidth=1.5);
legend('data', 'least squares', 'RANSAC');
f = gcf; 
f.Color="none"; 
ax = findobj(Type="Axes");
ax.Color = "none";
ax.GridColor = [0.65 0.65 0.65];
ax.GridAlpha = 1; % prevent grid from disappearing 
ax.Box = "on"; % draw lines around the plot
f.InvertHardcopy = "off"; % Keep transparency! 
grid on

rvcprint3('fig_inline14_2')

%% Fig 14.9
% Back to real images of the Eiffel tower

rng(0)
[F, in] = estimateFundamentalMatrix(matchedPts1, matchedPts2);

% Plot inliers
showMatchedFeatures(im1, im2, matchedPts1(in), matchedPts2(in));
rvcprint3('fig14_9a')

% And outliers
showMatchedFeatures(im1, im2, matchedPts1(~in), matchedPts2(~in));
rvcprint3('fig14_9b')

%% Fig 14.10
epiLines = epipolarLine(F', matchedPts2.Location(in, :));
pts = lineToBorderPoints(epiLines, size(im1));
imshow(im1, "Border", "tight"), hold on
line(pts(:, [1,3])', pts(:, [2,4])');
epole = h2e(null(F)');
plot(epole(1), epole(2), 'bo');
rvcprint3('fig14_10')

%% Section 14.2.4 Planar Homography

% set up teh cameras from 14.2
T1 = se3(eul2rotm([0, 0.4, 0]), [-0.1, 0, 0]);
cam1 = CentralCamera("default", name="camera 1",  ...
    focal=0.002, pose=T1);

T2 = se3(eul2rotm([0, -0.4, 0]), [0.1, 0, 0]);
cam2 = CentralCamera("default", name="camera 2", ...
    focal=0.002, pose=T2);

%% Fig 14.11
set(0,"ShowHiddenHandles", "on")
Tgrid = se3(eul2rotm([0.1, 0.2, 0], "XYZ"), [0, 0, 1]);
P = mkgrid(3, 1.0, 'pose', Tgrid);
p1 = cam1.plot(P, 'o');
rvcprint3('fig14_11a')
p2 = cam2.plot(P, 'o');
H = estgeotform2d(p1,p2, "projective");
p2b = H.transformPointsForward(p1');
cam2.hold()
cam2.plot(p2b, '+')
rvcprint3('fig14_11b')

%% Fig 14_12
axis([-1 1 -1 1 -0.2 1.8])
plotsphere(P, 0.05, 'b')
plotsphere(Q, 0.05, 'r')
cam1.plot_camera('color', 'b', 'label')
cam2.plot_camera('color', 'r', 'label')
grid on, view([-25 15])
rvcprint3('fig14_12')

%% Fig 14_13

set(0,"ShowHiddenHandles", "on")
Tgrid = se3(eul2rotm([0.1, 0.2, 0], "XYZ"), [0, 0, 1]);
P = mkgrid(3, 1.0, 'pose', Tgrid);
p1 = cam1.plot(P, 'o');
p2 = cam2.plot(P, 'o');
H = estgeotform2d(p1, p2, "projective");
p2b = H.transformPointsForward(p1);
cam2.hold()
cam2.plot(p2b, '+')
p1b = H.transformPointsInverse(p2);
Q = [-0.2302   0.3287   0.4000
     -0.0545   0.4523   0.5000
      0.2537   0.6024   0.6000];
p1 = cam1.plot([P; Q], 'o');
rvcprint3('fig14_13a')


p2 = cam2.plot([P; Q], 'o');
p2h = H.transformPointsForward(p1);
cam2.plot(p2h, '+');
rvcprint3('fig14_13b')

%% Example with real images
%% Fig 14_15
im1 = rgb2gray(imread("walls-l.jpg"));
im2 = rgb2gray(imread("walls-r.jpg"));
pts1 = detectSURFFeatures(im1);
pts2 = detectSURFFeatures(im2);
[sf1, vpts1] = extractFeatures(im1, pts1);
[sf2, vpts2] = extractFeatures(im2, pts2);
idxPairs = matchFeatures(sf1, sf2, Unique=true);
matchedPts1 = vpts1(idxPairs(:,1));
matchedPts2 = vpts2(idxPairs(:,2));

rng(0)
[H,inliersWall] = estgeotform2d(matchedPts1,matchedPts2,...
    "projective", "MaxDistance", 4);
wallPts = matchedPts1(inliersWall);
imshow("walls-l.jpg", "Border", "tight"), hold on
set(groot,'defaultLineLineWidth',2.0)
wallPts.plot()
set(groot,'defaultLineLineWidth',1.0)
rvcprint3('fig14_15a')


figure; imshow("walls-r.jpg", "Border", "tight")
rvcprint3('fig14_15b')


%% Sparse Stereo 14.3

%% 3D Triangulation 14.3.1

%% Fig 14.16
rng(0)
[F, in] = estimateFundamentalMatrix(matchedPts1, matchedPts2);

epiLines = epipolarLine(F', matchedPts2(in));
pts = lineToBorderPoints(epiLines, size(im1));
imshow(im1), hold on
% Show 40 lines
line(pts(1:40, [1,3])', pts(1:40, [2,4])', color="y", LineWidth=2);
rvcprint3('fig14_16')


%% Fig 14.18
md = imfinfo("walls-l.jpg");
f = md.DigitalCamera.FocalLength
md.Model

flenInPix = (f/1000)/1.5e-6;
imSize    = size(im1);
principalPoint = imSize/2 + 0.5;
camIntrinsics = cameraIntrinsics(flenInPix, principalPoint, imSize)

rng(0)
[E, in] = estimateEssentialMatrix(matchedPts1, matchedPts2, camIntrinsics, ...
     MaxDistance=0.18, Confidence=95);

inlierPts1 = matchedPts1(in);
inlierPts2 = matchedPts2(in);
pose = estrelpose(E, camIntrinsics, inlierPts1, inlierPts2);
pose.R
pose.Translation

t = pose.Translation*0.3;

tform1     = rigidtform3d;
camMatrix1 = cameraProjection(camIntrinsics, tform1);
cameraPose = rigidtform3d(pose.R, t);
tform2     = pose2extr(cameraPose);
camMatrix2 = cameraProjection(camIntrinsics, tform2);

P = triangulate(inlierPts1, inlierPts2, camMatrix1, camMatrix2);

z = P(1:100, 3);

circles = [inlierPts1.Location(1:100,:) repmat(15, [100 1])];
imAnnotated = insertObjectAnnotation(im1, "circle", ...
    circles, z, FontSize=50, LineWidth=4);
imshow(imAnnotated, "Border", "tight")

rvcprint3('fig14_18')

%% next fig 14.18
close all
pc = pointCloud(P);
ax = pcshow(pcdenoise(pc), 'VerticalAxis', 'Y', 'VerticalAxisDir', 'Down', ...
    'MarkerSize', 20, Projection="perspective", BackgroundColor="white",...
    AxesVisibility="on");

set(ax,'CameraPosition', [-3.95933324408295 -4.67876798320731 -17.671954512003], ...
    'CameraUpVector', [0.0460778835543451 -0.980277529942095 0.192179064774957]);

rvcprint3('fig14_wallPointCloud')

%% 14.3.2 Bundle Adjustment (advanced)

% no generated figs

%% 14.4 Dense Stereo Matching

L = imread("rocks2-l.png");
R = imread("rocks2-r.png");
imshowpair(padarray(L, [0 10], 255, "post"), ...
    padarray(R, [0 10], 255, "post"), "montage")

L = rgb2gray(L);
R = rgb2gray(R);


rvcprint3('fig14_rocks')

% Fig 14.20 is a screen capture using gimp
% imtool(imfuse(L,R))

% Fig 14.22
L = rgb2gray(imread("rocks2-l.png"));
R = rgb2gray(imread("rocks2-r.png"));
D = disparityBM(L, R, "DisparityRange", [80, 208], 'BlockSize', 13);

D(D==79) = Inf;
h=imshow(D, [80, 208]);
c=colormap(h.Parent);
c=[c; 1 0 0];
colormap(c)
h = colorbar;
h.Label.String = 'Disparity (pixels)';
h.Label.FontSize = 20;

rvcprint3('fig14_22')

%% 14.4.1 Stereo Failure Modes

% no figs to generate

%% 14.4.2 Refinement and Reconstruction

% no figs

%% 14.4.2.1 3D Reconstruction
% Fig 14.34
L = rgb2gray(imread("rocks2-l.png"));
R = rgb2gray(imread("rocks2-r.png"));
D = disparityBM(L, R, "DisparityRange", [80, 208], 'BlockSize', 13);

D(D==79) = NaN;
D = D + 274;

b = 0.160; % m
f = 3740; % pixels
[U,V] = meshgrid(1:size(L,2), 1:size(L,1));
u0 = size(L,2)/2; v0 = size(L,1)/2;

X = b*(U-u0) ./ D; Y = b*(V-v0) ./ D; Z = f * b ./ D;
clf
Z = medfilt2(Z, [5 5]);
surf(Z)
shading interp;
view(-74, 44)
set(gca,'ZDir', 'reverse'); set(gca,'XDir', 'reverse')
colormap(parula)
h = colorbar;
h.Label.String = 'Distance (m)';
h.Label.FontSize = 10;
xlabel(sprintf('%s', 'X'))
ylabel(sprintf('%s', 'Y'))
zlabel(sprintf('%s', 'Z'))

rvcprint3('fig14_34')

%% 14.4.2.2 3D Texture Mapped Display

% Fig 14.35
Lcolor = imread("rocks2-l.png");
surface(X, Y, Z, Lcolor, "FaceColor","texturemap", ...
 "EdgeColor","none", "CDataMapping","direct")
set(gca, "ZDir","reverse"); set(gca, "XDir","reverse")
view(-74, 44)
xlabel(sprintf('%s', 'X'))
ylabel(sprintf('%s', 'Y'))
zlabel(sprintf('%s', 'Z'))
grid on

rvcprint3('fig14_35')

%% 14.4.3 Image Rectification

imL = imresize(rgb2gray(imread("walls-l.jpg")), 0.25);
imR = imresize(rgb2gray(imread("walls-r.jpg")), 0.25);

ptsL = detectSURFFeatures(imL);
ptsR = detectSURFFeatures(imR);

[sfL, vptsL] = extractFeatures(imL, ptsL);
[sfR, vptsR] = extractFeatures(imR, ptsR);

idxPairs = matchFeatures(sfL, sfR);

matchedPtsL = vptsL(idxPairs(:,1));
matchedPtsR = vptsR(idxPairs(:,2));

rng(0)
[F, inlierIdx] = estimateFundamentalMatrix(matchedPtsL, matchedPtsR,...
   'Method', 'MSAC', 'NumTrials', 6000, 'DistanceThreshold', 0.04, 'Confidence', 95);

inlierPtsL = matchedPtsL(inlierIdx);
inlierPtsR = matchedPtsR(inlierIdx);
[tformL, tformR] = estimateStereoRectification(F, inlierPtsL, inlierPtsR, size(imL));
[rectL, rectR] = rectifyStereoImages(imL, imR, tformL, tformR);

% imshowpair(rectL, rectR, "montage");
% add a white gap
imshowpair(padarray(rectL, [0 10], 255, "post"), ...
    padarray(rectR, [0 10], 255, "post"), "montage")

rvcprint3('fig14_37')

D = disparitySGM(rectL, rectR, "DisparityRange", [0 64]);
imshow(D,[])
h = colorbar;
h.Label.String = 'Disparity (pixels)';
h.Label.FontSize = 10;
rvcprint3('fig14_38')

%% 14.5 Anaglyphs

% Fig 14.36

% a is a PNG
% b is generated below
Rcolor = imread("rocks2-r.png");
A = stereoAnaglyph(Lcolor, Rcolor);
imshow(A)
rvcprint3('fig14_36b')

%% 14.6 Other Depth Sensing Technologies

%% 14.6.1 Depth from Structured Light

%% 14.6.1 Depth from Time-Of-Flight

%% 14.7 Point Clouds

% Fig 14_bunny
% read and display the bunny
bunny = pcread("bunny.ply")
pcshow(bunny, VerticalAxis="Y", BackgroundColor="white", ViewPlane="XY", ...
    AxesVisibility="off")
rvcprint3('fig14_42a');

% Fig 14_bunny_normals
% compute normals
bunny_d = pcdownsample(bunny, 'gridAverage', 0.01);
normals = pcnormals(bunny_d);
  
pcshow(bunny_d, VerticalAxis="Y", BackgroundColor="white", ViewPlane="XY", ...
    AxesVisibility="off"); 
hold on

x = bunny_d.Location(:,1);
y = bunny_d.Location(:,2);
z = bunny_d.Location(:,3);
[u, v, w] = deal(normals(:,1), normals(:,2), normals(:,3));

% Plot the normal vectors
quiver3(x, y, z, u, v, w);
rvcprint3('fig14_42b');

%% 14.7.1 Fitting Geometric Objects into a Point Cloud

ptCloud = pcread("deskScene.pcd");

% Fig 14.421
% Show the scene as an image
imshow(ptCloud.Color)
rvcprint3('fig14_421a');
close all

pcshow(ptCloud, Projection="perspective", BackgroundColor="white",...
    AxesVisibility="on")
xlabel('X(m)'); ylabel('Y(m)'); zlabel('Z(m)')
rvcprint3('fig14_421b');
close all

% Fig 14.422
rng(0)
[planeModel, inlierIdx, outlierIdx] = pcfitplane(ptCloud, 0.02, [0,0,1]);
plane = select(ptCloud, inlierIdx);
remainingPoints = select(ptCloud, outlierIdx);
pcshow(plane, Projection="perspective", BackgroundColor="white",...
    AxesVisibility="on")
xlabel('X(m)'); ylabel('Y(m)'); zlabel('Z(m)')
rvcprint3('fig14_422a');
pcshow(ptCloud, Projection="perspective", BackgroundColor="white",...
    AxesVisibility="on")
hold on
planeModel.plot()
xlabel('X(m)'); ylabel('Y(m)'); zlabel('Z(m)')
rvcprint3('fig14_422b');
close all

% Fig 14.423
% Fitting a sphere
% Set the roi to constrain the search
roi = [-inf, 0.5, 0.2, 0.4, 0.1, inf];
sampleIdx = findPointsInROI(ptCloud, roi);
rng(0)
[model, inlierIdx] = pcfitsphere(ptCloud, 0.01, 'SampleIndices', sampleIdx);
globe = select(ptCloud, inlierIdx);
pcshow(globe, Projection="perspective", BackgroundColor="white",...
    AxesVisibility="on")
xlabel('X(m)'); ylabel('Y(m)'); zlabel('Z(m)')
rvcprint3('fig14_423a');

close all
pcshow(ptCloud, Projection="perspective", BackgroundColor="white",...
    AxesVisibility="on"), hold on
plot(model)
xlabel('X(m)'); ylabel('Y(m)'); zlabel('Z(m)')
rvcprint3('fig14_423b');

close all

%% 14.5.2 Matching Two Sets of Points

bunny = pcread("bunny.ply");
rng(0)
model = pcdownsample(bunny, "random", 0.1);

data  = pcdownsample(bunny, "random", 0.05);
tform = rigidtform3d([0 0 rad2deg(1)],[0.3 0.4 0.5]);
data  = pctransform(data, tform);
pcshowpair(model, data, Projection="perspective", BackgroundColor="white",...
    AxesVisibility="on", VerticalAxis="Y", ViewPlane="XY")
xlabel('X(m)'); ylabel('Y(m)'); zlabel('Z(m)')

set(gca,'CameraPosition',...
    [0.692675352024915 0.787443674345432 4.48339337611144],'CameraUpVector',...
    [-0.0169609344336615 0.992546151641322 -0.120683319332619]);

rvcprint3('fig14_424a'); % figure was hand-adjusted before the print


[tformOut, dataReg] = pcregistericp(data, model, "Tolerance", [0.01, 0.1], ...
    "MaxIterations", 100);
pcshowpair(model, dataReg, Projection="perspective", BackgroundColor="white",...
    AxesVisibility="on", VerticalAxis="Y", ViewPlane="XY")
xlabel('X(m)'); ylabel('Y(m)'); zlabel('Z(m)')

set(gca,'CameraPosition',...
    [0.692675352024915 0.787443674345432 4.48339337611144],'CameraUpVector',...
    [-0.0169609344336615 0.992546151641322 -0.120683319332619]);

rvcprint3('fig14_424b');

%% 14.8 Applications

%% 14.8.1 Perspective Correction

im = imread("notre-dame.jpg");
imshow(im)

p1 = [43 382;90 145;539 154;613 371];
h = drawpolygon("Position", p1, "Color", "y");

mn = min(p1);
mx = max(p1);
p2 = [mn(1) mx(2); mn(1) mn(2); mx(1) mn(2); mx(1) mx(2)];

drawpolygon("Position", p2, "FaceAlpha", 0, "Color", "r");
rvcprint3('fig14_45');

H = estgeotform2d(p1, p2, "projective");

imWarped = imwarp(im, H);
imshow(imWarped)
rvcprint3('fig14_46');

%% 14.8.2 Mosaicing

% Fig 491
mosaicFolder = fullfile(rvctoolboxroot,"examples","mosaic");
im1 = imread(fullfile(mosaicFolder,"aerial2-01.png"));
im2 = imread(fullfile(mosaicFolder,"aerial2-02.png"));

composite = zeros(1200,1500, "uint8");

pts1 = detectSURFFeatures(im1);
[f1, pts1] = extractFeatures(im1, pts1);

pts2 = detectSURFFeatures(im2);
[f2, pts2] = extractFeatures(im2, pts2);

idxPairs = matchFeatures(f1, f2, 'Unique', true);
       
matchedPts1 = pts1(idxPairs(:,1));
matchedPts2 = pts2(idxPairs(:,2));
    
% Estimate the transformation between the images
rng(0)
H = estimateGeometricTransform2D(matchedPts2, matchedPts1,...
    'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

refObj = imref2d(size(composite));
tile = imwarp(im2, H, "OutputView", refObj);

imshow(imfuse(im1, tile, "blend"))
rvcprint3('fig14_491a');

% Improved blend
blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');
mask1  = true(size(im1,[1 2]));
composite = blender.step(composite, im1, mask1);
tileMask  = imwarp(true(size(im2,[1 2])), H, 'OutputView', refObj);
composite = blender.step(composite, tile, tileMask);

imshow(composite)
rvcprint3('fig14_491b');

% Run the example script
mosaic()
rvcprint3('fig14_49');

%% 14.8.3 Visual Odometry

% websave("Bridge-Left.7z", "http://www.mi.auckland.ac.nz/DATA/6D/Set04/hella/Bridge-Left.7z");
% mkdir left
% !mv Bridge-Left.7z left
% cd left
% !p7zip -d Bridge-Left.7z
% websave("Bridge-Right.7z", "http://www.mi.auckland.ac.nz/DATA/6D/Set04/hella/Bridge-Right.7z");
% mkdir right
% !mv Bridge-Right.7z left
% cd right
% !p7zip -d Bridge-Right.7z

% Fig 14.57
left  = imageDatastore(fullfile("visodom", "left"));
size(left.Files,1)
tformFcn = @(in) imcrop(im2uint8(imadjust(in)), [17 17 730 460]);
left  = left.transform(tformFcn);

for i=1:15
    frame = left.read(); 
    imshow(frame); hold on
    features = detectORBFeatures(frame);
    features.plot("ShowScale",false); hold off
end
title("Frame 15");
rvcprint3('fig14_50');


% Fig 14.58
doVisodomFigures = true;
visodom
doVisodomFigures = false;




