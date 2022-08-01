close all

mdl_puma560
p560.fast = 0;

M = p560.inertia(qn)

eg_inertia
surf(Q2, Q3, M11, M11);  xlabel('q_2 (rad)'); ylabel('q_3 (rad)'); zlabel('M_{11} (kg.m^2)');
colormap(jet)
shading interp
lighting gouraud

rvcprint('subfig', 'a', '-opengl');

surf(Q2, Q3, M12, M12); xlabel('q_2 (rad)'); ylabel('q_3 (rad)'); zlabel('M_{12} (kg.m^2)');
colormap(jet)
shading interp
lighting gouraud

rvcprint('subfig', 'b', '-opengl');

eg_inertia22
grid on
rvcprint('subfig', 'c', '-opengl');

max(M11(:)) / min(M11(:))