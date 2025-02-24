%[text] %[text:anchor:F4CCA683] # Robotics, Vision & Control 3e: for MATLAB
%[text] %[text:anchor:CAAB408D] # Chapter 14: Using Multiple Images
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%[text] %[text:anchor:BDE73702] # 
%[text] Copyright 2022\-2023 Peter Corke, Witold Jachimczyk, Remo Pillat
%[text] %[text:anchor:T_B7CFA7E4] ## 14\.1 Point Feature Correspondence
im1 = rgb2gray(imread("eiffel2-1.jpg"));
im2 = rgb2gray(imread("eiffel2-2.jpg"));

hf = detectHarrisFeatures(im1);
imshow(im1); hold on
plot(hf.selectStrongest(200))

sf = detectSURFFeatures(im1);
imshow(im1); hold on
plot(sf.selectStrongest(200))

hd = extractFeatures(im1,hf)

sf1 = detectSURFFeatures(im1);
[sfd1,vsf1] = extractFeatures(im1,sf1);
size(sfd1)
sf2 = detectSURFFeatures(im2);
[sfd2,vsf2] = extractFeatures(im2,sf2);
size(sfd2)

[idx,s] = matchFeatures(sfd1,sfd2)

matchedPts1 = vsf1(idx(:,1));
matchedPts2 = vsf2(idx(:,2));
showMatchedFeatures(im1,im2,matchedPts1,matchedPts2);
%%
%[text] %[text:anchor:54D179D1] ## 14\.2 Geometry of Multiple Views
T1 = se3(eul2rotm([0 0.4 0]),[-0.1 0 0]);
cam1 = CentralCamera("default",name="camera 1",focal=0.002,pose=T1);

T2 = se3(eul2rotm([0 -0.4 0]),[0.1 0 0]);
cam2 = CentralCamera("default",name="camera 2",focal=0.002,pose=T2);

axis([-0.4 0.6 -0.5 0.5 -0.2 1])
cam1.plot_camera("label",color="b")
cam2.plot_camera("label",color="r")

P=[0.5 0.1 0.8];

plotsphere(P,0.03,"b");
grid on, view([-34 26])

p1 = cam1.plot(P)
p2 = cam2.plot(P)

cam1.hold
e1 = cam1.plot(cam2.center,Marker="d",MarkerFaceColor="k")
cam2.hold
e2 = cam2.plot(cam1.center,Marker="d",MarkerFaceColor="k")
%[text] %[text:anchor:1E1B2BFE] ### 14\.2\.1 The Fundamental Matrix
F = cam1.F(cam2)

e2h(p2)*F*e2h(p1)'

rank(F)

null(F)'  % transpose for display

e1 = h2e(ans)

null(F')'; 
e2 = h2e(ans)

cam2.plot_epiline(F,p1,"r")

cam1.plot_epiline(F',p2,"r")
%[text] %[text:anchor:CDA4E4B2] ### 14\.2\.2 The Essential Matrix
E = cam1.E(F)

pose = estrelpose(E,cam1.intrinsics(),p1,p2);
pose.A

inv(cam1.T)*cam2.T
%[text] %[text:anchor:EFDB8FE2] ### 14\.2\.3 Estimating the Fundamental Matrix from Real Image Data
tform = rigidtform3d([0 0 0],[-1 -1 2]);
rng(0) % set random seed for reproducibility of results
P = tform.transformPointsForward(2*rand(20,3));

p1 = cam1.project(P);
p2 = cam2.project(P);

F = estimateFundamentalMatrix(p1,p2,Method="Norm8Point")

rank(F)

cam2.plot(P);
cam2.hold

cam2.plot_epiline(F,p1,"r")

epidist(F,p1(1,:),p2(1,:))
epidist(F,p1(7,:),p2(7,:))

p2([8 7],:) = p2([7 8],:);

F1 = estimateFundamentalMatrix(p1,p2,Method="Norm8Point")

epidist(F1,p1(1,:),p2(1,:))
epidist(F1,p1(7,:),p2(7,:))

[F,in] = estimateFundamentalMatrix(p1,p2,Method="MSAC", ...
    DistanceThreshold=0.02); 

in' % transpose for display

rng(0) % set random seed for reproducibility of results
[F,in] = estimateFundamentalMatrix(matchedPts1,matchedPts2);
F
sum(in)

load("pointsForLineFitting.mat");
plot(points(:,1),points(:,2),".r",MarkerSize=15)
hold on

modelLeastSquares = polyfit(points(:,1),points(:,2),1);
x = [min(points(:,1)),max(points(:,1))];
y = modelLeastSquares(1)*x+modelLeastSquares(2);
plot(x,y,"b--");

sampleSize = 2; maxDistance = 2;
fitLineFcn = @(points) polyfit(points(:,1),points(:,2),1);
evaluateFitFcn = @(model,points) sum((points(:,2)- ...
  polyval(model,points(:,1))).^2,2);
rng(0); % set random seed for reproducibility of results
[ab,inliers] = ransac(points,fitLineFcn,evaluateFitFcn, ...
  sampleSize,maxDistance);

y = ab(1)*x+ab(2);
plot(x,y,"b-");

showMatchedFeatures(im1,im2,matchedPts1(in),matchedPts2(in));


epiLines = epipolarLine(F',matchedPts2.Location(in,:));
pts = lineToBorderPoints(epiLines,size(im1));
imshow(im1), hold on
line(pts(:,[1 3])',pts(:,[2 4])');

epole = h2e(null(F)');
plot(epole(1),epole(2),"bo");
%[text] %[text:anchor:A6750EFE] ### 14\.2\.4 Planar Homography
T1 = se3(eul2rotm([0 0.4 0]),[-0.1 0 0]);
cam1 = CentralCamera("default",name="camera 1", ...
  focal=0.002,pose=T1);
T2 = se3(eul2rotm([0 -0.4 0]),[0.1 0 0]);
cam2 = CentralCamera("default",name="camera 2", ...
  focal=0.002,pose=T2);

Tgrid = se3(eul2rotm([0.1 0.2 0],"XYZ"),[0 0 1]);
P = mkgrid(3,1.0,pose=Tgrid);

p1 = cam1.plot(P,"o");
p2 = cam2.plot(P,"o");

H = estgeotform2d(p1,p2,"projective");
H.A

p2b = H.transformPointsForward(p1);

cam2.hold()
cam2.plot(p2b,"+")

p1b = H.transformPointsInverse(p2);

Q = [-0.2302   0.3287   0.4000
     -0.0545   0.4523   0.5000
      0.2537   0.6024   0.6000];

axis([-1 1 -1 1 -0.2 1.8])
plotsphere(P,0.05,"b")
plotsphere(Q,0.05,"r")
cam1.plot_camera("label",color="b")
cam2.plot_camera("label",color="r")
grid on, view([-25 15])

p1 = cam1.plot([P;Q],"o");

p2 = cam2.plot([P;Q],"o");

p2h = H.transformPointsForward(p1);

cam2.plot(p2h,"+");

vecnorm(p2h'-p2')

[H,inlierIdx] = estgeotform2d(p1,p2,"projective");
H.A
inlierIdx'  % transpose for display

pose = estrelpose(H,cam1.intrinsics(),p1(inlierIdx,:), ...
   p2(inlierIdx,:));
pose.A

inv(cam1.T)*cam2.T

inv(cam1.T)*Tgrid

im1 = rgb2gray(imread("walls-l.jpg"));
im2 = rgb2gray(imread("walls-r.jpg"));

pts1 = detectSURFFeatures(im1);
pts2 = detectSURFFeatures(im2);
[sf1,vpts1] = extractFeatures(im1,pts1);
[sf2,vpts2] = extractFeatures(im2,pts2);

idxPairs = matchFeatures(sf1,sf2,Unique=true);
matchedPts1 = vpts1(idxPairs(:,1));
matchedPts2 = vpts2(idxPairs(:,2));

rng(0) % set random seed for reproducibility of results
[H,inliersWall] = estgeotform2d(matchedPts1, matchedPts2, ...
   "projective", MaxDistance=4);
wallPts = matchedPts1(inliersWall);
wallPts.Count

imshow("walls-l.jpg"), hold on
wallPts.plot()

outliers = matchedPts1(~inliersWall);
%%
%[text] %[text:anchor:D260638D] ## 14\.3 Sparse Stereo
%[text] %[text:anchor:99DD4325] ### 14\.3\.1 3D Triangulation
rng(0) % set random seed for reproducibility of results
[F,in] = estimateFundamentalMatrix(matchedPts1,matchedPts2);

epiLines = epipolarLine(F',matchedPts2(in));
pts = lineToBorderPoints(epiLines,size(im1));
imshow(im1), hold on
line(pts(1:40,[1 3])',pts(1:40,[2 4])',color="y");

md = imfinfo("walls-l.jpg");

f = md.DigitalCamera.FocalLength

md.Model

flenInPix = (f/1000)/1.5e-6;
imSize = size(im1);
principalPoint = imSize/2+0.5;
camIntrinsics = cameraIntrinsics(flenInPix,principalPoint,imSize)

rng(0) % set random seed for reproducibility of results
[E,in] = estimateEssentialMatrix(matchedPts1,matchedPts2, ...
    camIntrinsics,MaxDistance=0.18,Confidence=95);

inlierPts1 = matchedPts1(in);
inlierPts2 = matchedPts2(in);
pose = estrelpose(E,camIntrinsics,inlierPts1,inlierPts2);
pose.R
pose.Translation

t = pose.Translation*0.3;

tform1 = rigidtform3d;   % null tranforms by default
camMatrix1 = cameraProjection(camIntrinsics,tform1);
cameraPose = rigidtform3d(pose.R,t);
tform2 = pose2extr(cameraPose);
camMatrix2 = cameraProjection(camIntrinsics,tform2);

P = triangulate(inlierPts1,inlierPts2,camMatrix1,camMatrix2);

z = P(1:100,3);

circles = [inlierPts1.Location(1:100,:) repmat(15,[100 1])];
imAnnotated = insertObjectAnnotation(im1,"circle", ...
    circles,z,FontSize=50,LineWidth=4);
imshow(imAnnotated)

pc = pointCloud(P);
pcshow(pcdenoise(pc),VerticalAxis="Y",VerticalAxisDir="Down");
%[text] %[text:anchor:A2A74AE6] ### 14\.3\.2 Bundle Adjustment (advanced)
T1 = tform1; T2 = tform2;
translationError = [0 0.01 -0.02];
T2.Translation = T2.Translation + translationError;
p1 = world2img(P,T1,camIntrinsics);
p2 = world2img(P,T2,camIntrinsics);

e = vecnorm([p1-inlierPts1.Location; p2-inlierPts2.Location]');

mean(e)
max(e)

vSet = imageviewset;

absPose1 = T1;

relPose2 = extr2pose(T2);
absPose2 = relPose2;
vSet = vSet.addView(1,absPose1,Points=pts1);
vSet = vSet.addView(2,absPose2,Points=pts2);

vSet = vSet.addConnection(1,2,relPose2,Matches=idxPairs(in,:));

tracks = vSet.findTracks([1 2]);
camPoses = vSet.poses();

[Pout,camPoses,e] = bundleAdjustment(P,tracks,camPoses, ...
    camIntrinsics,FixedViewId=1,PointsUndistorted=true, ...
    Verbose=true);

max(e)

median(e)

size(find(e > 1),1)

[mx,k] = max(e)
%%
%[text] %[text:anchor:87E98A12] ## 14\.4 Dense Stereo Matching
L = imread("rocks2-l.png");
R = imread("rocks2-r.png");
imshowpair(L,R,"montage")
L = rgb2gray(L); R = rgb2gray(R);

imtool(imfuse(L,R))

D = disparityBM(L,R,DisparityRange=[80 208],BlockSize=13);

imshow(D,[])
%[text] %[text:anchor:9CFE69AA] ### 14\.4\.2 Refinement and Reconstruction
sum(D(:)~=79)/prod(size(L))*100 
%[text] %[text:anchor:E96B6743] #### 14\.4\.2\.1 3D Reconstruction

D(D==79) = NaN;

D = D+274;

[U,V] = meshgrid(1:size(L,2),1:size(L,1));
u0 = size(L,2)/2; v0 = size(L,1)/2;
b = 0.160;
X = b*(U-u0)./D; Y = b*(V-v0)./D; Z = 3740*b./D;

Z = medfilt2(Z,[5 5]);
surf(Z)
shading interp; view(-74,44)
set(gca,ZDir="reverse"); set(gca,XDir="reverse")
colormap(parula)

%[text] %[text:anchor:4001DE45] #### 14\.4\.2\.2 3D\-Texture Mapped Display

Lcolor = imread("rocks2-l.png");

surface(X,Y,Z,Lcolor,FaceColor="texturemap", ...
  EdgeColor="none",CDataMapping="direct")
set(gca,ZDir="reverse"); set(gca,XDir="reverse")
view(-74,44), grid on
%[text] %[text:anchor:2378B6C0] ### 14\.4\.3 Image Rectification
imL = imresize(rgb2gray(imread("walls-l.jpg")),0.25);
imR = imresize(rgb2gray(imread("walls-r.jpg")),0.25);

ptsL = detectSURFFeatures(imL);
ptsR = detectSURFFeatures(imR);
[sfL,vptsL] = extractFeatures(imL,ptsL);
[sfR,vptsR] = extractFeatures(imR,ptsR);

idxPairs = matchFeatures(sfL,sfR);
matchedPtsL = vptsL(idxPairs(:,1));
matchedPtsR = vptsR(idxPairs(:,2));

[F,inlierIdx] = estimateFundamentalMatrix(matchedPtsL,matchedPtsR, ...
  Method="MSAC",NumTrials=6000,DistanceThreshold=0.04,Confidence=95);

inlierPtsL = matchedPtsL(inlierIdx);
inlierPtsR = matchedPtsR(inlierIdx);
[tformL,tformR] = estimateStereoRectification(F,inlierPtsL,inlierPtsR,size(imL));
[rectL,rectR] = rectifyStereoImages(imL,imR,tformL,tformR);

imshowpair(rectL,rectR,"montage");

d = disparitySGM(rectL,rectR,"DisparityRange",[0 64]);
imshow(d,[])
%%
%[text] %[text:anchor:65564976] ## 14\.5 Anaglyphs
Rcolor = imread("rocks2-r.png");
A = stereoAnaglyph(Lcolor,Rcolor);
imshow(A)
%%
%[text] %[text:anchor:474835AE] ## 14\.7 Point Clouds
bunny = pcread("bunny.ply")
pcshow(bunny, VerticalAxis="Y")

veloReader = velodyneFileReader("lidarData_ConstructionRoad.pcap", ...
  "HDL32E");
xlimits = [-60 60]; ylimits = [-60 60]; zlimits = [-20 20];
player = pcplayer(xlimits, ylimits, zlimits);
xlabel(player.Axes,"X (m)"); ylabel(player.Axes,"Y (m)"); ...
  zlabel(player.Axes,"Z (m)");
while(hasFrame(veloReader) && player.isOpen())
  ptCloud = readFrame(veloReader);
  view(player,ptCloud);
end

bunny_d = pcdownsample(bunny,gridAverage=0.01);
bunny_d.Count

normals = pcnormals(bunny_d);
pcshow(bunny_d,VerticalAxis="Y"); hold on
x = bunny_d.Location(:,1);
y = bunny_d.Location(:,2);
z = bunny_d.Location(:,3);
[u,v,w] = deal(normals(:,1),normals(:,2),normals(:,3));
quiver3(x,y,z,u,v,w);
%[text] %[text:anchor:913B988C] ### 14\.7\.1 Fitting Geometric Objects into a Point Cloud
ptCloud = pcread("deskScene.pcd");

imshow(ptCloud.Color), figure
pcshow(ptCloud)

rng(0) % set random seed for reproducibility of results
[planeModel,inlierIdx,outlierIdx] = pcfitplane(ptCloud,0.2,[0,0,1]);
planeModel

plane = select(ptCloud,inlierIdx);
remainingPoints = select(ptCloud,outlierIdx);
pcshow(plane), figure
pcshow(ptCloud), hold on
planeModel.plot()

roi = [-inf 0.5 0.2 0.4 0.1 inf];
sampleIdx = findPointsInROI(ptCloud,roi);
rng(0) % set random seed for reproducibility of results
[model,inlierIdx] = pcfitsphere(ptCloud,0.01,SampleIndices=sampleIdx);
globe = select(ptCloud,inlierIdx);
pcshow(globe), figure
pcshow(ptCloud), hold on
plot(model)
%[text] %[text:anchor:3F7FD3A7] ### 14\.7\.2 Matching Two Sets of Points
bunny = pcread("bunny.ply");
rng(0) % set random seed for reproducibility of results
model = pcdownsample(bunny,"random",0.1);

data = pcdownsample(bunny, "random", 0.05);
tform = rigidtform3d([0 0 60], ...   % [rx, ry, rz] in degrees
                     [0.3 0.4 0.5]); % [tx, ty, tz] in meters
data = pctransform(data, tform);

pcshowpair(model,data,VerticalAxis="Y")

[tformOut,dataReg] = pcregistericp(data,model,Tolerance=[0.01 0.1], ...
  MaxIterations=100);
tout = tformOut.invert
rad2deg(rotm2eul(tout.R)) % [rz ry rx] in degrees

pcshowpair(model,dataReg,VerticalAxis="Y")
%%
%[text] %[text:anchor:7CCC9FE5] ## 14\.8 Applications
%[text] %[text:anchor:BBB08040] ### 14\.8\.1 Perspective Correction
im = imread("notre-dame.jpg");
imshow(im)

isInteractive = false; % set to true to select points manually
if isInteractive
  h = drawpolygon(Color="y"); 
  wait(h);
else % use preselected points for reproducibility
  p1 = [43 382;90 145;539 154;613 371];
  h = drawpolygon(Position=p1, Color="y");
end

p1 = h.Position

mn = min(p1);
mx = max(p1);
p2 = [mn(1) mx(2); mn(1) mn(2); mx(1) mn(2); mx(1) mx(2)];

drawpolygon("Position",p2,Color="r",FaceAlpha=0);

H = fitgeotform2d(p1,p2,"projective");
H.A

imWarped = imwarp(im,H);
imshow(imWarped)

md = imfinfo("notre-dame.jpg");
f = md.DigitalCamera.FocalLength

pixelDims = [7.18 5.32]./size(im,[2 1]); % in mm
focalLenInPix = f./pixelDims;
imSize    = size(im,[1 2]);
principalPoint = imSize/2+0.5; % +0.5 to fall exactly in the middle
camIntrinsics = cameraIntrinsics(focalLenInPix,principalPoint,imSize)

pose = estrelpose(H,camIntrinsics,p1,p2)

rad2deg(tform2eul(pose.A))
%[text] %[text:anchor:4C3DA51C] ### 14\.8\.2 Image Mosaicing
fetchExampleData("Mosaicing"); % Download example data
mosaicFolder = fullfile(rvctoolboxroot,"examples","mosaic");
im1 = imread(fullfile(mosaicFolder,"aerial2-01.png"));
im2 = imread(fullfile(mosaicFolder,"aerial2-02.png"));

composite = zeros(1200,1500,"uint8");

pts1 = detectSURFFeatures(im1);
[f1,pts1] = extractFeatures(im1,pts1);
pts2 = detectSURFFeatures(im2);
[f2,pts2] = extractFeatures(im2,pts2);
idxPairs = matchFeatures(f1,f2,Unique=true);
matchedPts1 = pts1(idxPairs(:,1));
matchedPts2 = pts2(idxPairs(:,2));

rng(0) % set random seed for reproducibility of results
H = estgeotform2d(matchedPts2,matchedPts1, ...
    "projective",Confidence=99.9,MaxNumTrials=2000);

refObj = imref2d(size(composite));
tile = imwarp(im2,H,OutputView=refObj);

blended = imfuse(im1,tile,"blend");
imshow(blended)

blender = vision.AlphaBlender(Operation="Binary mask", ...
    MaskSource="Input port");
mask1 = true(size(im1,[1 2]));
composite = blender.step(composite,im1,mask1);
tileMask = imwarp(true(size(im2,[1 2])),H,OutputView=refObj);
composite = blender.step(composite,tile,tileMask);
imshow(composite)

mosaic
%[text] %[text:anchor:3EE60608] ### 14\.8\.3 Visual Odometry
fetchExampleData("VisualOdometry"); % Download example data
visodomFolder = fullfile(rvctoolboxroot,"examples","visodom");
left = imageDatastore(fullfile(visodomFolder,"left"));
size(left.Files,1)

tformFcn = @(in)imcrop(im2uint8(imadjust(in)),[17 17 730 460]);
left = left.transform(tformFcn);

while left.hasdata()
   imshow(left.read())
end
left.reset() % rewind to first image

while left.hasdata()
  frame = left.read(); 
  imshow(frame), hold on
  features = detectORBFeatures(frame);
  features.plot(ShowScale=false), hold off
end
left.reset();

right = imageDatastore(fullfile(visodomFolder,"right"));
right = right.transform(tformFcn);

visodom

ts = load(fullfile(visodomFolder,"timestamps.dat"));

plot(diff(ts))
%%
%[text] %[text:anchor:C4AF090A] ## 
%[text] %[text:anchor:H_41E2F4AF] Suppress syntax warnings in this file
%#ok<*NOANS>
%#ok<*MINV>
%#ok<*NASGU>
%#ok<*NBRAK2>
%#ok<*VUNUS>
%#ok<*ASGLU>
%#ok<*PSIZE>
%#ok<*UNRCH>

%[appendix]
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
