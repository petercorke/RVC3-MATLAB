%T = transl(0.1, 0.6, -1)*trotz(0.3)*trotx(0.7);
T = se3(trvec2tform([0.1, 0.6, -1]))*se3(tformrz(0.3))*se3(tformrx(0.7));

c=CentralCamera('default');
P=mkgrid(2,.5)

uvf = c.project(P, 'pose', (trvec2tform([0,0,-2])))
uv0 = c.project(P, 'pose', T)

clf
hold on
plot_poly(uv0, 'r', 'fill', 'r', 'alpha', 0.5, 'DisplayName', 'initial shape');
plot_poly(uvf, 'b', 'fill', 'b', 'alpha', 0.5, 'MarkerFaceColor', 'b', 'DisplayName', 'goal shape');

plot_point(uv0, 'o', 'HandleVisibility','off');
plot_point(uvf, 'bh', 'MarkerFaceColor', 'b', 'MarkerSize', 9, 'HandleVisibility','off');

for i=1:4,
    %arrow(uv0(:,i), uvf(:,i), 'EdgeColor', 'b')
    arrow3(uv0(:,i)', uvf(:,i)', 'k2', 2,3)
end
axis([0 1024 0 1024])

grid
set(gca,'ydir','rev')
xlabel('u (pixels)');
ylabel('v (pixels)');

for c=gca().Children'
    if strcmp(c.Tag, 'arrow3')
        c.HandleVisibility = 'off'
    end
end

legend()

rvcprint('opengl')