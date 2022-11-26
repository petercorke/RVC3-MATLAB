mona = iread('monalisa.png', 'double', 'grey');
[Ui,Vi] = imeshgrid(mona);
[Up,Vp] = imeshgrid(400, 400);
U = 4*(Up-100); V = 4*(Vp-200);
mona_small = interp2(Ui, Vi, mona, U, V);
mona_small(isnan(mona_small)) = Inf;
idisp(mona_small, 'nogui', 'cscale', [0 1]);
c=[colormap; 1 0 0];
colormap(c)
rvcprint('subfig', 'a', 'svg')

[Up,Vp] = imeshgrid(mona);
R = SE2(0, 0, pi/6).R; uc = size(mona,2)/2; vc = size(mona,1)/2;
U = R(1,1)*(Up-uc) + R(2,1)*(Vp-vc) + uc;
V = R(1,2)*(Up-uc) + R(2,2)*(Vp-vc) + vc;
% R = SO2(pi/6); uc = size(mona,2)/2; vc = size(mona,1)/2;
% UV = R * [Up(:)-uc Vp(:)-vc]';
% U = reshape(UV(1,:), size(Up)) + uc;
% V = reshape(UV(2,:), size(Vp)) + vc;
mona_rotated = interp2(Ui, Vi, mona, U, V);
mona_rotated(isnan(mona_rotated)) = Inf;
idisp(mona_rotated, 'nogui')
c=[colormap; 1 0 0];
colormap(c)
rvcprint('subfig', 'b', 'svg')

