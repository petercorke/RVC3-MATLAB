mdl_twolink_sym

syms q1 q2 q1d q2d q1dd q2dd real

tau = twolink.rne([q1 q2], [q1d q2d], [q1dd q2dd]);

t1 = simplify( tau(1) );

[c,t] = coeffs(expand(t1), [q1dd q2dd  q1d q2d g])

J1 = simplify(c(1));
J1 = collect(J1, [cos(q2) m1 m2])
latex2(J1, 'sub', {'c', 'm'})

J2 = simplify(c(2));
latex2(J2, 'sub', {'c', 'm'})

c12 = simplify(c(3));
latex2(c12, 'sub', {'c', 'm'})

c11 = simplify(c(4));
latex2(c11, 'sub', {'c', 'm'})

gg = simplify(c(5));
gg = collect(gg, [cos(q1) cos(q1+q2)]);
latex2(gg, 'sub', {'c', 'm'})



C = simplify(twolink.coriolis([q1 q2], [q1d q2d]));