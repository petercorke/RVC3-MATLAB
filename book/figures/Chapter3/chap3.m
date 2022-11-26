clf
clear

%%  3.1.2 transforming spatial velocity
plotvol(5)
wT = SE3()
wT.plot(frame="A", color="b")
hold on
aTb = SE3(-2, 0, 0) * SE3.Rz(-pi/2) * SE3.Rx(pi/2);
aTb.plot(frame="B", color="r")


% body to world frame
bV = [1 2 3 4 5 6]';

aV = aTb.velxform * bV;
aV'

%% same body
clf

wT.plot(frame="A")
aTb.plot(frame="B")

aV = aTb.Ad() * [1 2 3 0 0 0]';
aV'

aV = aTb.Ad() * [0 0 0 1 0 0]';
aV'

aV = aTb.Ad() * [1 2 3 1 0 0]';
aV'


%% 3.1.3 incremental rotation

rotmx(0.001)

R1 = eye(3,3); R1cheap = eye(3,3)
w = [1 0 0]; dt = 0.01
for i=1:100
    R1 = R1 * expm(skew(w*dt));
    R1cheap = R1cheap + R1cheap * skew(w*dt);
end
det(R1)-1
det(R1cheap)-1

tr2angvec(trnorm(R1))
tr2angvec(trnorm(R1cheap))


%% 3.2.1 dynamics of moving bodies

J = [2 -1 0;-1 4 0;0 0 3];
attitude = quaternion([1 0 0 0]);
w = 0.2*[1 2 2]';
dt = 0.05;
h = tformplot();
for t=0:dt:10
    wd =  -inv(J) * (cross(w, J*w));
    w = w + wd*dt;  attitude = attitude * quaternion(w'*dt, "rotvec");
    tformplot(attitude.rotmat("point"), "handle", h); pause(dt)
end

%% 3.2.2 transforming forces/torques
% wrench example
bW = [1 2 3 0 0 0]'
aW = inv(aTb).Ad()' * bW;
aW'

%% 3.3 smooth 1D trajectories
clf
t = linspace(0, 1, 50)
[s,sd,sdd] = quinticpolytraj([0 1], [0 1], t);
stackedplot(t, [s' sd' sdd'])

%%
[s2,sd2,sdd2] = quinticpolytraj([0 1], [0 1], t, VelocityBoundaryCondition=[10 0]);
stackedplot(t, [s2' sd2' sdd2'])

mean(sd) / max(sd)
%%

[s, sd,sdd] = trapveltraj([0 1], 50, EndTime=1)
stackedplot(t, [s' sd' sdd'])
max(sd)
%%
[s2,sd2,sdd2] = trapveltraj([0 1], 50, EndTime=1, PeakVelocity=1.2);
[s3,sd3,sdd3] = trapveltraj([0 1], 50, EndTime=1, PeakVelocity=2);

%% 3.3.2 multi-dimensional case

q = trapveltraj([0 1; 2 -1], 50, EndTime=1);
plot(q') 

T = SE3.rand
q = [T.t' T.torpy]

%% 3.3.3 multi-segment trajectories
via = SO2(deg2rad(30)) * [-1 1 1 -1 -1; 1 1 -1 -1 1];
[q,~,~,t] = trapveltraj(via, 100, EndTime=5, AccelTime=0);
max(t)
plot(q(1,:), q(2,:))

[q2,~,~,t2] = trapveltraj(via, 100, EndTime=5, AccelTime=2);
% [size(q0,1) size(q2,1)]
[max(t), max(t2)]

%% 3.3.4 interpolation of orientation
R0 = SO3.Rz(-1) * SO3.Ry(-1);
R1 = SO3.Rz(1) * SO3.Ry(1);

rpy0 = R0.torpy(); rpy1 = R1.torpy();
rpy = quinticpolytraj([rpy0' rpy1'], [0 1], 0:0.02:1);
clf
SO3.rpy(rpy').animate;

%%
q0 = R0.quaternion(); q1 = R1.quaternion();
qt = q0.slerp(q1, linspace(0, 1, 50))

whos qt
tranimate(qt.rotmat("point"))


%% 3.3.5 direction of rotation
R1 = SO3.Rz(-2);
R2 = SO3.Rz(1);
R1.animate(R2)

%%
R2 = SO3.Rz(1.5);
R1.animate(R2)


%% 3.3.6 Cartesian motion
T0 = SE3([0.4, 0.2, 0]) * SE3.rpy(0, 0, 1.5);
T1 = SE3([-0.4, -0.2, 0.3]) * SE3.rpy(-pi/2, 0, -pi/2);

% T0 is different compared to second edition, quaternion interpolator
% always takes shortest path

T0.interp(T1, 0.5)

Ts = T0.interp(T1, 50);

whos Ts

Ts(1)

Ts.animate
P = Ts.transl;
about(P)
plot(P)
%%
rpy = Ts. torpy;
plot(rpy);
%%
Ts = T0. interp(T1, trapveltraj([0 1], 50) );
Ts = T0.ctraj(T1, 50);


%% 3.4.1.2 estimating orientation
clear attitude
clf

truth = imudata()

attitude = quaternion([1 0 0 0]);
for k=1:size(truth.omega,1)-1
   attitude(k+1) = attitude(k) * quaternion(truth.omega(k,:)*truth.dt, "rotvec");
end
whos attitude

tformanim(attitude.rotmat("point"), "time", truth.t)

stackedplot(attitude.euler("zyx", "point"))

%% 3.4.4 sensor fusion

[truth,IMU] = imudata()

attitude(1) = quaternion([1 0 0 0]);
for k=1:size(IMU.gyro,1)-1
   attitude(k+1) = attitude(k) * quaternion(IMU.gyro(k,:)*IMU.dt, "rotvec");
end
plot(IMU.t, dist(attitude, truth.attitude), "r", LineWidth=2);

title("error: simple integration")

%%
figure
[truth,IMU] = imudata()
kI = 0.2; kP = 1;

bias = zeros(size(IMU.gyro,1),3);
attitude_ECF(1) = quaternion([1 0 0 0]);
for k=1:size(IMU.gyro,1)-1
   invq = conj( attitude_ECF(k) );
   sigmaR = cross(IMU.accel(k,:), invq.rotatepoint(truth.g0)) + ...
            cross(IMU.magno(k,:), invq.rotatepoint(truth.B0));
   wp = IMU.gyro(k,:) - bias(k,:) + kP*sigmaR;
   attitude_ECF(k+1) = attitude_ECF(k) * quaternion(wp*IMU.dt, "rotvec");
   bias(k+1,:) = bias(k,:) - kI*sigmaR*IMU.dt;
end

plot(IMU.t, dist(attitude_ECF, truth.attitude), "b" );
title("ecf error")

figure
plot(IMU.t, attitude_ECF.euler("zyx", "point"))
title("ECF RPY")