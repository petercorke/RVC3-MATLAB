TT = SE3(1,2,3) * SE3.rpy([.1,.2,.3])
T = TT.T

t1 = timeit(@() trlog(T))
t2 = timeit(@() logm(T))
fprintf('trlog: %f\n', t1)
fprintf('logm:  %f\n', t2)
fprintf('ratio: %f\n', t2/t1)

S = skewa([1, 2, 3, .1, .2, .3]);

t1 = timeit(@() trexp(S))
t2 = timeit(@() expm(S))
fprintf('trexp: %f\n', t1)
fprintf('expm:  %f\n', t2)
fprintf('ratio: %f\n', t2/t1)

R = TT.R
q = quaternion(R, 'rotmat', 'frame')

t1 = timeit(@() tformnorm(R))
t2 = timeit(@() normalize(q))
fprintf('trnorm:          %f\n', t1)
fprintf('quat.normalize:  %f\n', t2)
fprintf('ratio:           %f\n', t2/t1)