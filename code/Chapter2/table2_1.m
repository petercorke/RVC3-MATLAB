%% unit tests for chap 2  2D data type operations table

t = [1; 2];

transl2(t)
Twist('T', t)
SE2(t)

th = 0.3;
rotm2d(th)
trot2(th)
SO2(th)
SE2(0, 0, th)

R = rotm2d(th)
r2t(R)
%Twist('R', R)
SO2(R)
SE2(R)

T = transl2(t) * trot2(th)
transl2(T)
t2r(T)
Twist(T)
%SO2(T)
SE3(T)

S = Twist(T).S
trexp2(S)
trexp2(S)
Twist(S)
SE2.exp(S)

tw = Twist(T)
tw.T
tw.S
tw.SE

X = SO2(th)
X.theta
X.R
X.T
X.log
X.SE2

X = SE2(1, 2, th)
X.t
X.theta
X.R
X.T
X.log
X.Twist
X.SO2