

syms r(t) p(t) y(t) 

R = rotmx(y) * rotmy(p) * rotmz(r)
Rd = diff(R, t)

syms rd pd yd real
Rd = subs(Rd, {diff(y(t),t), diff(p(t),t), diff(r(t),t)}, {yd, pd, rd})


a = Rd2 * R.';

a = subs(a, {r(t), p(t), y(t)}, {'r', 'p', 'y'});



arrayfun(@(x) x, a, 'UniformOutput', false);
a = ans{1};


vex(a)
syms r p y
a = simplify(ans)
a = subs(a, {sin(r), cos(r)}, {'sr', 'cr'})
a = subs(a, {sin(p), cos(p)}, {'sp', 'cp'})
a = subs(a, {sin(y), cos(y)}, {'sy', 'cy'})