clf

view(3)
S = Twist.UnitRevolute([0, 0, 1], [2, 3, 2], 0.5);

X = trvec2tform([3, 4, -4]);

hold on
for theta=[0:0.3:15]
  plottform(S.exp(theta).tform * X, style="rgb",labelstyle="none",LineWidth=2) % text=0, 
end

xlabel('x')
ylabel('y')
zlabel('z')

L = S.line;
L.plot('k:', 'Linewidth', 2)

axis([-1 5 0 6 -4 6])
daspect([1 1 2])
rvcprint(thicken=2)
% clf
% plotvol([0 5 0 5 -5 5])
% axis normal
% 
% X = transl(3, 4, -4);
% C = [2 3 2]';
% 
% 
% theta = [0:0.3:15];
% tw = Twist('R', [0 0 1], [2 3 2]', 0.5);
% 
% % clf
% % tranimate( @(th) trexp( twist('R', [0 0 1], C), th )*X, theta, 'keep');
% % pause
% % clf
% % tranimate( @(th) trexp( twist('P', [0 0 -1]), th )*X, theta, 'keep');
% % pause
% % clf
% tranimate( @(th) tw.T(th) * X, theta, 'length', 0.5, 'retain', 'rgb', 'notext');
% 
% L = tw.line;
% L.plot('k:', 'Linewidth', 2)
% 
% rvcprint

%{
tw = twist('R', [0 0 1], C)

T = T0;
h = tformplot(T*X, 'framelabel', 'XT');
for th=0.2:0.05:5
    T = trexp(tw, th);
    tformplot(h, T*X);
    pause(0.1)
end
delete(h)

tw = twist('P', [0 0 -1])

T = T0;
h = tformplot(T*X, 'framelabel', 'XT');
for th=0.2:0.05:5
    T = trexp(tw, th);
    tformplot(h, T*X);
    pause(0.1)
end
delete(h)

tw = twist('R', [0 0 1], C, 0.5)

T = T0;
h = tformplot(T*X, 'framelabel', 'XT');
for th=0.2:0.05:5
    T = trexp(tw, th);
    tformplot(h, T*X);
    pause(0.1)
end
delete(h)
%}
