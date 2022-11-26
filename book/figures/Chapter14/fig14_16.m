% im1=iread('walls-l.jpg',  'double', 'reduce', 2);
% im2=iread('walls-r.jpg',  'double', 'reduce', 2);
% 
% s1 = isurf(im1);
% s2 = isurf(im2);
% 
% m = s1.match(s2, 'top', 1000)

randinit
[F,r] = m.ransac(@fmatrix, 1e-4, 'verbose');


cam = CentralCamera('image', im1*0.7);
cam.plot_epiline(F', m.inlier.subset(40).p2, 'y');

rvcprint('nobgfix', 'hidden', cam.h_image.Parent);