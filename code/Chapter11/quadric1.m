Q = [
    1   0   0   -2/2
    0   1   0   2/2
    0   0   1   -4/2
    -2/2    2/2 -4/2    5.5 ]

eig(Q)

syms x y z real
expand( [x y z 1] * Q * [x y z 1]' )

%%
Qstar = inv(Q)*det(Q)
cstar = C * Qstar * C'
c = inv(cstar) * det(cstar)
det(c(1:2,1:2))
