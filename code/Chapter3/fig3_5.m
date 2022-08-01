via = SO2(30, 'deg') * [-1 1 1 -1 -1; 1 1 -1 -1 1]
% q0 = mstraj(via(:,[2 3 4 1])', [2,1], [], via(:,1)', 0.2, 0);

% [q,qd,~,t,pp] = trapveltraj(via, 100, 'EndTime', 5);
% [q,qd,~,t,pp] = trapveltraj(via, 100, 'PeakVelocity', 10);
% for pv = [0.1 0.5 1 2 5 10]
%     pv
%     clear q qd
%     [q,qd,~,t,pp] = trapveltraj(via, 100, PeakVelocity=[pv pv]');
%     pause(2)
% 
% max(t)
% 
% clf
% plotpoint(via(:,2:end), 'sequence', 'solid', 'ko', 'MarkerSize', 20)
% hold on
% plot(q(1,:), q(2,:), '.-', 'MarkerSize', 18, 'LineWidth', 2)
% axis equal; grid on; xlabel('q_1'); ylabel('q_2')
% end

clf
hold on
[q,qd,~,t,pp] = trapveltraj(via, 100, EndTime=5, AccelTime=2);
plot(q(1,:), q(2,:), 'b.-', 'MarkerSize', 20, 'LineWidth', 2)

plotpoint(via, 'solid', 'ko', 'label', {'  1, 5', '  2', '  3', '  4', ''}, 'MarkerSize', 10)

axis equal; grid on; xlabel('q_1'); ylabel('q_2')
legend('trajectory', 'via points')

rvcprint('subfig', 'a')


%%
clf
hold on


b = pp{1}.breaks
%b = b(2:end);

plot(t, q, '.-', 'MarkerSize', 18, 'LineWidth', 2);
xlabel('Time (s)'); ylabel('q_1, q_2');
grid on

hold on
lims = get(gca, 'YLim');
for i=1:floor(length(b)/3)
    tt = b(i*3-2:i*3);
    if tt(1) < 0
        tt(1) = 0
    end
    plot([tt(2) tt(2)], lims, 'k', 'LineWidth', 2,'HandleVisibility','off');
    plot_box(tt(1), lims(1), tt(3), lims(2), fillcolor=0.9*[1 1 1], HandleVisibility='off');
end

chi=get(gca, 'Children')
%Reverse the stacking order so that the patch overlays the line
set(gca, 'Children',flipud(chi))

% for i=1:length(b)
%     tt = b(i);
%     lims = get(gca, 'YLim');
%     if mod(i - 1, 3) == 0
%         plot([tt tt], lims, 'k', 'LineWidth', 2);
%     else
%         plot([tt tt], lims, 'k--');
%     end
% end
set(gca, 'XLim', [0 max(t)])
legend('q_1', 'q_2');

Ax = gca;
Ax.YGrid = 'on';
Ax.Layer = 'top';
Ax.GridAlpha = 0.5;
rvcprint('subfig', 'b')
