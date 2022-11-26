x = [1, 2, -3, 0.1, 0.2, 0.3,  0.1, 0.2, 0.3, 0.1, 0,2, 0.3]';

[s] = quadrotor_dynamics(0, x, [0, 0, 0, 0], 3, quadrotor, 0, 0);
% 3 outputs
% 1 derivs

s'

[s] = quadrotor_dynamics(0, x, [1,.9,1.1,1]*900, 1, quadrotor, 0, 0);
% 3 outputs
% 1 derivs

s'