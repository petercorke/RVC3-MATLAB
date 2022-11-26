pbvs.run(100);

pbvs.plot_p();
for l=get(gca, 'Children')'
    if strcmp(l.LineStyle, '-')
        l.LineWidth = 1.5;
    end
end
rvcprint('subfig', 'a')

pbvs.plot_vel();
l = findobj(gcf, 'type', 'legend');
l.FontSize = 10;
rvcprint('subfig', 'b', 'thicken', 1.5)

pbvs.plot_camera();
l = findobj(gcf, 'type', 'legend');
l(1).FontSize = 10;
l(2).FontSize = 10;

rvcprint('subfig', 'c', 'thicken', 1.5)
