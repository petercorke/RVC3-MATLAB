H = homography(p1, p2)

z = homwarp(H, im, 'full');
idisp(z, 'nogui');

rvcprint('svg')

[~,metadata] = iread('notre-dame.jpg', 'double');
f = metadata.DigitalCamera.FocalLength
cam = CentralCamera('image', im, 'focal', f/1000, ...
    'sensor', [7.18e-3,5.32e-3])
sol = cam.invH(H, 'verbose');
tr2rpy(sol(2).T, 'deg', 'camera')