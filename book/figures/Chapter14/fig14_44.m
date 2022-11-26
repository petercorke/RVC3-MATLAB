% process Kinect images for book

%% IR image

b=rosbag('kinect_201511162144/kinect_201511162144_ir.bag')
b.AvailableTopics

%s=b.select('Topic', '/camera/depth/image_raw');

s=b.select('Topic', '/camera/ir/image_raw');

msg = s.readMessages(1);
z = msg{1};
im = z.readImage();
ir = im;

idisp(im, 'nogui')
brighten(0.3)
rvcprint('subfig', 'b', 'svg');

%% color image

b=rosbag('kinect_201511162144/kinect_201511162144_rgb.bag')
b.AvailableTopics
s=b.select('Topic', '/camera/rgb/image_color');

msg = s.readMessages(1);
z = msg{1};
im = z.readImage();

idisp((im), 'nogui')
rgb = im;
rvcprint('subfig', 'a', 'svg');

%% depth map

s=b.select('Topic', '/camera/depth/image')

msg = s.readMessages(1);
z = msg{1};
im = z.readImage();

depth = im;
im=sqrt(im);  % improve contrast at low values

% replace NaN with biggish number
mv = max(im(:));
im(isnan(im)) = mv + mv/10;

% display with colormap
idisp(im, 'nogui')
colormap(parula)
cm=colormap;

% add red to colormap
cm=[cm; 1 0 0];
colormap(cm)

b = colorbar();
b.FontSize = 10;
b.Label.String = 'Depth (m)';
b.Label.FontSize = 12;

rvcprint('subfig', 'c', 'svg', 'opengl');

save fig14_44.mat depth ir rgb
