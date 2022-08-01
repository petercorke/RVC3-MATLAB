distorted = iread('Image18.tif', 'double');
[Ui,Vi] = imeshgrid(distorted);
Up = Ui; Vp = Vi;
idisp(distorted, 'nogui');
rvcprint('subfig', 'a', 'svg')

load bouget
k = kc([1 2 5]); p = kc([3 4]);
u0 = cc(1); v0 = cc(2); fpix_u = fc(1); fpix_v = fc(2);
u = (Up-u0) / fpix_u;
v = (Vp-v0) / fpix_v;
r = sqrt( u.^2 + v.^2 );
delta_u = u .* (k(1)*r.^2 + k(2)*r.^4 + k(3)*r.^6) + ...
   2*p(1)*u.*v + p(2)*(r.^2 + 2*u.^2);
delta_v = v .* (k(1)*r.^2 + k(2)*r.^4 + k(3)*r.^6) + ...
   p(1)*(r.^2 + 2*v.^2) + 2*p(1)*u.*v;
ud = u + delta_u;  vd = v + delta_v;
U = ud * fpix_u + u0;
V = vd * fpix_v + v0;
undistorted = interp2(Ui, Vi, distorted, U, V);
idisp(undistorted, 'nogui');
rvcprint('subfig', 'b', 'svg')