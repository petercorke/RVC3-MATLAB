%% RVC3: Chapter 9 (Dynamics and Control)
format compact
bdclose all
close all
clear
clc


%% 9.1 Independent Joint Control
%% 9.1.6 Velocity Control Loop
sl_vloop_test
sim("sl_vloop_test");

%% 9.1.7 Position Control Loop
sl_ploop_test
sim("sl_ploop_test");


%% 9.2 Rigid-Body Equations of Motion
[puma,conf] = loadrvcrobot("puma");
qz = zeros(1,6);
Q = puma.inverseDynamics(conf.qn,qz,qz)

pumaZeroG = puma.copy;
pumaZeroG.Gravity = [0 0 0];

Q = pumaZeroG.inverseDynamics(conf.qn,qz,qz)

t = linspace(0,1,10);
[q,qd,qdd] = quinticpolytraj([qz;conf.qr]',[0 1],t);
for i = 1:10
  Q(i,:) = puma.inverseDynamics(q(:,i)',qd(:,i)',qdd(:,i)'); 
end

size(Q)

Q(5,:)

pumaZeroG.inverseDynamics(conf.qn,[1 0 0 0 0 0],qz)

puma.Bodies{2}

%% 9.2.1 Gravity Term
g = puma.gravityTorque(conf.qn)
puma.Gravity

puma.Gravity = puma.Gravity/6;
g = puma.gravityTorque(conf.qn)
puma.Gravity = [0 0 -9.81];

g = puma.gravityTorque(conf.qs)
g = puma.gravityTorque(conf.qr)

[Q2,Q3] = meshgrid(-pi:0.1:pi,-pi:0.1:pi);
for i=1:size(Q2,2)
    for j=1:size(Q3,2)
      g = puma.gravityTorque([0 Q2(i,j) Q3(i,j) 0 0 0]);
      g2(i,j) = g(2);   % Shoulder gravity load
      g3(i,j) = g(3);   % Elbow gravity load
    end
end
surfl(Q2, Q3, g2);
figure;
surfl (Q2, Q3, g3);

%% 9.2.2 Inertia (Mass) Matrix
M = puma.massMatrix(conf.qn)

[Q2,Q3] = meshgrid(-pi:0.1:pi,-pi:0.1:pi);
for i = 1:size(Q2,2)
  for j = 1:size(Q3,2)
    M = puma.massMatrix([0 Q2(i,j) Q3(i,j) 0 0 0]);
    m11(i,j) = M(1,1);
    m12(i,j) = M(1,2);
    m22(i,j) = M(2,2);
  end
end
surfl (Q2, Q3, m11); figure; surfl (Q2, Q3, m12);

max(m11(:))/min(m11(:))

%% 9.2.3 Coriolis and Centripetal Matrix
qd = [0 0 1 0 0 0];
C = coriolisMatrix(puma,conf.qn,qd)
puma.velocityProduct(conf.qn,qd)

%% 9.2.4 Effect of Payload
g = puma.gravityTorque(conf.qn);
M = puma.massMatrix(conf.qn);

puma.getBody("link6").Mass = 2.5;
puma.getBody("link6").CenterOfMass = [0 0 0.1];

M_loaded = puma.massMatrix(conf.qn);
M(M < 1e-6) = nan;
M_loaded./M

g(g < 1e-6) = nan;
puma.gravityTorque(conf.qn)./g

puma.getBody("link6").Mass = 0;


%% 9.2.5 Base Wrench
sum(cellfun(@(b) b.Mass, puma.Bodies))*puma.Gravity(3)

puma.centerOfMass(conf.qn)

%% 9.2.6 Dynamic Manipulability
J = puma.geometricJacobian(conf.qn,"link6");
Jt = J(4:6,:);  % last 3 rows

M = puma.massMatrix(conf.qn);
E = Jt*inv(M)*inv(M)'*Jt';
plotellipsoid(E)

radii = sqrt(eig(E))'  % transpose for display
min(radii)/max(radii)

m = manipulability(puma,conf.qn,"link6",method="asada",axes="trans")

%% 9.3 Forward Dynamics
ur5 = loadrobot("universalUR5e",DataFormat="row",Gravity=[0 0 -9.81]);
ur5conf.qn = [0 -1.07 1.38 -0.3 0 -2.3];

qdd = ur5.forwardDynamics(ur5conf.qn);

sl_zerotorque

r = sim("sl_zerotorque");
t = r.find("tout");
q = r.find("yout");

rc = rateControl(10);
for i = 1:size(q,1)
  ur5.show(q(i,:),FastUpdate=true,PreservePlot=false);
  rc.waitfor;
end

clf
plot(t,q(:,1:3))

%% 9.4 Rigid-Body Dynamics Compensation
%% 9.4.1 Feedforward Control
ur5conf.qe = [0.9765 -0.8013 0.9933 -0.2655 0.8590 -2.2322];
sl_feedforward

r = sim("sl_feedforward");

%% 9.4.2 Computed-Torque Control
sl_computed_torque
r = sim("sl_computed_torque");

%% 9.6 - Applications
%% 9.6.1 - Series-Elastic Actuator (SEA)
sl_sea
r = sim("sl_sea");

