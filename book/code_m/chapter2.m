%[text] %[text:anchor:F4CCA683] # Robotics, Vision & Control 3e: for MATLAB
%[text] %[text:anchor:CAAB408D] # Chapter 2: Representing position & orientation
%[text] 
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%[text] Copyright 2022\-2023 Peter Corke, Witold Jachimczyk, Remo Pillat
close all  % close all existing figures
%[text] %[text:anchor:46165D52] ## 2\.2 Working in Two Dimensions (2D)
%[text] %[text:anchor:E35F77C8] ### 2\.2\.1 Orientation in Two Dimensions
%[text] %[text:anchor:3478D1DD] #### 2\.2\.1\.1 2D Rotation Matrix
R = rotm2d(0.3)
plottform2d(R);
det(R)
det(R*R)
syms theta real
R = rotm2d(theta)
simplify(R * R)
det(R)
simplify(ans) 
%%
%[text] %[text:anchor:2311F9DB] #### 2\.2\.1\.2 Matrix Exponential for Rotation
R = rotm2d(0.3);
L = logm(R)
S = skew2vec(L)
X = vec2skew(2)
skew2vec(X)
expm(L)
expm(vec2skew(S))
%%
%[text] %[text:anchor:9CB4BBE7] ### 2\.2\.2 Pose in Two Dimensions
%[text] %[text:anchor:5B2E2C68] #### 2\.2\.2\.1 2D Homogeneous Transformation Matrix
rotm2d(0.3)
tformr2d(0.3)
TA = trvec2tform([1 2])*tformr2d(deg2rad(30))
clf; axis([0 5 0 5]); hold on % new plot with both axes from 0 to 5
plottform2d(TA,frame="A",color="b");
T0 = trvec2tform([0 0]);
plottform2d(T0, frame="0",color="k");  % reference frame
TB = trvec2tform([2 1])
plottform2d(TB,frame="B",color="r");
TAB = TA*TB
plottform2d(TAB,frame="AB",color="g");
TBA = TB*TA;
plottform2d(TBA,frame="BA",color="c");
P = [3;2];  % column vector
plotpoint(P',"ko",label="P");
inv(TA)*[P;1]
h2e(ans')
homtrans(inv(TA),P')
%%
%[text] %[text:anchor:3EC589BF] #### 2\.2\.2\.2 Rotating a Coordinate Frame
clf; axis([-5 4 -1 5]);
T0 = trvec2tform([0 0]);
plottform2d(T0,frame="0",color="k");  % reference frame
TX = trvec2tform([2 3]);
plottform2d(TX,frame="X",color="b");  % frame {X}
TR = tformr2d(2);
plottform2d(TR*TX,framelabel="RX",color="g");
plottform2d(TX*TR,framelabel="XR",color="g");
C = [3 2];
plotpoint(C,"ko",label="C");
TC = trvec2tform(C)*TR*trvec2tform(-C)
plottform2d(TC*TX,framelabel="XC",color="r");
%%
%[text] %[text:anchor:D64999AF] #### 2\.2\.2\.3 Matrix Exponential for Pose
L = logm(TC)
S = skewa2vec(L)
expm(vec2skewa(S))
X = vec2skewa([1 2 3])
skewa2vec(X)
%%
%[text] %[text:anchor:9B0F6F9E] #### 2\.2\.2\.4 2D Twists
S = Twist2d.UnitRevolute(C)
expm(vec2skewa(2*S.compact))
S.tform(2)
S.pole
S = Twist2d.UnitPrismatic([0 1])
S.tform(2)
T = trvec2tform([3 4])*tformr2d(0.5)
S = Twist2d(T)
S.w
S.pole
S.tform()
%%
%[text] %[text:anchor:7F87CE86] ## 2\.3 Working in Three Dimensions (3D)
%[text] %[text:anchor:37FA690E] ### 2\.3\.1 Orientation in Three Dimensions
%[text] %[text:anchor:7F32F7D3] #### 2\.3\.1\.1 3D Rotation Matrix
R = rotmx(pi/2)
clf; plottform(R);
clf; animtform(R)
clf; plottform(R,anaglyph="rc", axis=[-2 2 -2 2 -2 2])
clf; animtform(R,anaglyph="rc", axis=[-2 2 -2 2 -2 2]);
R = rotmx(pi/2)*rotmy(pi/2)
clf; plottform(R)
rotmy(pi/2)*rotmx(pi/2)
%%
%[text] %[text:anchor:F1E19E63] #### 2\.3\.1\.2 Three\-Angle Representations
R = rotmz(0.1)*rotmy(-0.2)*rotmz(0.3)
R = eul2rotm([0.1 -0.2 0.3],"ZYZ")
gamma = rotm2eul(R,"ZYZ")
R = eul2rotm([0.1 0.2 0.3],"ZYZ")
gamma = rotm2eul(R,"ZYZ")
eul2rotm(gamma,"ZYZ")
R = eul2rotm([0.1 0 0.3],"ZYZ")
rotm2eul(R,"ZYZ")
R = eul2rotm([0.3 0.2 0.1],"ZYX")
gamma = rotm2eul(R,"ZYX")
R = eul2rotm([0.3 0.2 0.1],"XYZ")
gamma = rotm2eul(R,"XYZ")
tripleangleApp
%%
%[text] %[text:anchor:97606A7B] #### 2\.3\.1\.4 Two\-Vector Representation
a = [0 0 -1];
o = [1 1 0];
R = oa2rotm(o,a)
%%
%[text] %[text:anchor:AFC85CAF] #### 2\.3\.1\.5 Rotation about an Arbitrary Vector
R = eul2rotm([0.1 0.2 0.3]);
rotm2axang(R)
[x,e] = eig(R)
theta = angle(e(2,2))
R = axang2rotm([1 0 0 0.3])
%%
%[text] %[text:anchor:CF6D20E0] #### 2\.3\.1\.6 Matrix Exponential for Rotation
R = rotmx(0.3)
L = logm(R)
S = skew2vec(L)
expm(L)
expm(vec2skew(S))
R = rotmx(0.3);
R = expm(0.3*vec2skew([1 0 0]));
X = vec2skew([1 2 3])
skew2vec(X)
%%
%[text] %[text:anchor:8F408D03] #### 2\.3\.1\.7 Unit Quaternions
q = quaternion(rotmx(0.3),"rotmat","point")
q = q*q;
q.conj
q*q.conj()
q.rotmat("point")
q.compact()
q.rotatepoint([0 1 0])
%%
%[text] %[text:anchor:554E7765] ### 2\.3\.2 Pose in Three Dimensions
%[text] %[text:anchor:AB0105EB] #### 2\.3\.2\.1 Homogeneous Transformation Matrix
T = trvec2tform([2 0 0])*tformrx(pi/2)*trvec2tform([0 1 0])
clf; plottform(T);
tform2rotm(T)
tform2trvec(T)
%%
%[text] %[text:anchor:7ABC77C2] #### 2\.3\.2\.2 Matrix Exponential for Pose
T = trvec2tform([2 3 4])*tformrx(0.3)
L = logm(T)
S = skewa2vec(L)
expm(vec2skewa(S))
X = vec2skewa([1 2 3 4 5 6])
skewa2vec(X)
%%
%[text] %[text:anchor:D97A652A] #### 2\.3\.3\.3 3D Twists
S = Twist.UnitRevolute([1 0 0],[0 0 0])
expm(0.3*S.skewa());
S.tform(0.3)
S = Twist.UnitRevolute([0 0 1], [2 3 2], 0.5);
X = trvec2tform([3 4 -4]);
clf; hold on
view(3)
for theta = [0:0.3:15]
  plottform(S.tform(theta)*X,style="rgb",labelstyle="none",LineWidth=2)
end
hold off
L = S.line();
L.plot("k:",LineWidth=2);
S = Twist.UnitPrismatic([0 1 0])
S.tform(2)
T = trvec2tform([1 2 3])*eul2tform([0.3 0.4 0.5]);
S = Twist(T)
S.w
S.pole
S.pitch
S.theta
%[text] %[text:anchor:FC8938F5] ## 
%[text] %[text:anchor:4EEDD75E] ## 2\.4 Advanced Topics
%[text] %[text:anchor:D5A40DA2] ### 2\.4\.5 Distance Between Orientations
q1 = quaternion(rotmx(pi/2),"rotmat","point");
q2 = quaternion(rotmz(-pi/2),"rotmat","point");
q1.dist(q2)
%%
%[text] %[text:anchor:E91C23ED] ### 2\.4\.6 Normalization
R = eye(3);
det(R)-1
for i = 1:100
  R = R*eul2rotm([0.2 0.3 0.4]);
end
det(R) - 1
R = tformnorm(R);
det(R)-1
q = q.normalize();
%%
%[text] %[text:anchor:D54132C0] ### 2\.4\.8 More About Twists
S = Twist.UnitRevolute([1 0 0],[0 0 0])
S.compact()
S.v
S.w
S.skewa()
expm(0.3*S.skewa)
S.tform(0.3)
S2 = S*S
S2.printline(mode="axang", unit="rad")
line = S.line()
clf; axis([-2 2 -2 2 -2 2]); view(3); xlabel("x"); ylabel("y"); zlabel("z"); grid on
line.plot("k:",LineWidth=2);
T = trvec2tform([1 2 3])*eul2tform([0.3 0.4 0.5]);
S = Twist(T)
S/S.theta
S.unit();
S.tform(0)
S.tform(1)
S.tform(0.5)
%%
%[text] %[text:anchor:A9017B5B] ## 2\.5 MATLAB Classes for Pose and Rotation
T = trvec2tform([1 2 3])*tformrx(0.3)  % create SE(3) matrix as a MATLAB matrix
whos T
T = se3(rotmx(0.3),[1 2 3])  % create SE(3) matrix as an se3 object
whos T
T.tform()
whos ans
T.rotm()
T.trvec()
clf; plotTransforms(T,FrameLabel="A",FrameColor="b");
clf; plottform(T);
printtform(T);
P = [4 5 6];  % 3D point as a row vector
T.transform(P)
T.transform(P',IsCol=true)
T = rigidtform3d(rotmx(0.3),[1 2 3])  % create SE(3) matrix as a rigidtform3d object
whos T
T.A
T.R
T.Translation
T.transformPointsForward(P)
q = quaternion(rotmx(0.3),"rotmat","point")
conj(q)
q.conj()
q.conj
%[text] %[text:anchor:H_41E2F4AF] Suppress syntax warnings in this file
%#ok<*NOANS>
%#ok<*MINV>
%#ok<*NASGU>
%#ok<*NBRAK2>

%[appendix]
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":24.6}
%---
