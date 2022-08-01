cam = CentralCamera('default');

P = [1 1 5]';
p0 = cam.project( P )
px = cam.project( P, 'Tcam', trvec2tform([0.1,0,0]) )
( px - p0 ) / 0.1
( cam.project( P, 'Tcam', trvec2tform([0, 0, 0.1])) - p0 ) / 0.1
( cam.project( P, 'Tcam', tformrx(0.1) ) - p0) / 0.1
J = cam.visjac_p([672; 672], 5)
clf

% Tx
cam.flowfield( [0 0 0 1 0 0 ] );
text(20, 40, "x-axis translation", EdgeColor='k', BackgroundColor='w');
rvcprint('subfig', 'a')

% Tz
cam.flowfield( [0 0 0 0 0 1 ] );
text(20, 40, "z-axis translation", EdgeColor='k', BackgroundColor='w');
rvcprint('subfig', 'b')

% Rz
cam.flowfield( [0 0 1 0 0 0 ] )
text(20, 40, "z-axis rotation", EdgeColor='k', BackgroundColor='w');
rvcprint('subfig', 'c')

% Ry
cam.flowfield( [0 1 0 0 0 0 ] );
text(20, 40, "y-axis rotation, f=8mm", EdgeColor='k', BackgroundColor='w');
rvcprint('subfig', 'd')

% Ry long focal
cam.f = 20e-3;
cam.flowfield( [0 1 0 0 0 0 ] );
text(20, 40, "y-axis rotation, f=20mm", EdgeColor='k', BackgroundColor='w');
rvcprint('subfig', 'e')

% Ry short focal
cam.f = 4e-3;
cam.flowfield( [0 1 0 0 0 0 ] );
text(20, 40, "y-axis rotation, f=4mm", EdgeColor='k', BackgroundColor='w');
rvcprint('subfig', 'f')