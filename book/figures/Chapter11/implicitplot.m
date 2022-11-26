function implicitplot(A)
    
    clf
    a = A(1,1);
b = A(1,2)*2;
c = A(2,2);
d = A(1,3)*2;
f = A(2,3)*2;
g = A(3,3);

imconic([a b c d f g], []);