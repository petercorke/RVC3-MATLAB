via = SO2(30, 'deg') * [-1 1 1 -1 -1; 1 1 -1 -1 1]


clf
hold on
[q, qd, qdd, ~, ~, ~, t] = minjerkpolytraj(via, [0 1 2 3 4], 100)

plot(q(1,:), q(2,:), 'b.-', 'MarkerSize', 20, 'LineWidth', 2)

plotpoint(via, 'solid', 'ko', 'label', {'  1, 5', '  2', '  3', '  4', ''}, 'MarkerSize', 10)

axis equal; grid on; xlabel('q_1'); ylabel('q_2')
legend('trajectory', 'via points')

rvcprint('subfig', 'a')


%%
clf
hold on

plot(t, q', '.-', 'LineWidth', 1, 'MarkerSize', 22)
set(gca, 'XLim', [0 max(t)])
legend('q_1', 'q_2');
rvcprint('subfig', 'b')
