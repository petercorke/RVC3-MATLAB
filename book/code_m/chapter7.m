%[text] %[text:anchor:F4CCA683] # Robotics, Vision & Control 3e: for MATLAB
%[text] %[text:anchor:CAAB408D] # Chapter 7: Robot Arm Kinematics 
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%[text] Copyright 2022\-2023 Peter Corke, Witold Jachimczyk, Remo Pillat
close all      % close all figures
clear          % clear all workspace variables
format compact % compact printout  
%[text] %[text:anchor:72A4C8A9] ## 7\.1 Forward Kinematics
%[text] %[text:anchor:787DCB10] ### 7\.1\.1 Forward Kinematics from a Pose Graph
%[text] %[text:anchor:C74A4BF1] #### 7\.1\.1\.1 2\-Dimensional (Planar) Robotic Arms
a1 = 1;
e = ETS2.Rz("q1")*ETS2.Tx(a1)
size(e)
e.fkine(pi/6)
se2(pi/6,"theta")*se2(eye(2),[a1 0])
e.teach;
a1 = 1; a2 = 1;
e = ETS2.Rz("q1")*ETS2.Tx(a1)*ETS2.Rz("q2")*ETS2.Tx(a2)
T = e.fkine(deg2rad([30 40]));
printtform2d(se2(T),unit="deg")
T = se2(deg2rad(30),"theta")*se2(eye(2),[a1 0]) * ...
  se2(deg2rad(40),"theta")*se2(eye(2),[a2 0]);
printtform2d(T,unit="deg")
e.njoints
e.structure
e.plot(deg2rad([30 40]));
etx = e(2)
etx.param
etx.T
e = ETS2.Rz("q1")*ETS2.Tx("q2",qlim=[1 2])
e.structure
%%
%[text] %[text:anchor:B1A18353] #### 7\.1\.1\.2 3\-Dimensional Robotic Arms
a1 = 1; a2 = 1;
e = ETS3.Rz("q1")*ETS3.Ry("q2")* ...
  ETS3.Tz(a1)*ETS3.Ry("q3")*ETS3.Tz(a2)* ...
  ETS3.Rz("q4")*ETS3.Ry("q5")*ETS3.Rz("q6");
e.njoints
e.structure
e.fkine(zeros(1,6))
e.teach;
%%
%[text] %[text:anchor:E4B17F5C] ### 7\.1\.2 Forward Kinematics as a Chain of Robot Links
%[text] %[text:anchor:01B2E004] #### 7\.1\.2\.2 2\-Dimensional (Planar) Case
link1 = rigidBody("link1");
link1.Joint = rigidBodyJoint("joint1","revolute");
link2 = rigidBody("link2");
link2.Joint = rigidBodyJoint("joint2","revolute");
link2.Joint.setFixedTransform(se3([a1 0 0],"trvec"));
link3 = rigidBody("link3");
link3.Joint.setFixedTransform(se3([a2 0 0],"trvec"));
myRobot = rigidBodyTree(DataFormat="row");
myRobot.addBody(link1,myRobot.BaseName);
myRobot.addBody(link2,link1.Name);
myRobot.addBody(link3,link2.Name);
myRobot.homeConfiguration
myRobot.showdetails
T = myRobot.getTransform(deg2rad([30 40]),"link3");
printtform(T,unit="deg")
figure; % Create new figure
myRobot.show(deg2rad([30 40]));
view(0,90)   % show only XY (2D) plane
q = [linspace(0,pi,100)' linspace(0,-2*pi,100)'];
whos q
r = rateControl(10);
for i = 1:size(q,1)
  myRobot.show(q(i,:),FastUpdate=true,PreservePlot=false);
  r.waitfor;
end
link2 = myRobot.Bodies{2} 
link2 = myRobot.getBody("link2");
parentLink = link2.Parent;
childLinks = link2.Children;
link2.Joint.Type
link2.Joint.PositionLimits
myRobot.getTransform(deg2rad([0 30]),"link2","link1")
%%
%[text] %[text:anchor:84F4CD14] #### 7\.1\.2\.3 3\-Dimensional Case
a1 = 1; a2 = 1;
robot6 = ets2rbt(ETS3.Rz("q1")*ETS3.Ry("q2")* ...
  ETS3.Tz(a1)*ETS3.Ry("q3")*ETS3.Tz(a2)* ...
  ETS3.Rz("q4")*ETS3.Ry("q5")*ETS3.Rz("q6"));
robot6.homeConfiguration
%loadrobot("<TAB>
panda = loadrobot("frankaEmikaPanda",DataFormat="row");
panda.showdetails
qr = [0 -0.3 0 -2.2 0 2 0.7854 0 0];
T = panda.getTransform(qr,"panda_hand");
printtform(T,unit="deg")
figure; % Create new figure
panda.show(qr);
intPanda = interactiveRigidBodyTree(panda,Configuration=qr);
intPanda.Configuration'  % transpose for display
intPanda.addConfiguration;      % store configuration
intPanda.StoredConfigurations;  % retrieve stored trajectory
%%
%[text] %[text:anchor:44997FA3] ### 7\.1\.3 Branched Robots
atlas = loadrobot("atlas",DataFormat="row");
figure; % Create new figure
atlas.show;
childLinks = atlas.getBody("utorso").Children';
size(childLinks)
cellfun(@(c) string(c.Name),childLinks)
rightArm = atlas.subtree("r_clav");
rightArm.show;
intAtlas = interactiveRigidBodyTree(atlas);
atlas.getTransform(atlas.homeConfiguration,"l_foot");
T = atlas.getTransform(atlas.homeConfiguration,"r_hand_force_torque","r_clav");
printtform(T,unit="deg")
%%
%[text] %[text:anchor:D2DAD98E] ### 7\.1\.4 Unified Robot Description Format (URDF)
sawyer = importrobot("sawyer.urdf");
figure; % Create new figure
sawyer.show;
figure; % Create new figure for collision meshes
sawyer.show(Visuals="off",Collisions="on");
sawyer.getBody("head")
%%
%[text] %[text:anchor:E4EC949C] ### 7\.1\.5 Denavit\-Hartenberg Parameters
a = 1; alpha = 0; d = 0; theta = 0;
link = rigidBody("link1");
link.Joint = rigidBodyJoint("joint1","revolute");
link.Joint.setFixedTransform([a alpha d theta],"dh");
%%
%[text] %[text:anchor:17BAFB7A] ## 7\.2 Inverse Kinematics
%[text] %[text:anchor:86A0E082] ### 7\.2\.1 2\-Dimensional (Planar) Robotic Arms
%[text] %[text:anchor:59564502] #### 7\.2\.1\.1 Closed\-Form Solution
syms a1 a2 real
e = ETS2.Rz("q1")*ETS2.Tx(a1)*ETS2.Rz("q2")*ETS2.Tx(a2);
syms q1 q2 real
TE = e.fkine([q1 q2])
transl = TE(1:2,3)';
syms x y real
e1 = x == transl(1)
e2 = y == transl(2)
[s1,s2] = solve([e1 e2],[q1 q2]);
length(s2)
subs(s2(2),[a1 a2],[1 1])
xfk = eval(subs(transl(1), [a1 a2 q1 q2], ...
  [1 1 deg2rad(30) deg2rad(40)]))
yfk = eval(subs(transl(2), [a1 a2 q1 q2], ...
  [1 1 deg2rad(30) deg2rad(40)]))
q1r = eval(subs(s1(2),[a1 a2 x y],[1 1 xfk yfk]));
q1 = rad2deg(q1r)
q2r = eval(subs(s2(2),[a1 a2 x y],[1 1 xfk yfk]));
q2 = rad2deg(q2r)
%%
%[text] %[text:anchor:04005C1A] #### 7\.2\.1\.2 Numerical Solution
e = ETS2.Rz("q1")*ETS2.Tx(1)*ETS2.Rz("q2")*ETS2.Tx(1);
pstar = [0.6 0.7];  % Desired position
q = fminsearch(@(q) norm(se2(e.fkine(q)).trvec-pstar),[0 0])
printtform2d(e.fkine(q),unit="deg")
%%
%[text] %[text:anchor:703716A7] ### 7\.2\.2 3\-Dimensional Robotic Arms
%[text] %[text:anchor:B41EF578] #### 7\.2\.2\.1 Closed\-Form Solution
abb = loadrobot("abbIrb1600",DataFormat="row");
figure % Create new figure for robot
abb.show;
abb.showdetails
aIK = analyticalInverseKinematics(abb);
aIK.showdetails
abb.getBody("tool0").Joint.Type
T = abb.getBody("tool0").Joint.JointToParentTransform;
printtform(T)
abbIKFcn = aIK.generateIKFunction("ikIRB1600")
% To find 2 possible target configurations
tgtPose = trvec2tform([0.93 0 0.5])*eul2tform([0 pi/2 0]);
qsol = abbIKFcn(tgtPose)
qn = qsol(1,:);
abb.show(qn);
T1 = abb.getTransform(qsol(1,:),"tool0");
printtform(T1)
T2 = abb.getTransform(qsol(2,:),"tool0");
printtform(T2)
% To find all possible target configurations, disable joint limits
% Interesting configurations: 2, 3, 4, 6
qsol = abbIKFcn(tgtPose,false)
abbIKFcn(trvec2tform([3,0,0]))
q = [0 pi/4 0 0.1 0 0.4];
qsol = abbIKFcn(abb.getTransform(q,"tool0"))
pr2 = loadrobot("willowgaragePR2",DataFormat="row");
aIK2 = analyticalInverseKinematics(pr2);
aIK2.showdetails
% openExample("robotics/SolveAnalyticalIKForLargeDOFRobotExample")
%%
%[text] %[text:anchor:3D383A98] #### 7\.2\.2\.2 Numerical Solution
abbHome = abb.homeConfiguration;
T = abb.getTransform(qn,"tool0");
printtform(T)
abbIK = inverseKinematics(RigidBodyTree=abb);
[qsol,solinfo] = abbIK("tool0",T,ones(1,6),abbHome) 
qn
T2 = abb.getTransform(qsol,"tool0");
printtform(T2)
qsol = abbIK("tool0",T,ones(1,6),[0 0 0 pi 0 0])
tNumericalIK = timeit(@() abbIK("tool0",T,ones(1,6),abbHome))
tAnalyticalIK = timeit(@() abbIKFcn(T))
tNumericalIK / tAnalyticalIK
%%
%[text] %[text:anchor:E8493AA8] ### 7\.2\.3 Underactuated Manipulator
cobra = loadrvcrobot("cobra");
TE = se3(deg2rad([170 0 30]),"eul","XYZ",[0.4 -0.3 0.2]);
cobraHome = cobra.homeConfiguration;
cobraIK = inverseKinematics(RigidBodyTree=cobra);
weights = ones(1,6); 
rng(0); % obtain repeatable results
[qsol,solinfo] = cobraIK("link4",TE.tform,weights,cobraHome)
weights = [0 0 1 1 1 1];
[qsol,solinfo] = cobraIK("link4",TE.tform,weights,cobraHome)
T4 = cobra.getTransform(qsol,"link4");
printtform(T4,unit="deg",mode="xyz")
plotTransforms(TE,FrameColor="red"); hold on
plotTransforms(se3(T4),FrameColor="blue")
%%
%[text] %[text:anchor:9BC26136] ### 7\.2\.4 Overactuated (Redundant) Manipulator
panda = loadrobot("frankaEmikaPanda",DataFormat="row");
TE = se3(trvec2tform([0.7 0.2 0.1]))* ...
  se3(oa2tform([0 1 0],[0 0 -1]));
pandaHome = panda.homeConfiguration;
pandaIK = inverseKinematics(RigidBodyTree=panda); 
rng(0); % obtain repeatable results
qsol = pandaIK("panda_hand",TE.tform,ones(1,6),pandaHome)
handT = panda.getTransform(qsol,"panda_hand");
printtform(handT,mode="axang",unit="deg")
figure; % Create new figure
panda.show(qsol);
%%
%[text] %[text:anchor:8F9E360E] ## 7\.3 Trajectories
%[text] %[text:anchor:F35B2EF9] ### 7\.3\.1 Joint\-Space Motion
TE1 = se3(3,"rotx",[0.6 -0.5 0.1]);
TE2 = se3(2,"rotx",[0.4 0.5 0.1]);
sol1 = abbIKFcn(TE1.tform);
sol2 = abbIKFcn(TE2.tform);
waypts = [sol1(1,:)' sol2(1,:)'];
t = 0:0.02:2;
[q,qd,qdd] = quinticpolytraj(waypts,[0 2],t);
[q,qd,qdd] = trapveltraj(waypts,numel(t),EndTime=2);
r = rateControl(50);
for i = 1:size(q,2)
  abb.show(q(:,i)',FastUpdate=true,PreservePlot=false);
  r.waitfor;
end
figure; % Create figure for joint plots
xplot(t,q')
for i = 1:size(q,2)
  trajT(i) = se3(abb.getTransform(q(:,i)',"tool0")); 
end
size(trajT)
p = trajT.trvec;
size(p)
figure; % Create figure
plot(t,p);
legend("x","y","z")
figure; % Create figure
plot(t,trajT.eul("XYZ"))
legend("roll","pitch","yaw")
%%
%[text] %[text:anchor:61A0677E] ### 7\.3\.2 Cartesian Motion
T = transformtraj(TE1,TE2,[0 2],t);
[s,sd,sdd] = minjerkpolytraj([0 1],[0 2],numel(t));
Ts = transformtraj(TE1,TE2,[0 2],t, ...
  TimeScaling=[s;sd;sdd]);
figure;
plot(t,Ts.trvec);
legend("x","y","z")
figure;
plot(t,Ts.eul("XYZ"));
legend("roll","pitch","yaw")
qj = ikineTraj(abbIKFcn,Ts);
% openExample("robotics/" + ...
%  "ChooseATrajectoryForAManipulatorApplicationExample");
%%
%[text] %[text:anchor:02D78E73] ### 7\.3\.3 Kinematics in Simulink
sl_jointspace
figure;
%%
%[text] %[text:anchor:1C0252DC] ### 7\.3\.4 Motion Through a Singularity
qsing = [0 pi/4 0 0.1 0 0.4];
TG = se3(abb.getTransform(qsing,"tool0"));
TE1 = se3(trvec2tform([0 -0.3 0]))*TG;
TE2 = se3(trvec2tform([0 0.3 0]))*TG;
Ts = transformtraj(TE1,TE2,[0 2],t, ...
  TimeScaling=[s;sd;sdd]);
qj = ikineTraj(abbIKFcn,Ts);
figure;
xplot(t,qj,unwrap=true)
qj_num = ikineTrajNum(abb,Ts);
m = manipulability(abb,qj);
%%
%[text] %[text:anchor:013F1E2E] ## 7\.4 Applications
%[text] %[text:anchor:A19029CB] ### 7\.4\.1 Writing on a Surface
load hershey
B = hershey{'B'}
B.stroke
p = [0.5*B.stroke; zeros(1,size(B.stroke,2))];
k = find(isnan(p(1,:)));
p(:,k) = p(:,k-1); p(3,k) = 0.2;
dt = 0.02;  % sample interval
traj = mstraj(p(:,2:end)',[0.5 0.5 0.5],[],p(:,1)',dt,0.2);
whos traj
size(traj,1)*dt
plot3(traj(:,1),traj(:,2),traj(:,3))
Tp = se3(trvec2tform([0.5 0 0.075]))*se3(eye(3),traj)* ...
  se3(oa2tform([0 1 0],[0 0 -1]));
qj = ikineTraj(abbIKFcn,Tp);
figure;
r = rateControl(1/dt);
for i = 1:size(qj,1)
  abb.show(qj(i,:),FastUpdate=true,PreservePlot=false);
  r.waitfor;
end
%%
%[text] %[text:anchor:96FC3B36] ### 7\.4\.2 A 4\-Legged Walking Robot
L1 = 0.5;
L2 = 0.5;
e = ETS3.Rz("q1")*ETS3.Rx("q2")*ETS3.Ty(-L1)* ...
  ETS3.Rx("q3")*ETS3.Tz(-L2);
leg = ets2rbt(e);
se3(leg.getTransform([0 0 0],"link5")).trvec
figure;
leg.show;
%%
%[text] %[text:anchor:29A73E97] #### 7\.4\.2\.1 Motion of One Leg
xf = 0.25; xb = -xf;  y = -0.25; zu = -0.1; zd = -0.25;
via = [xf y zd
       xb y zd
       xb y zu
       xf y zu
       xf y zd];
x = mstraj(via,[],[3 0.25 0.5 0.25],[],0.01,0.1);
qcycle = ikineTrajNum(leg,se3(eye(3),x),"link5", ...
  weights=[0 0 0 1 1 1]);
r = rateControl(50);
for i = 1:size(qcycle,1)
  leg.show(qcycle(i,:),FastUpdate=true,PreservePlot=false);
  r.waitfor;
end
%%
%[text] %[text:anchor:4B0FEA87] #### 7\.4\.2\.2 Motion of Four Legs
W = 0.5; L = 1;
Tflip = se3(pi,"rotz");
legs = [ ...
  rbtTform(leg,se3(eye(3),[L/2 W/2 0])*Tflip), ...
  rbtTform(leg,se3(eye(3),[-L/2 W/2 0])*Tflip), ...
  rbtTform(leg,se3(eye(3),[L/2 -W/2 0])), ...
  rbtTform(leg,se3(eye(3),[-L/2 -W/2 0]))];
r = rateControl(50);
for i = 1:500
  legs(1).show(gait(qcycle,i,0,false)); hold on;
  legs(2).show(gait(qcycle,i,100,false));
  legs(3).show(gait(qcycle,i,200,true));
  legs(4).show(gait(qcycle,i,300,true)); hold off;
  r.waitfor;
end
% This function is shown in the book section, but it is not executable here.
%function q = gait(cycle, k, phi, flip)
%  k = mod(k+phi-1,size(cycle,1))+1;
%  q = cycle(k,:);
%  if flip
%    q(1) = -q(1);   % for left-side legs
% end
%%
%[text] %[text:anchor:FEF56B3B] ## 7\.5 Advanced Topics
%[text] %[text:anchor:7E96CDC0] ### 7\.5\.1 Creating the Kinematic Model for a Robot
L1 = 0.672; L2 = -0.2337; L3 = 0.4318;
L4 = 0.0203; L5 = 0.0837; L6 = 0.4318;
e = ETS3.Tz(L1)*ETS3.Rz("q1")*ETS3.Ty(L2)*ETS3.Ry("q2") ...
   *ETS3.Tz(L3)*ETS3.Tx(L4)*ETS3.Ty(L5)*ETS3.Ry("q3") ...
   *ETS3.Tz(L6)*ETS3.Rz("q4")*ETS3.Ry("q5")*ETS3.Rz("q6");
robot = ets2rbt(e);
%%
%[text] %[text:anchor:C486BD5E] ### 7\.5\.2 Modified Denavit\-Hartenberg Parameters
a = 1; alpha = 0; d = 0; theta = 0;
link = rigidBody("link1");
link.Joint = rigidBodyJoint("joint1","revolute");
link.Joint.setFixedTransform([a alpha d theta],"mdh");
%%
%[text] %[text:anchor:9528C428] ### 7\.5\.3 Products of Exponentials
a1 = 1; a2 = 1;
TE0 = se2(eye(2),[a1+a2 0]);
S0 = Twist2d.UnitRevolute([0 0]);
S1 = Twist2d.UnitRevolute([a1 0]);
TE = S0.exp(deg2rad(30))*S1.exp(deg2rad(40))*TE0
%%
%[text] %[text:anchor:16D211F5] ### 7\.5\.4 Collision Checking
panda = loadrobot("frankaEmikaPanda",DataFormat="row");
qp = [0 -0.3 0 -2.2 0 2 0.7854 0, 0];
figure;
panda.show(qp,Visuals="off",Collisions="on",Frames="off");
box = collisionBox(1,1,1);
box.Pose = se3([1.1 -0.5 0],"trvec");
panda.checkCollision(qp,{box},IgnoreSelfCollision="on")
box.Pose = se3([1.0 -0.5 0],"trvec");
hold on; box.show
panda.checkCollision(qp,{box},IgnoreSelfCollision="on")
vehicleMesh = stlread("groundvehicle.stl");
vehicle = collisionMesh(vehicleMesh.Points/100);
vehicle.Pose = se3([0.5 0 0],"trvec");
[isColl,sepDist,witPts] = panda.checkCollision(qp,{vehicle}, ...
   IgnoreSelfCollision="on")
%[text] 
%[text] Suppress syntax warnings in this file
%#ok<*NASGU>
%#ok<*ASGLU>
%#ok<*SAGROW>

%[appendix]
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
