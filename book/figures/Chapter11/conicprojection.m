cam = CentralCamera('default', 'pose', se3(eye(3), [0.2 0.1 -5]) * se3(rotmx(.2)));

Q = diag([1 1 1 -1]);    % unit sphere

cs = cam.C * adjoint(Q) * cam.C';
c = adjoint(cs)

syms x y real
ezplot([x y 1]*c*[ x y 1]', [0 1024 0 1024])
axis equal
set(gca, 'Ydir', 'reverse')
grid


% P = circle([0.1, 0.2], 0.3);
% P = [P; ones(1, size(P,2))];
% 
% cam.plot(P)
% 
% % (x-0.1)^2 + (y-0.2) = 0.3^2
% 
% syms x y real
% 
% e = (x-0.1)^2 + (y-0.2)^2 - 0.3^2 ;
% e = expand(e)
% 
% A = 1;
% B = 0;
% C = 1;
% D = -1/5;
% E = -2/5;
% F = -1/25;
% 
% A = [A B/2 D/2; B/2 C E/2; D/2 E/2 F]
% det(A(1:2,1:2))
% ezplot([x y 1]*A*[ x y 1]')
% 
% % centre
% c = -inv(A(1:2,1:2)) * A(1:2,3)
% % axis directions, eigenvectors of A(1:2,1:2)
% 
% A2 = cam.C' * A * cam.C
% det(A2(1:2,1:2))
% ezplot([x y 1]*A2*[ x y 1]')
% % can add [xmin xmax ymin ymax]
% % but cant see where it is plotted
% 
% c = -inv(A2(1:2,1:2)) * A2(1:2,3)
% 
% a = A2(1,1);
% b = A2(1,2*2);
% c = A2(2,2);
% d = A2(1,3)*2;
% e = A2(2,3)*2;
% f = A2(3,3);
% 
% ezplot(a*x^2 + b*x*y + c*y^2 + d*x + e*y + f, [-1 1 -1 1]*1000);