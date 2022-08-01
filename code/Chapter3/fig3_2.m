clf
t = 0:0.02:1
[s,sd,sdd] = quinticpolytraj([0 1], [0 1], t);

plotsargs = {'.-', 'Markersize', 16};
h = stackedplot(t, [s' sd' sdd'], plotsargs{:}, 'DisplayLabels',  ["$q$" "$\dot{q}$" "$\ddot{q}$"])
grid on
xlabel('t (seconds)')
ax = findobj(h.NodeChildren, 'Type','Axes');
set([ax.YLabel],'Rotation',90,'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom', 'FontSize', 16, 'Interpreter','latex')

rvcprint('subfig', 'a', 'thicken', 1, 'nobgfix')
mean(sd) / max(sd)

%%
[s,sd,sdd] = quinticpolytraj([0 1], [0 1], t, 'VelocityBoundaryCondition', [10 0]);

plotsargs = {'.-', 'Markersize', 16};
h = stackedplot(t, [s' sd' sdd'], plotsargs{:}, 'DisplayLabels',  ["$q$" "$\dot{q}$" "$\ddot{q}$"])
grid on
xlabel('t (seconds)')
ax = findobj(h.NodeChildren, 'Type','Axes');
set([ax.YLabel],'Rotation',90,'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom', 'FontSize', 16, 'Interpreter','latex')

rvcprint('subfig', 'b', 'thicken', 1, 'nobgfix')