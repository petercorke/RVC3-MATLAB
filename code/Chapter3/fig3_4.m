clf

x = trapveltraj([0 1; 2 -1], 50, 'EndTime', 1);
plot(x', '.-', 'MarkerSize', 22, 'LineWidth', 2); legend('q_1', 'q_2'); xlabel('t (seconds)'); ylabel('q'); 
grid on

% rvcprint