close all; clear;
puma = loadrvcrobot("puma");

[Q2,Q3] = meshgrid(-pi:0.1:pi, -pi:0.1:pi);
for i=1:size(Q2,2)
    for j=1:size(Q3,2)
        g = puma.gravityTorque([0 Q2(i,j) Q3(i,j) 0 0 0]);
        g2(i,j) = g(2);   %#ok<SAGROW> % Shoulder gravity load
        g3(i,j) = g(3);   %#ok<SAGROW> % Elbow gravity load
    end
end
% surfl (Q2, Q3, g2); surfl (Q2, Q3, g3);

%% Subfigure (a) - Gravity load plot for shoulder
figure;
surf(Q2, Q3, g2);  xlabel('q_2 (rad)'); ylabel('q_3 (rad)'); zlabel('g_2 (N.m)');
colormap(jet)
shading interp
lighting gouraud

rvcprint("opengl", subfig="_a");

%% Subfigure (b) - Gravity load plot for elbow
figure;
surf(Q2, Q3, g3, g3); xlabel('q_2 (rad)'); ylabel('q_3 (rad)'); zlabel('g_3 (N.m)');
colormap(jet)
shading interp
lighting gouraud

rvcprint("opengl", subfig="_b");
