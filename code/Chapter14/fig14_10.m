close all
cam = CentralCamera('image', im1);
cam.plot_epiline(F', m.inlier.subset(20).p2, 'g');
h2e( null(F))
cam.hold(true);
cam.plot(ans, 'bo')

rvcprint('hidden', cam.h_image.Parent)