close all; clear;
puma = loadrvcrobot("puma");

[Q2,Q3] = meshgrid(-pi:0.1:pi, -pi:0.1:pi);
for i=1:size(Q2,2)
    for j=1:size(Q3,2)
        M = puma.massMatrix([0 Q2(i,j) Q3(i,j) 0 0 0]);
        m11(i,j) = M(1,1);
        m12(i,j) = M(1,2);
    end
end

%% Subfigure (a) - Surface for M11
figure;
surf(Q2, Q3, m11, m11);  xlabel("q_2 (rad)"); ylabel("q_3 (rad)"); zlabel("m_{11} (kg.m^2)");
colormap(jet)
shading interp
lighting gouraud

rvcprint("opengl", subfig="_a");

%% Subfigure (b) - Surface for M12
figure;
surf(Q2, Q3, m12, m12); xlabel("q_2 (rad)"); ylabel("q_3 (rad)"); zlabel("m_{12} (kg.m^2)");
colormap(jet)
shading interp
lighting gouraud

rvcprint("opengl", subfig="_b");

%% Subfigure (c) - Plot of q3, with q2 fixed
% eg_inertia22
q2 = 0;
q3 = -pi:0.1:pi;
for i=1:length(q3)
    M = puma.massMatrix([0 q2 q3(i) 0 0 0]);
    m22(i) = M(2,2);
end

figure;
plot(q3,m22);
xlabel("q_3 (rad)");
ylabel("m_{22} (kg.m^2)");
grid on
rvcprint("painters", subfig="_c", thicken=1.5);
