%[text] %[text:anchor:F4CCA683] # Robotics, Vision & Control 3e: for MATLAB
%[text] %[text:anchor:CAAB408D] # Chapter 10: Light and Color
%[text] 
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%[text] %[text:anchor:T_CA88FEE1] Copyright 2022\-2023 Peter Corke, Witold Jachimczyk, Remo Pillat
%[text] 
%[text] %[text:anchor:T_F02C25ED] ## 10\.1 Spectral Representation of Light
lambda = [300:10:1000]*1e-9;

for T=3000:1000:6000 %[output:group:04667b92]
  plot(lambda,blackbody(lambda,T)), hold on %[output:430bdb37]
end %[output:group:04667b92]
hold off

lamp = blackbody(lambda,2600);
sun = blackbody(lambda,5778);
plot(lambda, [lamp/max(lamp) sun/max(sun)])
%[text] %[text:anchor:A82E4ED1] ### 10\.1\.1 Absorption
sunGround = loadspectrum(lambda,"solar");
plot(lambda,sunGround)

[A,lambda] = loadspectrum([400:10:700]*1e-9,"water"); 

d = 5;
T = 10.^(-A*d);
plot(lambda,T)
%[text] %[text:anchor:A2435B6C] ### 10\.1\.2 Reflectance
[R,lambda] = loadspectrum([100:10:10000]*1e-9,"redbrick");
plot(lambda,R)
%[text] %[text:anchor:FDEC1B72] ### 10\.1\.3 Luminance
lambda = [400:700]*1e-9;
E = loadspectrum(lambda,"solar");

R = loadspectrum(lambda,"redbrick");

L = E.*R;
plot(lambda,L)
%%
%[text] %[text:anchor:1142C7AE] ## 10\.2 Color
human = luminos(lambda);
plot(lambda,human)

luminos(450e-9)/luminos(550e-9)
%[text] %[text:anchor:78910944] ### 10\.2\.1 The Human Eye
cones = loadspectrum(lambda,"cones");
plot(lambda,cones)
%[text] %[text:anchor:AEAF4131] ### 10\.2\.2 Camera sensor
%[text] %[text:anchor:9DF3B3BD] ### 10\.2\.3 Measuring Color
lambda = [400:700]*1e-9;
E = loadspectrum(lambda,"solar");
R = loadspectrum(lambda,"redbrick");
L = E.*R;  % light reflected from the brick
cones = loadspectrum(lambda,"cones");
sum((L*ones(1,3)).*cones*1e-9)
%[text] %[text:anchor:ADED269B] ### 10\.2\.4 Reproducing Colors
lambda = [400:700]*1e-9;
cmf = cmfrgb(lambda);
plot(lambda,cmf)

green = cmfrgb(500e-9)

white = -min(green)*[1 1 1]
feasible_green = green + white

rgbBrick = cmfrgb(lambda,L)
%[text] %[text:anchor:0A475F45] ### 10\.2\.5 Chromaticity Coordinates
[r,g] = lambda2rg([400:700]*1e-9);
plot(r,g)
rg_addticks

hold on
primaries = lambda2rg(cie_primaries());
plot(primaries(:,1),primaries(:,2),"o")

plotSpectralLocus

green_cc = lambda2rg(500e-9)
plot(green_cc(:,1),green_cc(:,2),"kp")

white_cc = tristim2cc([1 1 1])
plot(white_cc(:,1),white_cc(:,2),"o")

cmf = cmfxyz(lambda);
plot(lambda,cmf)

[x,y] = lambda2xy(lambda);
plot(x,y)

plotChromaticity

lambda2xy(550e-9)

lamp = blackbody(lambda,2600);
lambda2xy(lambda,lamp)
%[text] %[text:anchor:70788031] ### 10\.2\.6 Color Names
colorname("?burnt")

colorname("burntsienna")

bs = colorname("burntsienna","xy")

colorname("chocolate","xy")

colorname([0.2 0.3 0.4])
%[text] %[text:anchor:BDA3850A] ### 10\.2\.7 Other Color and Chromaticity Spaces
rgb2hsv([1 0 0])
rgb2hsv([0 1 0])
rgb2hsv([0 0 1])

rgb2hsv([0 0.5 0])

rgb2hsv([0.4 0.4 0.4])

rgb2hsv([0 0.5 0] + [0.4 0.4 0.4])

flowers = im2double(imread("flowers4.png"));
whos flowers

hsv = rgb2hsv(flowers);
whos hsv

imshow(hsv(:,:,1))
imshow(hsv(:,:,2))
imshow(hsv(:,:,3))

Lab = rgb2lab(flowers);
whos Lab

imshow(Lab(:,:,2),[])
imshow(Lab(:,:,3),[])
%[text] %[text:anchor:0B57CC9E] ### 10\.2\.8 Transforming between Different Primaries
C = [0.7347 0.2653 0; ...
     0.2738 0.7174 0.0088; ...
     0.1666 0.0089 0.8245]'

J = inv(C)*[0.3127 0.3290 0.3582]' *(1/0.3290)
C*diag(J)

xyzBrick = C*diag(J)*rgbBrick'

chromBrick = tristim2cc(xyzBrick')

colorname(chromBrick,"xy")
%[text] %[text:anchor:B13DC76C] ### 10\.2\.9 What Is White?
d65 = blackbody(lambda,6500);
lambda2xy(lambda,d65)

ee = ones(size(lambda));

lambda2xy(lambda,ee)
%%
%[text] %[text:anchor:9754872C] ## 10\.3 Advanced Topics
%[text] %[text:anchor:7880E1BC] ### 10\.3\.1 Color Temperature
%[text] %[text:anchor:D5BE4EEC] ### 10\.3\.2 Color Constancy
lambda = [400:10:700]*1e-9;
R = loadspectrum(lambda,"redbrick");

sun = loadspectrum(lambda,"solar");

lamp = blackbody(lambda,2600);

xy_sun = lambda2xy(lambda,sun.*R)
xy_lamp = lambda2xy(lambda,lamp.*R)
%[text] %[text:anchor:EB6AE1D1] ### 10\.3\.3 White Balancing
%[text] %[text:anchor:8E5AE9A8] ### 10\.3\.4 Color Change Due to Absorption
[R,lambda] = loadspectrum([400:5:700]*1e-9,"redbrick");

sun = loadspectrum(lambda,"solar");

A = loadspectrum(lambda,"water");

d = 2;

T = 10.^(-d*A);

L = sun.*R.*T;

xy_water = lambda2xy(lambda,L)
%[text] %[text:anchor:F95341CE] ### 10\.3\.5 Dichromatic Reflection
%[text] %[text:anchor:2424F080] ### 10\.3\.6 Gamma
wedge = [0:0.1:1];
imshow(wedge,InitialMagnification=10000)

imshow(wedge.^(1/2.2),InitialMagnification=10000)
%%
%[text] %[text:anchor:941CE391] ## 10\.4 Application: Color Images
%[text] %[text:anchor:DA12143E] ### 10\.4\.1 Comparing Color Spaces
lambda = [400:5:700]*1e-9;
macbeth = loadspectrum(lambda,"macbeth");

d65 = loadspectrum(lambda,"D65")*3e9;

XYZ = []; Lab = [];
for i=1:18
  L = macbeth(:,i).*d65;
  tristim = max(cmfrgb(lambda,L),0);
  RGB = imadjust(tristim,[],[],0.45);       
  XYZ(i,:) = rgb2xyz(RGB); 
  Lab(i,:) = rgb2lab(RGB);
end

xy = XYZ(:,1:2)./(sum(XYZ,2)*[1 1]);
ab = Lab(:,2:3);

showcolorspace(xy,"xy")
showcolorspace(ab,"Lab")
%[text] %[text:anchor:36E61EB1] ### 10\.4\.2 Shadow Removal
im = imread("parks.jpg");
im = rgb2lin(im);
gs = shadowRemoval(im,0.7,"noexp");
imshow(gs,[]) % [] - scale display based on range of pixel values

% Interactive tool. Uncomment to run.
%theta = esttheta(im);
%%
%[text] %[text:anchor:H_41E2F4AF] Suppress syntax warnings in this file
%#ok<*NOANS>
%#ok<*MINV>
%#ok<*NASGU>
%#ok<*NBRAK1>
%#ok<*NBRAK2>
%#ok<*SAGROW>

%[appendix]
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:430bdb37]
%   data: {"dataType":"error","outputData":{"errorType":"runtime","text":"'blackbody' is not found in the current folder or on the MATLAB path, but exists in:\n    C:\\github\\RVC3-MATLAB\\toolbox\n\n<a href = \"matlab:internal.matlab.desktop.commandwindow.executeCommandForUser('cd ''C:\\github\\RVC3-MATLAB\\toolbox''')\">Change the MATLAB current folder<\/a> or <a href = \"matlab:internal.matlab.desktop.commandwindow.executeCommandForUser('addpath ''C:\\github\\RVC3-MATLAB\\toolbox''')\">add its folder to the MATLAB path<\/a>."}}
%---
