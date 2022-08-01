figure(1)
clf
axis([-5 5 -5 5 -5 5])
grid on; 
hold on

U = tw.w;
V = -tw.v - tw.pitch * tw.w;

for t=[-10:.1:10]
    p = [cross(V,U)+t*U; dot(U,U)]

    p = p / p(end);
    plot3(p(1), p(2), p(3), 'o');
end