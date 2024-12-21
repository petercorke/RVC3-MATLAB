%% Matlab commands extracted from /Users/corkep/doc/svn/book/appendices/refresher.tex


[x,y] = meshgrid(-5:0.1:5, -5:0.1:5);
C = diag([1 2^2]);
g = gaussfunc([0 0], C, x, y) ;
clf
axis([-5 5 -5 5 -.05 .12])
hold on
surfc(x, y, g)
grid
xlabel('x'); ylabel('y'); zlabel('g(x,y)');
view(-24, 18)
rvcprint('here');
