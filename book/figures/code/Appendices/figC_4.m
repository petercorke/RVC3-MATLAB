%% C.1.4.3 fitting to an ellipse
rng(0); clf

E = [1 1; 1 2];

% generate a set of points within the ellipse
p = [];
while size(p,2) < 500
    x = (rand(2,1)-0.5)*4;
    if norm(x'*E*x) <= 1
        p = [p x];
    end
end
plot(p(1,:), p(2,:), '.');

% compute the moments
m00 = mpq_point(p, 0,0);
m10 = mpq_point(p, 1,0);
m01 = mpq_point(p, 0,1);
xc = m10/m00; yc = m01/m00;

% compute second moments relative to centroid
pp = p - [xc; yc];

m20 = mpq_point(pp, 2,0);
m02 = mpq_point(pp, 0,2);
m11 = mpq_point(pp, 1,1);

% compute the moments and ellipse matrix
J = [m20 m11; m11 m02];

E_est = m00/4 * inv(J);
plotellipse(E_est, [xc yc],  'r')

xlabel('x'); ylabel('y');

rvcprint('here')