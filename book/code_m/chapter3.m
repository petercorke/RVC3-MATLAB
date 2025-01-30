%[text] %[text:anchor:F4CCA683] # Robotics, Vision & Control 3e: for MATLAB
%[text] %[text:anchor:CAAB408D] # Chapter 3: Time and Motion
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%[text] Copyright 2022\-2023 Peter Corke, Witold Jachimczyk, Remo Pillat
close all % close all existing figures
%[text] %[text:anchor:04C4B8E1] ## 3\.1 Time\-Varying Pose
%[text] %[text:anchor:5074EA63] ### 3\.1\.3 Transforming Spatial Velocities
aTb = se3(eul2rotm([-pi/2 0 pi/2]),[-2 0 0]);
bV = [1 2 3 4 5 6]';
aJb = velxform(aTb);
size(aJb)
aV = aJb*bV;
aV'  % transpose for display
aV = adjoint(aTb)*[0 0 0 1 2 3]';
aV'  % transpose for display
aV = adjoint(aTb)*[1 0 0 0 0 0]';
aV'  % transpose for display
aV = adjoint(aTb)*[1 0 0 1 2 3]';
aV'  % transpose for display
%%
%[text] %[text:anchor:9DD9A326] ### 3\.1\.4 Incremental Rotation
rotmx(0.001)
Rexact = eye(3); Rapprox = eye(3);  % null rotation
w = [1 0 0]';   % rotation of 1rad/s about x-axis
dt = 0.01;      % time step
tic
for i = 1:100     % exact integration over 100 time steps
  Rexact = Rexact*expm(vec2skew(w*dt));       % update by composition
end
toc  % display the execution time
tic
for i = 1:100     % approximate integration over 100 time steps
  Rapprox = Rapprox + Rapprox*vec2skew(w*dt); % update by addition
end
toc  % display the execution time
det(Rapprox)-1
det(Rexact)-1
rotm2axang(tformnorm(Rexact))
rotm2axang(tformnorm(Rapprox))
%%
%[text] %[text:anchor:F4B8A7FD] ## 3\.2 Accelerating Bodies and Reference Frames
%[text] %[text:anchor:437CDB9C] ### 3\.2\.1 Dynamics of Moving Bodies
J = [2 -1 0; -1 4 0; 0 0 3];
orientation = quaternion([1 0 0 0]); % null rotation
w = 0.2*[1 2 2]';  % initial angular velocity
dt = 0.05;  % time step
h = plottform(se3);  % create coordinate frame and return handle
for t = 0:dt:10
  wd = -inv(J)*(cross(w,J*w)); % angular acceleration by (3.12)
  w = w + wd*dt;
  orientation = orientation*quaternion(w'*dt,"rotvec"); % update orientation
  plottform(orientation,handle=h)  % update displayed coordinate frame
  pause(dt) 
end
%%
%[text] %[text:anchor:56A0C24E] ### 3\.2\.2 Transforming Forces and Torques
bW = [0 0 0 1 2 3]';
aW = adjoint(inv(aTb))'*bW;
aW'  % transpose for display
%%
%[text] %[text:anchor:ECD9039A] ## 3\.3 Creating Time\-Varying Pose
%[text] %[text:anchor:6460550F] ### 3\.3\.1 Smooth One\-Dimensional Trajectories
t = linspace(0,1,50); % 0 to 1 in 50 steps
[q,qd,qdd] = quinticpolytraj([0 1],[0 1],t);
clf; stackedplot(t,[q' qd' qdd'])
[q2,qd2,qdd2] = quinticpolytraj([0 1],[0 1],t, ...
  VelocityBoundaryCondition=[10 0]);
mean(qd)/max(qd)
[q,qd,qdd] = trapveltraj([0 1],50);
stackedplot(t,[q' qd' qdd'])
max(qd)
[q2,qd2,qdd2] = trapveltraj([0 1],50,EndTime=1,PeakVelocity=1.2);
[q3,qd3,qdd3] = trapveltraj([0 1],50,EndTime=1,PeakVelocity=2);
%%
%[text] %[text:anchor:F32260CB] ### 3\.3\.2 Multi\-Axis Trajectories
q0 = [0 2]; qf = [1 -1];
q = trapveltraj([q0' qf'],50,EndTime=1);
plot(q')
%%
%[text] %[text:anchor:26D6C585] ### 3\.3\.3 Multi\-Segment Trajectories
cornerPoints = [-1 1; 1 1; 1 -1; -1 -1; -1 1];
R = so2(rotm2d(deg2rad(30)));
via = R.transform(cornerPoints)';
[q,qd,qdd,t] = trapveltraj(via,100,EndTime=5);
plot(q(1,:),q(2,:),"b.-")
plot(q(1,:))
q2 = trapveltraj(via,100,EndTime=5,AccelTime=0.5);
plot(q2(1,:),q2(2,:),"r.-")
plot(q2(1,:))
[q,qd,qdd] = minjerkpolytraj(via,[1 2 3 4 5],500);
plot(q(1,:),q(2,:),".-")
vel_lim = [-1 1; -1 1]; accel_lim= [-2 2; -2 2];
[q,qd,qdd] = contopptraj(via,vel_lim,accel_lim,numsamples=100);
plot(q(1,:),q(2,:),".-")
%%
%[text] %[text:anchor:94A25735] ### 3\.3\.4 Interpolation of Orientation in 3D
rpy0 = [-1 -1 0]; rpy1 = [1 1 0];
rpy = quinticpolytraj([rpy0' rpy1'],[0 1],linspace(0,1,50));
animtform(so3(eul2rotm(rpy')))
q0 = quaternion(eul2rotm(rpy0),"rotmat","point");
q1 = quaternion(eul2rotm(rpy1),"rotmat","point");
q = q0.slerp(q1,linspace(0,1,50));
whos q
animtform(q)
tpts = [0 5]; tvec = [0:0.01:5];
[q,w,a] = rottraj(q0,q1,tpts,tvec);
[s,sd,sdd] = minjerkpolytraj([0 1],tpts,numel(tvec));
[q,w,a] = rottraj(q0,q1,tpts,tvec,TimeScaling=[s;sd;sdd]);
%%
%[text] %[text:anchor:94BB096E] #### 3\.3\.4\.1 Direction of Rotation
q1 = quaternion(rotmz(-2),"rotmat","point");
q2 = quaternion(rotmz(1),"rotmat","point");
animtform(q1.slerp(q2,linspace(0,1,50)))
q2 = quaternion(rotmz(2),"rotmat","point");
animtform(q1.slerp(q2,linspace(0,1,50)))
%%
%[text] %[text:anchor:821E2DA4] ### 3\.3\.5 Cartesian Motion in 3D
T0 = se3(eul2rotm([1.5 0 0]),[0.4 0.2 0]);
T1 = se3(eul2rotm([-pi/2 0 -pi/2]),[-0.4 -0.2 0.3]);
T0.interp(T1,0.5)
tpts = [0 1]; tvec = linspace(tpts(1),tpts(2),50);
%23A only: Ts = transformtraj(T0,T1,tpts,tvec);
% whos Ts
% animtform(Ts)
% Ts(251)
% P = Ts.trvec();
% size(P)
% plot(P);
% plot(rotm2eul(Ts.rotm()));
% Ts = transformtraj(T0,T1,tpts,trapveltraj(tpts,50));
%%
%[text] %[text:anchor:98E98998] ## 3\.4 Application: Inertial Navigation
%[text] %[text:anchor:0EF119C3] ### 3\.4\.1 Gyroscopes
%[text] %[text:anchor:2594DBF1] #### 3\.4\.1\.2 Estimating Orientation
TrueMotion = imudata();
orientation(1) = quaternion([1 0 0 0]);  % identity quaternion
for k = 1:size(TrueMotion.omega,1)-1
  orientation(k+1) = orientation(k)* ...
    quaternion(TrueMotion.omega(k,:)*TrueMotion.dt,"rotvec");
end
whos orientation
animtform(orientation)
clf; stackedplot(orientation.euler("zyx","point"))
%[text] %[text:anchor:67A38B18] ### 
%[text] %[text:anchor:576C81E0] ### 3\.4\.4 Inertial Sensor Fusion
[TrueMotion,IMU] = imudata();
orientation(1) = quaternion([1 0 0 0]);  % identity quaternion
for k = 1:size(IMU.gyro,1)-1
  orientation(k+1) = orientation(k)*quaternion(IMU.gyro(k,:)*IMU.dt,"rotvec");
end
plot(IMU.t,dist(orientation,TrueMotion.orientation),"r");
kI = 0.2; kP = 1;
bias = zeros(size(IMU.gyro,1),3);
orientation_ECF(1) = quaternion([1 0 0 0]);
for k = 1:size(IMU.gyro,1)-1
  invq = conj(orientation_ECF(k));  % unit quaternion inverse
  sigmaR = cross(IMU.accel(k,:),invq.rotatepoint(TrueMotion.g0))+ ...
           cross(IMU.magno(k,:),invq.rotatepoint(TrueMotion.B0));
  wp = IMU.gyro(k,:) - bias(k,:) + kP*sigmaR;
  orientation_ECF(k+1) = orientation_ECF(k)*quaternion(wp*IMU.dt,"rotvec");
  bias(k+1,:) = bias(k,:) - kI*sigmaR*IMU.dt;
end
plot(TrueMotion.t,dist(orientation_ECF,TrueMotion.orientation),"b");
%[text] %[text:anchor:31E8ECD9] ##  
%[text] %[text:anchor:H_41E2F4AF] Suppress syntax warnings in this file
%#ok<*ASGLU> %[text:anchor:H_E28672F7]
%#ok<*NBRAK2>
%#ok<*SAGROW>

%[appendix]
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":9.6}
%---
