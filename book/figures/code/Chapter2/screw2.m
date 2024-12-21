% demonstrate principles of 2d screw motion
T0 = eye(3,3);
clf
figure(1)
trplot2(T0, 'frame', '0', 'axis', [-4 4 -1 5])
hold on; grid on; axis equal
X = SE2(2, 3, 0);
trplot2(X, 'framelabel', 'X');

R = trot2(pi); X0 = R*X;
trplot2(X0, 'framelabel', 'X0');

C = [1.5 2.5]';
plot_point(C, 'label', ' C', 'textcolor', 'b', 'bo')

RC = transl2(C) * R * transl2(-C);
trplot2(RC*X, 'framelabel', 'XC');


% q = [C; 0]
% w = [0 0 1]';
% v = -cross(w, q)
% 
% T4 = expm( [skew(1) v(1:2); 0 0 0] * theta )

%{
tw = twist2('R', C)
trexp2(tw, 1.5)

tw = twist2('P', [1 1])
TP = trexp2(tw, sqrt(2))
trplot2(TP*X, 'framelabel', 'XP');
%}

