L = iread('walls-l.jpg', 'mono', 'double', 'reduce', 2);
R = iread('walls-r.jpg', 'mono', 'double', 'reduce', 2);
% L = iread('garden-l.jpg', 'mono', 'double');
% R = iread('garden-r.jpg', 'mono', 'double');
sL = isurf(L);
sR = isurf(R);
m = sL.match(sR);
randinit
F = m.ransac(@fmatrix,1e-4, 'verbose');
[Lr,Rr] = irectify(F, m, L, R);

Lr(isnan(Lr)) = Inf;
Rr(isnan(Rr)) = Inf;

idisp({Lr,Rr}, 'nogui')
c=colormap;
c=[c; 1 1 1; 1 1 1; 1 0 0];
colormap(c)

rvcprint('svg')