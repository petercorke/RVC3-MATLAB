%% Matlab commands extracted from /Users/corkep/doc/svn/book/src/vservo/chap.tex
format compact
close all

%% 15.1 position-based visual servoing
cam = CentralCamera('default');

P = mkgrid( 2, 0.5, 'T', SE3(0,0,3) );

Tc = SE3(0,0,0);  %DIFF
p = cam.plot(P, 'Tcam', Tc)

C_Te_G = cam.estpose(P, p);

T_delta = C_Te_G * inv(Cd_T_G);

lambda = 0.2;  %DIFF
C_T = C_T .* Tdelta.interp(lambda);

C_T0 = SE3(1,1,-3)*SE3.Rz(0.6);

Cd_T_G = SE3(0, 0, 1);

pbvs = PBVS(cam, 'T0', Tc0, 'Tf', TcStar_t)

pbvs.run(5);

pbvs.plot_p();
pbvs.plot_vel();
pbvs.plot_camera();


%% 15.2.1 camera and image motion
cam = CentralCamera('default');

P = [1 1 5]';

p0 = cam.project( P )

px = cam.project( P, 'Tcam', SE3(0.1,0,0) )

( px - p0 ) / 0.1

( cam.project( P, 'Tcam', transl(0, 0, 0.1) ) - p0 ) / 0.1

( cam.project( P, 'Tcam', trotx(0.1) ) - p0 ) / 0.1

J = cam.visjac_p([672; 672], 5)


clf
cam.flowfield( [1 0 0 0 0 0] );

cam.flowfield( [0 0 1 0 0 0] );

cam.flowfield( [0 0 0 0 0 1] );

cam.flowfield( [0 0 0 0 1 0] );

cam.visjac_p(cam.pp', 1)

cam.f = 20e-3;
cam.flowfield( [0 0 0 0 1 0] );

cam.f = 4e-3;
cam.flowfield( [0 0 0 0 1 0] );

J = cam.visjac_p(cam.pp', 1)

%% 15.2.2 controlling feature motion
cam = CentralCamera('default');

P = mkgrid( 2, 0.5, 'T', SE3(0,0,3) );

pd = bsxfun(@plus, 200*[-1 -1 1 1; -1 1 1 -1], cam.pp');

T_C = SE3(0,0,0); %DIFF
%transl(1,1,-3)*trotz(0.6)

p = cam.plot(P, 'Tcam', T_C)

e = pd - p;

J = cam.visjac_p(p, 1);

v = lambda * pinv(J) * e;

T_C = T_C .* delta2tform(v);

T_C0 = SE3(1,1,-3)*SE3.Rx(0.6)

ibvs = IBVS(cam, 'T0', T_C0, 'pstar', pd)

ibvs.run();

ibvs.plot_p();
ibvs.plot_vel();
ibvs.plot_camera();

sl_ibvs

r = sim('sl_ibvs')

t = r.find('tout');
v = r.find('yout').signals(2).values;
about(v)

plot(t, v)

p = r.find('yout').signals(1).values;
about(p)
plot2(p)

%% 15.2.3 estimating feature depth
ibvs = IBVS(cam, 'T0', T_C0, 'pstar', pd, 'depth', 1)
ibvs.run(50)
ibvs.plot_all('ibvs1_1');
ibvs = IBVS(cam, 'T0', T_C0, 'pstar', pd, 'depth', 10)
ibvs.run(50)


ibvs = IBVS(cam, 'T0', T_C0, 'pstar', pd, 'depthest')
ibvs.run()
ibvs.plot_z()
ibvs.plot_p()

%% 15.2.4 performance issues
pbvs.T0 = SE3(-2.1, 0, -3)*SE3.Rz(5*pi/4);
pbvs.run()
ibvs.plot_p();

ibvs = IBVS(cam, 'T0', pbvs.T0, 'pstar', pd, 'lambda', 0.002, 'niter', Inf, 'eterm', 0.5)
ibvs.run()
ibvs.plot_p();

ibvs = IBVS(cam, 'T0', SE3(0,0, -1)*SE3.Rz(1), 'pstar', pd);
ibvs.run()
ibvs.plot_camera

ibvs = IBVS(cam, 'T0',  transl(0,0, -1)*trotz(pi), ...
    'pstar', pd, 'niter', 10);
ibvs.run()
ibvs.plot_camera

%% 15.3.1 line features
P = circle([0 0 3], 0.5, 'n', 3);

ibvs = IBVS_l(cam, 'example');
ibvs.run()

%% 15.3.2 circle features
P = circle([0 0 3], 0.5, 'n', 10);

p = cam.project(P, 'Tcam', Tc);

pn = homtrans( inv(cam.K), p );

x = pn(1,:); y = pn(2,:);
a = [y.^2; -2*x.*y; 2*x; 2*y; ones(1,size(x,2))]';
b = -(x.^2)';
E = a\b;

plane = [0 0 1 -3]; %DIFF
J = cam.visjac_e(E, plane);

ibvs = IBVS_e(cam, 'example');
ibvs.run()
