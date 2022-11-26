%% RVC3: Chapter 8 (Manipulator Velocity)
format compact
close all
clear
clc

%% 8.1 Manipulator Jacobian

%% 8.1.1 Jacobian in the World Coordinate Frame
syms a1 a2 real
e = ETS2.Rz("q1")*ETS2.Tx(a1)*ETS2.Rz("q2")*ETS2.Tx(a2);

syms q1 q2 real
TE = e.fkine([q1 q2]);

p = tform2trvec2d(TE)' % transpose for display

J = jacobian(p,[q1 q2])


[puma,conf] = loadrvcrobot("puma");
J = puma.geometricJacobian(conf.qn,"link6")

irbt = interactiveRigidBodyTree(puma,Configuration=conf.qn);

%% 8.1.2 Jacobian in the End Effector Coordinate Frame
T = se3(puma.getTransform(conf.qn,"base","link6"));
Je = velxform(T)*J

%% 8.1.3 Analytical Jacobian
A = rpy2jac(0.3,0.2,0.1,"xyz")

Ja = [ones(3) zeros(3); zeros(3) inv(A)]*J;

%% 8.2 Application: Resolved-Rate Motion Control
sl_rrmc
r = sim("sl_rrmc");

t = r.tout;
q = r.yout;

figure;
stackedplot(t,q(:,1:3),DisplayLabels=["q1","q2","q3"], ...
  GridVisible=true,XLabel="Time")

for i = 1:size(q,1)
  Tfk(i) = se3(puma.getTransform(q(i,:),"link6"));
end

stackedplot(t,Tfk.trvec,DisplayLabels=["x","y","z"], ...
  GridVisible=true,XLabel="Time");

sl_rrmc2
sim("sl_rrmc2");

%% 8.3 Jacobian Condition and Manipulability

%% 8.3.1 Jacobian Singularities

J = puma.geometricJacobian(conf.qr,"link6")
det(J)
rank(J)

qns = conf.qr;
qns(5) = deg2rad(5)

J = puma.geometricJacobian(qns,"link6");

qd = inv(J)*[0 0 0 0 0 0.1]';
qd'  % transpose for display

det(J)
cond(J)

qd = inv(J)*[0 0.2 0 0 0 0]';
qd'  % transpose for display

%% 8.3.2 Velocity Ellipsoid and Manipulability
planar2 = ETS2.Rz("q1")*ETS2.Tx(1)*ETS2.Rz("q2")*ETS2.Tx(1);
planar2.teach(deg2rad([30 40]),"vellipse");

J = puma.geometricJacobian(conf.qn,"link6");
Jt = J(4:6,:);
E = inv(Jt*Jt')

plotellipsoid(E);
[v,e] = eig(E);
radii = 1./sqrt(diag(e)')

J = puma.geometricJacobian(qns,"link6");
Jr = J(1:3,:);
E = inv(Jr*Jr');
plotellipsoid(E);

[v,e] = eig(E);
radii = 1./sqrt(diag(e)')
v(:,3)'  % transpose for display

% TODO: Fix ellipse plotting
vellipse(puma,qns,mode="rot")

m = manipulability(puma,qns)
manipulability(puma,qns,[],axes="all")
m = manipulability(puma,conf.qn)

%% 8.3.3 Dealing with Jacobian Singularity

%% 8.3.4 Dealing with a Non-square Jacobian

%% 8.3.4.1 Jacobian for Under-Actuated Robot
qn = [1 1];
J = planar2.jacob0(qn)

xd_desired = [0 0.1 0.2];
qd = pinv(J)*xd_desired'

J*qd
norm(xd_desired - J*qd)

Jxy = J(2:3,:);
qd = inv(Jxy)*xd_desired(2:3)'
xd = J*qd
norm(xd_desired-xd)

%% 8.3.4.2 Jacobian for Overactuated Robot
panda = loadrobot("frankaEmikaPanda",DataFormat="row");
panda.removeBody("panda_leftfinger");
panda.removeBody("panda_rightfinger");

ik = inverseKinematics(RigidBodyTree=panda);
TE = se3(eye(3),[0.5 0.2 -0.2])*se3(tformry(pi));
qh = panda.homeConfiguration;
solq = ik("panda_hand",TE.tform,ones(1,6),qh);

J = panda.geometricJacobian(solq,"panda_hand");
size(J)

xd_desired = [0 0 0 0.1 0.2 0.3];
qd = pinv(J)*xd_desired';
qd'  % transpose for display
(J*qd)'  % transpose for display

rank(J)
N = null(J);
size(N)
N'  % transpose for display
norm(J*N)

qd_0 = [0 0 0 0 1 0 0];
qd = N * pinv(N)*qd_0';
qd'  % transpose for display
norm(J*qd)

%% 8.4 Force Relationships

%% 8.4.1 Transforming Wrenches to Joint Space
tau = puma.geometricJacobian(conf.qn,"link6")'*[0 0 0 0 20 0]';
tau'  % transpose for display
tau = puma.geometricJacobian(conf.qn, "link6")'*[0 0 0 20 0 0]';
tau'  % transpose for display

%% 8.4.2 Force Ellipsoids
planar2.teach(deg2rad([30 40]),"fellipse")
