%% 13.1.5 Projecting Points

%% Fig 13.7a
cam = CentralCamera('focal', 0.015, 'pixel', 10e-6,...
    'resolution', [1280 1024], 'center', [640 512], 'name', 'mycamera')

P = mkgrid(3, 0.2, pose=se3(trvec2tform([0, 0, 1.0])));
P(1:4, :)

cam.project(P)
cam.plot(P)

set(0, 'showhiddenhandles','on')
grid on
rvcprint3('fig13_7a');
close all;

%% Fig 13.7b
Tcam = se3(eul2rotm([0, 0.9, 0]), [-1, 0, 0.5]);
cam.plot(P, 'pose', Tcam)

cam.project([1 0 0 0], pose=Tcam)

set(0, 'showhiddenhandles','on')
rvcprint3('fig13_7b');
close all;

%% Fig 13.8a

cube = mkcube(0.2, pose=se3(trvec2tform([0, 0, 1])));
cam.plot(cube);

% xxx [X,Y,Z] = mkcube(0.2, 'pose', SE3(0, 0, 1), 'edge');
[X,Y,Z] = mkcube(0.2, "edge", pose=se3(trvec2tform([0, 0, 1])));
cam.mesh(X, Y, Z)

rvcprint3('fig13_8a');
close all;

%% Fig 13.8b

Tcam = se3(eul2rotm([0, 0.8, 0]), [-1,0,0.4]);
cam.mesh(X, Y, Z, 'pose', Tcam);

rvcprint3('fig13_8b');
close all;

%% Fig 13.9
goProCalibration

%% 13.2.1 Calibrating with a 3D Target

%% Fig 13.11
P = mkcube(0.2);
T_unknown = se3(eul2rotm([0.3, 0.2, 0.1]), [0.1, 0.2, 1.5]);

cam = CentralCamera('focal', 0.015, ...
   'pixel', 10e-6, 'resolution', [1280 1024], 'noise', 0.05);

p = cam.project(P, 'objpose', T_unknown);
C = camcald(P, p)

%% 13.2.2 Decomposing the Camera Calibration Matrix

wo = null(C)'
h2e(wo)'
T_unknown.inv.trvec

est = decomposeCam(C)

est.f/est.rho(1)

cam.f/cam.rho(2)

printline(T_unknown*est.T)

hold on; plotsphere(P, 0.03, 'r')
plottform(eye(4,4), 'frame', 'T', 'color', 'b', 'length', 0.3)

est.plot_camera()

grid on;

view(gca,[40, 19]); % Set viewing rotation
lighting gouraud
light
axis equal;

rvcprint3('fig13_11');

%% 13.3.1 Fisheye Lens Camera

set(0, 'showhiddenhandles','on')

cam = FishEyeCamera('name', 'fisheye', ...
         'projection', 'equiangular', ...
         'pixel', 10e-6, ...
         'resolution', [1280 1024]);
     
[X,Y,Z] = mkcube(0.2, 'center', [0.2, 0, 0.3], 'edge');
cam.mesh(X, Y, Z)

rvcprint3('fig13_16');


%% 13.3.1 Catadioptric Camera

cam = CatadioptricCamera('name', 'panocam', ...
    'projection', 'equiangular', ...
    'maxangle', pi/4, ...
    'pixel', 10e-6, ...
    'resolution', [1280 1024]);

[X,Y,Z] = mkcube(1, 'center', [1, 1, 0.8], 'edge');

cam.mesh(X, Y, Z)

rvcprint3('fig13_20');

%% 13.3.2 Spherical Camera

cam = SphericalCamera('name', 'spherical');
[X,Y,Z] = mkcube(1, 'center', [2, 3, 1], 'edge');
cam.mesh(X, Y, Z)

rvcprint3('fig13_22');

%% Mapping Wide-Angle Images to the Sphere

% Fig 13.24a
fisheye = rgb2gray(imread('fisheye_target.png'));
fisheye = im2double(fisheye);

imshow(fisheye);
rvcprint3('fig13_24a');

% Fig 13.24b

fisheye = rgb2gray(imread('fisheye_target.png'));
fisheye = im2double(fisheye);

[Ui,Vi] = meshgrid(1:size(fisheye, 2), 1:size(fisheye, 1));

n = 500;
theta_range = linspace(0, pi, n);
phi_range = linspace(-pi, pi, n);
[Phi,Theta] = meshgrid(phi_range, theta_range);

l = 2.7899; m = 996.4617;
r = (l+m)*sin(Theta) ./ (l-cos(Theta));

u0 = 528.1214; v0 = 384.0784;
U = r.*cos(Phi) + u0;
V = r.*sin(Phi) + v0;

spherical = interp2(Ui, Vi, fisheye, U, V);

imshow(spherical)

rvcprint3('fig13_24b');

% Fig 13.25
fisheye = rgb2gray(imread('fisheye_target.png'));
fisheye = im2double(fisheye);
u0 = 528.1214; v0 = 384.0784;
l=2.7899;
m=996.4617;
[Ui,Vi] = meshgrid(1:size(fisheye, 2), 1:size(fisheye, 1));
n = 500;
theta_range = linspace(0, pi, n);
phi_range = linspace(-pi, pi, n);
[Phi,Theta] = meshgrid(phi_range, theta_range);

r = (l+m)*sin(Theta) ./ (l-cos(Theta));
U = r.*cos(Phi) + u0;
V = r.*sin(Phi) + v0;
spherical = interp2(Ui, Vi, fisheye, U, V);

sphere
h=findobj('Type', 'surface');
set(h,'cdata', spherical, 'facecolor', 'texture');
colormap(gray)
set(h,'CData', flipud(spherical), 'FaceColor', 'texture');

brighten(0.2);

xyzlabel
view(-53, -9)

rvcprint3('fig13_25');

%% 13.4.2 Mapping from the Sphere to a Perspective Image

% Fig 13.26a

n = 500;
theta_range = linspace(0, pi, n);
phi_range = linspace(-pi, pi, n);

[Phi,Theta] = meshgrid(phi_range, theta_range);

W = 1000;
m = W/2 / tan(45/2*pi/180);

l = 0;
u0 = W/2; v0 = W/2;
[Uo,Vo] = meshgrid(0:W-1, 0:W-1);
[phi,r ]= cart2pol(Uo-u0, Vo-v0);
Phi_o = phi;
Theta_o = pi - atan(r/m);

perspective = interp2(Phi, Theta, spherical, Phi_o, Theta_o);

imshow(perspective)
rvcprint3('fig13_26a');

% Fig 13.26b
tform = se3(eul2rotm([0, 0.9, -1.5], 'XYZ'));
spherical = sphere_rotate(spherical, tform);

perspective = interp2(Phi, Theta, spherical, Phi_o, Theta_o);

imshow(perspective)
rvcprint3('fig13_26b');

%% 13.5 Novel Cameras

%% Applications

%% 13.6.1 Fiducial Markers

% Read an image
scene = imread("aprilTag36h11.jpg");
imshow(scene)

% Load camera intrinsics and specify measured tag size
data = load("camIntrinsicsAprilTag.mat");
intrinsics = data.intrinsics;

% Undistort image
scene = undistortImage(scene, intrinsics, OutputView="same");

% Size of the tags in meters
tagSize = 0.04;

% Estimate tag poses
[id, loc, pose] = readAprilTag(scene, "tag36h11", intrinsics, tagSize);

% Origin and Axes vectors for the tag frames
worldPoints = [0 0 0; tagSize/2 0 0; 0 tagSize/2 0; 0 0 tagSize/2];

% Visualize the tag frames
for i = 1:length(pose)
    % Get image coordinates for axes
    imagePoints = world2img(worldPoints, pose(i), intrinsics);

    % Draw colored axes
    scene = insertShape(scene, "Line", [imagePoints(1,:) imagePoints(2,:); ...
        imagePoints(1,:) imagePoints(3,:); imagePoints(1,:) imagePoints(4,:)], ...
        Color=["red", "green", "blue"], LineWidth=12);    

    scene = insertText(scene, loc(1,:,i), id(i), BoxOpacity=1, FontSize=34);
end

% Display image
imshow(scene)
rvcprint3("fig13_apriltags")

%% 13.6.1 Planar Homography

T_camera = se3(eul2rotm([0 0 -2.8]), [0 0 8]);

camera = CentralCamera("default", focal=0.012, pose=T_camera);

P = [-1 1; -1 2; 2 2; 2 1];
camera.project(padarray(P, [0 1], 0, "post"))

H = camera.C;
H(:,3) = []

Hobj = projtform2d(H);
Hobj.transformPointsForward(P)'

p = [0 0; 0 1000; 1000 1000; 1000 0];

Pi = Hobj.transformPointsInverse(p);
Pi'

camera.plot_camera(scale=2, color="y")
hold on
plotsphere(padarray(P, [0 1], 0, "post"), 0.2, "r")
plotsphere(padarray(Pi, [0 1], 0, "post"), 0.2, "b")
grid on, view([57 24])

set(gca, "XLim", [-6, 6]);
set(gca, "ZLim", [-0.2, 10]);

rvcprint3("fig13_planar_homography")

