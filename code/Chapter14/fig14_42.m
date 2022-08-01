load bunny
M = bunny;
T_unknown = SE3(0.2, 0.2, 0.1) * SE3.rpy(0.2, 0.3, 0.4);
D = T_unknown * M;

clf
plot2(M', 'r.', 'MarkerSize', 20);
hold on
plot2(D', 'b.', 'MarkerSize', 8)
hold off
xyzlabel
rvcprint('subfig', 'a');


corresp = closest(D, M);


[T_DM,d] = icp(M, D, 'verbose')
trprint(T_DM, 'rpy', 'radian')
T_DM = SE3(T_DM);

%%
plot2(M', 'r.', 'MarkerSize', 20);
hold on
plot2( (inv(T_DM)*D)', 'b.', 'MarkerSize', 8)
hold off
xyzlabel

rvcprint('subfig', 'b');

%% now with errors
randinit
D(:,randi(size(D,2), 40,1)) = [];
D = [D 0.1*rand(3,20)+0.1];
D = D + 0.01*randn(size(D));


[T_DM,d] = icp(M, D, 'verbose', 'plot', 'distthresh', 3)
trprint(T_DM, 'rpy', 'radian')