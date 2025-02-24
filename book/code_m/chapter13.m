%[text] %[text:anchor:F4CCA683] # Robotics, Vision & Control 3e: for MATLAB
%[text] %[text:anchor:CAAB408D] # Chapter 13: Image Formation
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%[text] %[text:anchor:174C9FFD] # 
%[text] Copyright 2022\-2023 Peter Corke, Witold Jachimczyk, Remo Pillat
%[text] %[text:anchor:T_0C63683F] ## 13\.1 Perspective Camera
%[text] %[text:anchor:D361693E] ### 13\.1\.2 Modeling a Perspective Camera
cam = CentralCamera(focal=0.015);

P = [0.3 0.4 3.0];

cam.project(P)

cam.project(P,pose=se3(eye(3),[-0.5 0 0]))
%[text] %[text:anchor:0421FAEA] ### 13\.1\.3 Discrete Image Plane
cam = CentralCamera(focal=0.015,pixel=10e-6, ...
      resolution=[1280 1024],center=[640 512],name="mycamera")

cam.project(P)
%[text] %[text:anchor:9FE2F47A] ### 13\.1\.4 Camera Matrix
cam.K

cam.C

fov = cam.fov();
rad2deg(fov)
%[text] %[text:anchor:97288190] ### 13\.1\.5 Projecting Points
P = mkgrid(3,0.2,pose=se3(eye(3),[0 0 1.0]));

P(1:4,:)

cam.project(P)

cam.plot(P)

Tcam = se3(eul2rotm([0 0.9 0]),[-1 0 0.5]);

cam.plot(P,pose=Tcam)

cam.project([1 0 0 0],pose=Tcam)

p = cam.plot(P,pose=Tcam);

p(1:4,:)

cube = mkcube(0.2,pose=se3(eye(3),[0 0 1]));

cam.plot(cube);

[X,Y,Z] = mkcube(0.2,"edge",pose=se3(eye(3),[0 0 1]));

cam.mesh(X, Y, Z)

Tcam = se3(eul2rotm([0 0.8 0]),[-1 0 0.4]);
cam.mesh(X,Y,Z,pose=Tcam);

theta = [0:500]/100*2*pi; 
[X,Y,Z] = mkcube(0.2,[],"edge");
for th=theta
  T_cube = se3(eul2rotm(th*[1.3 1.2 1.1]),[0 0 1.5]);
  cam.mesh(X,Y,Z,objpose=T_cube); drawnow
end
%[text] %[text:anchor:CA7B3999] ### 13\.1\.6 Lens Distortion
% Not runnable unless you define k1, k2, k3, p1, and p2

%cam = CentralCamera(focal=0.015,pixel=10e-6, ...
%  resolution=[1280 1024],center=[512 512], ...
%  distortion=[k1 k2 k3 p1 p2]);
%%
%[text] %[text:anchor:29ADF620] ## 13\.2 Camera Calibration
%[text] %[text:anchor:1B2E44C0] ### 13\.2\.1 Calibrating with a 3D Target
P = mkcube(0.2);

T_unknown = se3(eul2rotm([0.3 0.2 0.1]),[0.1 0.2 1.5]);

rng(0) % set random seed for reproducibility of results
cam = CentralCamera(focal=0.015,pixel=10e-6, ...
  resolution=[1280 1024],noise=0.05);

p = cam.project(P,objpose=T_unknown);

C = camcald(P,p)
%[text] %[text:anchor:F9A4EF18] ### 13\.2\.2 Decomposing the Camera Calibration Matrix
wo = null(C)'  % transpose for display

h2e(wo)

T_unknown.inv.trvec

est = decomposeCam(C)

est.f/est.rho(1)

cam.f/cam.rho(2)

printtform(T_unknown*est.T)

hold on; plotsphere(P,0.03,"r")
plottform(eye(4,4),frame="T",color="b",length=0.3)

est.plot_camera()
view([40 19])
%[text] %[text:anchor:9DF24DAD] ### 13\.2\.3 Pose Estimation with a Calibrated Camera
cam = CentralCamera(focal=0.015,pixel=10e-6, ...
      resolution=[1280 1024],center=[640 512]);

P = mkcube(0.2);

T_unknown = se3(eul2rotm([0.3 0.2 0.1]),[0.1 0.2 1.5]);
T_unknown.trvec
rad2deg(rotm2eul(T_unknown.rotm))

p = cam.project(P,objpose=T_unknown);

T_est = cam.estpose(P,p);
T_est.trvec
rad2deg(rotm2eul(T_est.rotm))
%[text] %[text:anchor:26F038A7] ### 13\.2\.4 Camera Calibration Tools
cameraCalibrator

% Not runnable unless camera calibration is complete

%cameraParams
%cameraParams.Intrinsics
%cameraParams.Intrinsics.K

stereoCameraCalibrator
%%
%[text] %[text:anchor:39BF5432] ## 13\.3 Wide Field\-of\-View Cameras
%[text] %[text:anchor:C0AC3ADF] ### 13\.3\.1 Fisheye Lens Camera
cam = FishEyeCamera(name="fisheye",projection="equiangular", ...
  pixel=10e-6,resolution=[1280 1024]);

[X,Y,Z] = mkcube(0.2,"edge",center=[0.2 0 0.3]);

cam.mesh(X,Y,Z)
%[text] %[text:anchor:CC2AB5E2] ### 13\.3\.2 Catadioptric Camera
cam = CatadioptricCamera(name="panocam",projection="equiangular", ...
  maxangle=pi/4,pixel=10e-6,resolution=[1280 1024]);

[X,Y,Z] = mkcube(1,"edge",center=[1 1 0.8]);

cam.mesh(X,Y,Z)
%[text] %[text:anchor:36C1DC7A] ### 13\.3\.3 Spherical Camera
cam = SphericalCamera(name="spherical");

[X,Y,Z] = mkcube(1,"edge",center=[2 3 1]);

cam.mesh(X,Y,Z)
%%
%[text] %[text:anchor:73E08ECE] ## 13\.4 Unified Imaging Model
%[text] %[text:anchor:2F29D2E4] ### 13\.4\.1 Mapping Wide\-Angle Images to the Sphere
fisheye = rgb2gray(imread("fisheye_target.png"));
fisheye = im2double(fisheye);

[Ui,Vi] = meshgrid(1:size(fisheye,2), 1:size(fisheye,1));

n = 500;
theta_range = linspace(0,pi,n);
phi_range = linspace(-pi,pi,n);
[Phi,Theta] = meshgrid(phi_range,theta_range);

l = 2.7899; m = 996.4617;
r = (l+m)*sin(Theta)./(l-cos(Theta));

u0 = 528.1214; v0 = 384.0784;
U = r.*cos(Phi) + u0;
V = r.*sin(Phi) + v0;

spherical = interp2(Ui,Vi,fisheye,U,V);

imshow(spherical)

sphere
h = findobj(Type="surface");
set(h,CData=flipud(spherical),FaceColor="texture");
colormap(gray); view(-53,-9)
%[text] %[text:anchor:E52620D4] ### 13\.4\.2 Mapping from the Sphere to a Perspective Image
W = 1000;
m = W/2/tand(45/2)

l = 0;

u0 = W/2; v0 = W/2;

[Uo,Vo] = meshgrid(0:W-1,0:W-1);

[phi,r] = cart2pol(Uo-u0,Vo-v0);

Phi_o = phi;
Theta_o = pi-atan(r/m);

perspective = interp2(Phi,Theta,spherical,Phi_o,Theta_o);

imshow(perspective)

tform = se3(eul2rotm([0 0.9 -1.5],"XYZ"));
spherical = sphere_rotate(spherical,tform);

perspective = interp2(Phi,Theta,spherical,Phi_o,Theta_o);
imshow(perspective)
%%
%[text] %[text:anchor:588B61C2] ## 13\.6 Applications
%[text] %[text:anchor:9009DD4E] ### 13\.6\.1 Fiducial Markers
scene = imread("aprilTag36h11.jpg");
imshow(scene);

data = load("camIntrinsicsAprilTag.mat");
intrinsics = data.intrinsics;

scene = undistortImage(scene,intrinsics,OutputView="same");

tagSize = 0.04; % in meters
[id,loc,pose] = readAprilTag(scene,"tag36h11",intrinsics,tagSize);

worldPoints = [0 0 0; tagSize/2 0 0;...  % define axes points to draw
  0 tagSize/2 0; 0 0 tagSize/2];
for i = 1:length(pose)
  imagePoints = world2img(worldPoints,pose(i),intrinsics);
  scene = insertShape(scene,"Line",[imagePoints(1,:) imagePoints(2,:); ...
    imagePoints(1,:) imagePoints(3,:); imagePoints(1,:) imagePoints(4,:)], ...
    Color=["red","green","blue"],LineWidth=12);
  scene = insertText(scene,loc(1,:,i),id(i),BoxOpacity=1,FontSize=28);
end
imshow(scene)
%[text] %[text:anchor:0D7D1BDC] ### 13\.6\.2 Planar Homography
T_camera = se3(eul2rotm([0 0 -2.8]),[0 0 8]);
camera = CentralCamera("default",focal=0.012,pose=T_camera);

P = [-1 1; -1 2; 2 2; 2 1];

projP = camera.project(padarray(P,[0 1],0,"post"));
projP' % transpose for display

H = camera.C;
H(:,3) = []

Hobj = projtform2d(H);
projP = Hobj.transformPointsForward(P);
projP' % transpose for display

p = [0 0; 0 1000; 1000 1000; 1000 0];

Pi = Hobj.transformPointsInverse(p);
Pi' % transpose for display

camera.plot_camera(scale=2,color="y")
hold on
plotsphere(padarray(P,[0 1],0,"post"),0.2,"r")
plotsphere(padarray(Pi,[0 1],0,"post"),0.2,"b")
grid on, view([57 24])
%%
%[text] %[text:anchor:D9638045] ## 13\.7 Advanced Topics
%[text] %[text:anchor:061E13AC] ### 13\.7\.1 Projecting 3D Lines and Quadrics
L = Plucker([0 0 1],[1 1 1])

L.w

cam = CentralCamera("default");
l = cam.project(L)

cam.plot(L)

cam = CentralCamera("default",pose=se3(eul2rotm([0 0 0.2]),[0.2 0.1 -5]));

Q = diag([1 1 1 -1]);

Qs = inv(Q)*det(Q);  % adjugate
cs = cam.C*Qs*cam.C';
c = inv(cs)*det(cs); % adjugate

det(c(1:2,1:2))

syms x y real
ezplot([x y 1]*c*[x y 1]',[0 1024 0 1024])
set(gca,Ydir="reverse")
%[text] %[text:anchor:20FC9EA0] ### 
%[text] %[text:anchor:H_41E2F4AF] Suppress syntax warnings in this file
%#ok<*NOANS>
%#ok<*MINV>
%#ok<*NASGU>
%#ok<*NBRAK2>
%#ok<*EZPLT>
%#ok<*NBRAK1>

%[appendix]
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
