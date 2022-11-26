[s,sd,sdd,t] = trapveltraj([0 1], 50, 'EndTime', 1);

plotsargs = {'.-', 'Markersize', 16};
h = stackedplot(t, [s' sd' sdd'], plotsargs{:}, 'DisplayLabels',  ["$q$" "$\dot{q}$" "$\ddot{q}$"])
grid on
xlabel('t (seconds)')
ax = findobj(h.NodeChildren, 'Type','Axes');
set([ax.YLabel],'Rotation',90,'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom', 'FontSize', 16, 'Interpreter','latex')

max(sd)

rvcprint('subfig', 'a', 'thicken', 1, 'nobgfix')
% 
%% 
[s,sd,sdd,t] = trapveltraj([0 1], 50, 'EndTime', 1);
[s2, sd2,sdd2] = trapveltraj([0 1], 50, 'PeakVelocity', 1.2, 'EndTime', 1);
[s3,sd3,sdd3] = trapveltraj([0 1], 50, 'PeakVelocity', 2, 'EndTime', 1);


t = table(t', s', sd', sdd', s2', sd2', sdd2', s3', sd3', sdd3', 'VariableNames', {'t', 'q', 'qd', 'qdd', 'q2', 'qd2', 'qdd2', 'q3', 'qd3', 'qdd3'});

h = stackedplot(t, {{'q', 'q2', 'q3'}, {'qd', 'qd2', 'qd3'}, {'qdd', 'qdd2', 'qdd3'}}, plotsargs{:}, 'XVariable', 't', 'DisplayLabels',  ["$q$" "$\dot{q}$" "$\ddot{q}$"])
h.AxesProperties(1).LegendLabels = {'nominal', '1.2', '2'}
h.AxesProperties(1).LegendLocation = 'southeast'
h.AxesProperties(2).LegendLabels = {'nominal', '1.2', '2'}
h.AxesProperties(2).LegendLocation = 'northeast'
h.AxesProperties(3).LegendLabels = {'nominal', '1.2', '2'}
h.AxesProperties(3).LegendLocation = 'northeast'

grid on
xlabel('t (seconds)')
ax = findobj(h.NodeChildren, 'Type','Axes');
set([ax.YLabel],'Rotation',90,'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom', 'FontSize', 16, 'Interpreter','latex')

% 
rvcprint('subfig', 'b', 'thicken', 1, 'nobgfix')