% % 2 views of walls done by bundle adjustment
% 
% % run 14_15 through 14_18 first
% 
% 
% im1=iread('walls-l.jpg',  'double', 'reduce', 2);
% 
% im2=iread('walls-r.jpg',  'double', 'reduce', 2);
% 
% cam = CentralCamera('focal', 4.5e-3, 'pixel', 2*1.5e-6, 'resolution', [1224 1632])
% %iphone has 1.5um pixels, double for the image subsampling
% 
% im1 = imono(im1);
% im2 = imono(im2);
% 
% s1 = isurf(im1);
% s2 = isurf(im2);
% m = s1.match(s2, 'top', 1000)
% 
% randinit
% [F,r] = m.ransac(@fmatrix, 1e-4)
% m.show
% 
% N = 100;
% m2 = m.inlier.subset(N);
% r1 = cam.ray( m2.p1 );
% r2 = cam.move(T).ray( m2.p2 );
% [P,e] = r1.intersect(r2);


ba = BundleAdjust(cam);

c1 = ba.add_camera( SE3, 'fixed' );
c2 = ba.add_camera( T );



for j=1:length(m2)
    landmark = ba.add_landmark( P(:,j) );
    ba.add_projection(c1, landmark, m2(j).p1);
    ba.add_projection(c2, landmark, m2(j).p2);
end

ba

X = ba.getstate();

ba.errors(X)

baf = ba.optimize(X);

ba.getcamera(2).print('camera')
baf.getcamera(2).print('camera')

baf.getlandmark(5)'



e = sqrt( baf.getresidual() );

median( e(:) )
find( e(1,:) > 1 )
[mx,k] = max( e(1,:) )

baf.plot('NodeSize', 4)
axis([-2 3 -2 1 -0.5 6])
view(-162, 34)

rvcprint
