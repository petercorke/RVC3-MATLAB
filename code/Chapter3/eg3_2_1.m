J = diag([2 4 3]); I(1,2) = -1; I(2,1) = -1;

w = 0.2*[1 2 2]';
R = eye(3,3);

dt = 0.05;
q = Quaternion();
h = q.plot();
for t=0:dt:20
  wd =  -inv(J)*(cross(w, J*w));
  w = w + wd*dt;  q = q .* Quaternion('omega', wd*dt);
  q.plot('handle', h); pause(dt)
end