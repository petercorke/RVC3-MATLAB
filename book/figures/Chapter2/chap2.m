%% RVC2 chapter 2
clc
clear all

%% 2.1.1.1 2d rotation
R = rotm2d(0.2)

det(R)

det(R*R)

syms theta
R = rotm2d(theta)
simplify(R * R)
simplify(det(R))

%% 2.1.1.2 2d matrix expon
R = rotm2d(0.3)

S = logm(R)

vex(S)

expm(S)

R = rotm2d(0.3)

R = expm(  skew(0.3)  )

%% blue box
skew(2)
vex(ans)

%% 2.1.2.1 2D pose
T1 = trvec2tform2d([1,2]) * tformr2d(30, 'deg')

plotvol([0, 5, 0, 5]);
trplot2(T1, 'frame', '1', 'color', 'b')

T2 = trvec2tform2d([2,1])

trplot2(T2, 'frame', '2', 'color', 'r');

T3 = T1 * T2

trplot2(T3, 'frame', '3', 'color', 'g');

T4 = T2 * T1;
trplot2(T4, 'frame', '4', 'color', 'c');

P = [3 ; 2 ];

%plot_point(P, 'label', 'P', 'solid', 'ko');
P1 = inv(T1) * [P; 1]

hom2cart( (inv(T1) * cart2hom(P')')' )'
hom2cart( cart2hom(P') * inv(T1)' )'
% h2e( inv(T1) * e2h(P) )

%% 2.1.2.2 2D centres of rotation
plotvol([-5, 4, -1, 4.5]);
T0 = eye(3,3);
trplot2(T0, 'frame', '0');
X = trvec2tform2d([2,3]);
trplot2(X, 'frame', 'X');

R = tformr2d(2);

trplot2(R*X, 'framelabel', 'RX', 'color', 'r');
trplot2(X*R, 'framelabel', 'XR', 'color', 'r');

C = [1 2];
% HACK plot_point(C, 'label', ' C', 'textcolor', 'k', 'solid', 'ko')


RC = trvec2tform2d(C) * R * trvec2tform2d(-C)
trplot2(RC*X, 'framelabel', 'XC', 'color', 'r');

% %% 2.1.2.3 2D twists
% tw = Twist('R', C)
% 
% tw.T(2)
% 
% tw.pole'
% 
% tw = Twist('T', [1 1])
% 
% tw.T(sqrt(2))
% 
% T = transl2(2, 3) * trot2(0.5)
% 
% tw = Twist(T)
% tw.T

%% 2.2.1.1 3D rotation
R = rotmx(pi/2)

tformplot(R)

tranimate(R)

tranimate(R, '3d')

R = rotmx(pi/2) * rotmy(pi/2)

rotmy(pi/2)*rotmx(pi/2)

%% 3D matrix expon

R = rotmx(0.3)

S = logm(R) 

vex(S)'

[th,w] = trlog(R)

expm(S)

R = rotmx(0.3);

R = expm( skew([1 0 0]) * 0.3 );

%% blue box
skew([1 2 3])

vex(ans)'

%% 3-angle representation
R = rotmz(0.1) * rotmy(0.2) * rotmz(0.3)

R = eul2rotm([0.1, 0.2, 0.3], 'zyz')

gamma = rotm2eul(R, 'zyz')

R = eul2rotm([0.1 , -0.2, 0.3], 'zyz')

rotm2eul(R, 'zyz')

eul2rotm(ans, 'zyz')

R = eul2rotm([0.1, 0.2, 0.3], 'zyz')

rotm2eul(R, 'zyz')

% RPY angles
R = rotmz(0.3) * rotmy(0.2) * rotmx(0.1)

R = eul2rotm([0.3, 0.2, 0.1], 'zyx')

gamma = rotm2eul(R, 'zyx')

%%tripleangle

%% 2 vector
a = [1 0 0]';
o = [0 1 0]';
R = oa2rotm(o, a)

%% angle vector
R = eul2rotm([0.3 , 0.2, 0.1], 'zyx');

axang = rotm2axang(R)

[x,e] = eig(R)

theta = angle(e(2,2))

R = axang2rotm([1, 0, 0,  pi/2])

%% quaternions
q = quaternion( eul2rotm([0.3, 0.2, 0.1], 'zyx'), 'rotmat', 'point')

q = q * q

q.conj()

q * q.conj()

% q / q

q.rotmat('frame')

% q.plot()

q.rotatepoint([1 0 0])

%% 2.2.2.1 hom xform
T = trvec2tform([1, 0, 0]) * tformrx(pi/2) * trvec2tform([0, 1, 0])

tformplot(T)

tform2rotm(T)

tform2trvec(T)

%% 2.2.2.3 twists in 3d
tw = Twist('R', [1 0 0], [0 0 0])

tw.tform(0.3)

tw = Twist('T', [0 1 0])

tw.tform(2)

X = trvec2tform([3, 4, -4]);

angles = [0:0.3:15];

tw = Twist('R', [0 0 1], [2 3 2], 0.5);

clf
tranimate( @(theta) tw.tform(theta) * X, angles, ...
     'length', 0.5, 'retain', 'rgb', 'notext');

L = tw.line
 
L.plot('k:', 'LineWidth', 2)
 
T = trvec2tform([1, 2, 3]) * eul2tform([0.3, 0.4, 0.5], 'zyz');
tw = Twist(T)

tw.pitch

tw.theta

tw.pole'

%% normalization
R = eye(3,3);
det(R) - 1

for i=1:100
       R = R * eul2rotm([0.4, 0.3, 0.2], 'zyx');
end
det(R) - 1

R = tformnorm(R);
det(R) - 1

%q = q.normalize();


%% more twists
tw = Twist('R', [1 0 0], [0 0 0])

tw.S'
tw.v'
tw.w'

tw.se 

tw.tform(0.3)

tw.line

t2 = tw * tw
tform2axang(t2.tform)

%% using the toolboxes
T1 = se2(tform2d(1, 2, 30, 'deg'))
whos T1

T1 

T1.tform 
whos ans

inv(T1).transform(P)