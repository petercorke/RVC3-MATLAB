mdl_puma560
p560.fast = 0;
eg_grav
surf(Q2, Q3, g2);  xlabel('q_2 (rad)'); ylabel('q_3 (rad)'); zlabel('g_2 (N.m)');
colormap(jet)
shading interp
lighting gouraud

rvcprint('subfig', 'a', '-opengl');


surf(Q2, Q3, g3, g3); xlabel('q_2 (rad)'); ylabel('q_3 (rad)'); zlabel('g_3 (N.m)');
colormap(jet)
shading interp
lighting gouraud


rvcprint('subfig', 'b', '-opengl');
