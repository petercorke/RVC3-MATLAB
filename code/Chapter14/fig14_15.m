
im1=iread('walls-l.jpg',  'double', 'reduce', 2);
im2=iread('walls-r.jpg',  'double', 'reduce', 2);

s1 = isurf(im1);
s2 = isurf(im2);


m = s1.match(s2, 'top', 1000)
 
randinit
[H,r] = m.ransac(@homography, 4)
m.show

clf
idisp(im1*0.7, 'nogui');

plot_point(m.inlier.p1, 'ys')
rvcprint('subfig', 'a', 'svg');


% m = m.outlier;
% [H,r] = m.ransac(@homography, 2)
% plot_point(m.inlier.p1, 'ws')
% 
% 
% m = m.outlier;
% [H,r] = m.ransac(@homography, 8)
% plot_point(m.inlier.p1, 'wo')


idisp(im2*0.7, 'nogui');
rvcprint('subfig', 'b', 'svg');
