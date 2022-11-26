mdl_puma560

r = sim('sl_ztorque');
t = r.find('tout');
q = r.find('yout');
p560.plot(q)
clf
plot(t, q(:,1:3)); ylabel('q (rad)'); xt;
legend('q_1', 'q_2', 'q_3')
rvcprint()