castle = iread('castle_sign.jpg', 'double', 'grey');


Du = kdgauss(2)
Iu = iconv( castle, Du );
Iv = iconv( castle, Du' );

idisp( Iu, 'invsigned', 'nogui')
rvcprint('subfig', 'a', 'svg');

idisp( Iv, 'invsigned', 'nogui' )
rvcprint('subfig', 'b', 'svg');

m = sqrt( Iu.^2 + Iv.^2 );
idisp(m, 'black', 0.4, 'nogui');
rvcprint('subfig', 'c', 'svg');

th = atan2( Iv, Iu);
quiver(1:20:size(th,2), 1:20:size(th,1), ...
       Iu(1:20:end,1:20:end), Iv(1:20:end,1:20:end))
xaxis(1280)
yaxis(960)
xlabel('u (pixels)'); ylabel('v (pixels)')
rvcprint('subfig', 'd');
