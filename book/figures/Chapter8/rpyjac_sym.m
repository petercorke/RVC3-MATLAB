syms r p y rd pd yd wx wy wz real
syms rt(t) pt(t) yt(t) 

R = rotmx(y) * rotmy(p) *rotmz(r)

Rt = rotmx(yt) * rotmy(pt) *rotmz(rt);
dRdt = diff(Rt, t);
dRdt = subs(dRdt, {diff(rt(t),t), diff(pt(t),t), diff(yt(t),t),}, {rd,pd,yd});
dRdt = subs(dRdt, {rt(t),pt(t),yt(t)}, {r,p,y});
dRdt = formula(dRdt)   % convert symfun to an array

w = vex(dRdt * R');
w = simplify(w)

clear A
rpyd = [rd pd yd];

for i=1:3
    for j=1:3
        C = coeffs(w(i), rpyd(j));
        if length(C) == 1
            A(i,j) = 0;
        else
        A(i,j) = C(2);
        end
    end
end

A