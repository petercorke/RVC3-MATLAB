%[text] %[text:anchor:F4CCA683] # Robotics, Vision & Control 3e: for MATLAB
%[text] %[text:anchor:942D7EAD] # Chapter 15: Vision\-based Control
%[text] 
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%[text] 
%[text] Copyright 2022\-2023 Peter Corke, Witold Jachimczyk, Remo Pillat
%[text] %[text:anchor:807FB4CE] ## 
%[text] %[text:anchor:T_874DADDE] ## 15\.1 Position\-Based Visual Servoing
T_C = se3();  % identity pose
cam = CentralCamera("default",pose=T_C);
P = mkgrid(2,0.5);
p = cam.plot(P,objpose=se3(eye(3),[0 0 3]));
p'  % transpose for display
Te_C_G = cam.estpose(P,p);
printtform(Te_C_G)
T_Cd_G = se3(eye(3),[0 0 1]);
T_delta = Te_C_G*T_Cd_G.inv();
lambda=0.05;
T_inc = interp(se3,T_delta,lambda);
printtform(T_inc)
cam.T = cam.T*T_inc;
T_C0 = se3(rotmz(0.6),[1 1 -3]);
T_Cd_G = se3(eye(3),[0 0 1]);
pbvs = PBVS(cam,P=P,pose0=T_C0,posef=T_Cd_G, ...
  axis=[-1 2 -1 2 -3 0.5])
pbvs.run(100);
pbvs.plot_p();
pbvs.plot_vel();
pbvs.plot_camera();
%%
%[text] %[text:anchor:413BA065] ## 15\.2 Image\-Based Visual Servoing
%[text] %[text:anchor:15971AC3] ### 15\.2\.1 Camera and Image Motion
cam = CentralCamera("default");
P = [1 1 5];  % point as a row vector
p0 = cam.project(P)
px = cam.project(P,pose=se3(eye(3),[0.1 0 0]))
(px-p0)/0.1
(cam.project(P,pose=se3(eye(3),[0 0 0.1]))-p0)/0.1
(cam.project(P,pose=se3(rotmx(0.1)))-p0)/0.1
J = cam.visjac_p([672 672],5) %#ok<*NASGU>
cam.flowfield([0 0 0 1 0 0]);
cam.flowfield([0 0 0 0 0 1]);
cam.flowfield([0 0 1 0 0 0]);
cam.flowfield([0 1 0 0 0 0]);
cam.visjac_p(cam.pp,1)
cam.f = 20e-3;
cam.flowfield([0 1 0 0 0 0]);
cam.f = 4e-3;
cam.flowfield([0 1 0 0 0 0]);
J = cam.visjac_p(cam.pp,1);
null(J)
%%
%[text] %[text:anchor:D38D0D67] ### 15\.2\.2 Controlling Feature Motion
T_C = se3();  % identity pose
cam = CentralCamera("default");
P = mkgrid(2,0.5,pose=se3(eye(3),[0 0 3]));
pd = 200*[-1 -1;-1 1;1 1;1 -1] + cam.pp;
p = cam.plot(P,pose=T_C);
e = pd-p;
J = cam.visjac_p(p,1);
lambda = 0.05;
v = lambda*pinv(J)*reshape(e',[],1);
v'  % transpose for display
cam.T = cam.T*delta2se(v);
T_C0 = se3(rotmz(0.6),[1 1 -3]);
camera = CentralCamera("default",pose=T_C0);
ibvs = IBVS(camera,P=P,p_d=pd);
ibvs.run(25);
ibvs.plot_p();
ibvs.plot_vel();
ibvs.plot_camera();
ibvs.plot_jcond();
%%
%[text] %[text:anchor:53B64761] ### 15\.2\.3 Estimating Feature Depth
ibvs = IBVS(cam,pose0=T_C0,p_d=pd,depth=1)
ibvs.run(60)
ibvs = IBVS(cam,pose0=T_C0,p_d=pd,depth=10)
ibvs.run(20)
ibvs = IBVS(cam,pose0=T_C0,p_d=pd,depthest=true);
ibvs.run()
ibvs.plot_z();
ibvs.plot_p();
%%
%[text] %[text:anchor:BD5EE307] ### 15\.2\.4 Performance Issues
pbvs.T0 = se3(rotmz(5*pi/4),[-2.1 0 -3]);
pbvs.run()

% Long-running algorithm. Uncomment to run IBVS.
%ibvs = IBVS(cam,pose0=pbvs.T0,p_d=pd,lambda=0.002, ...
%  niter=Inf,eterm=0.5)
%ibvs.run()
%ibvs.plot_p();

ibvs = IBVS(cam,pose0=se3(rotmz(1),[0 0 -1]),p_d=pd);
ibvs.run()
ibvs.plot_camera
ibvs = IBVS(cam,pose0=se3(rotmz(pi),[0 0 -1]), ...
  p_d=pd, niter=10);
ibvs.run()
ibvs.plot_camera
%[text] 
%[text] Suppress syntax warnings in this file
%#ok<*NASGU>

%[appendix]
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
