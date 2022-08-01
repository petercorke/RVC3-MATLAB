%% unit tests for chap 2  3D data type operations table

% translation vector
t = [1; 2; 3];
transl(t)
Twist('T', t)
SE3(t)

% Euler angles
th = [0.2 0.2 0.3];
eul2r(th)
eul2tr(th)
UnitQuaternion.eul(th)
SO3.eul(th)
SE3.eul(th)

% RPY angles
th = [0.2 0.2 0.3];
rpy2r(th)
rpy2tr(th)
UnitQuaternion.rpy(th)
SO3.rpy(th)
SE3.rpy(th)

% angle-vector
th = 0.2; v = [1 2 3]';
angvec2r(th, v)
angvec2tr(th, v)
UnitQuaternion.angvec(th, v)
SO3.angvec(th, v)
SE3.angvec(th, v)

% rotation matrix
R = rotmx(0.2);
r2t(R)
%Twist('R', R)
SO3(R)
SE3(R)

% homogeneous transform matrix
T = transl(t) * eul2tr([0.2 0.2 0.3])
transl(T)
t2r(T)
Twist(T)
SO3(T)
SE3(T)

% twist vector length 3
S = Twist(R).S
trexp(S)
trexp(S)
Twist(S)
SO3.exp(S)
SE3.exp(S)

% twist vector length 6
S = Twist(T).S
trexp(S)
trexp(S)
Twist(S)
SO3.exp(S)
SE3.exp(S)

% Twist object
tw = Twist(T)
tw.T
tw.S
tw.SE

% UnitQuaternion object
q = UnitQuaternion(R);
q.toeul
q.torpy
q.toangvec
q.R
q.T
q.SO3
q.SE3

% SO3 object
X = SO3(R);
X.toeul
X.torpy
X.toangvec
X.R
X.T
X.UnitQuaternion
X.SE3

% SE3 object
X = SE3(T);
X.toeul
X.torpy
X.toangvec
X.R
X.T
X.UnitQuaternion
X.SO3
