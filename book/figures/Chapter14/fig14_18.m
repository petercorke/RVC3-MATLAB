% left=iread('left.jpg', 'reduce', 2);
% right=iread('right.jpg', 'reduce', 2);
% sl = isurf(left);
% sr = isurf(right);
% m = s1.match(s2, 'top', 1000)
% [F,r]=m.ransac(@fmatrix, 1e-4)
% 
cam = CentralCamera('image', im1, 'focal', 4.15e-3, 'pixel', 2*1.5e-6)
% iphone has 1.5um pixels, double for the image subsampling

im1 = imono(im1);

E = cam.E(F)

T = cam.invE(E, [0,0,10]')

T.torpy('yxz', 'deg')
t = T.t;
T.t = 0.1 * t/t(1)

r1 = cam.ray(m(1).p1)
r2 = cam.move(T).ray(m(1).p2)

[P,e] = r1.intersect(r2);
P'
e
N = 100;
m2 = m.inlier.subset(N);
r1 = cam.ray( m2.p1 );
r2 = cam.move(T).ray( m2.p2 );
[P,e] = r1.intersect(r2);
z = P(3,:);

idisp(im1*0.7, 'nogui')
plot_point(m.inlier.subset(N).p1, 'y+', 'printf', {'%.1f', z}, 'textcolor', 'y');


rvcprint('svg')