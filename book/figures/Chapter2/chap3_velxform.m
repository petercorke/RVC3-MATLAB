T = SE3(1, 2, 0) * SE3.Rz(pi/2);

% body to world frame
vb = [0.2 0.3 0 0 0 0.5]';

R = T.R; t = T.t;

va = T.velxform * vb;
va'

% same body
TBC = SE3(0, 0.4, 0);
TCB = inv(TBC);
vc = TCB.Ad * vb;
vc'

% wrench example
WB = [3 4 0 0 0 0]'
WC = TBC.Ad' * WB;
WC'