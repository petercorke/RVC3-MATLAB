close all

pStar = 200*[-1 -1 1 1; -1 1 1 -1] + cam.pp';

ibvs = IBVS(cam, 'pose0', Tc0, 'pstar', pStar, 'depth', 1)
ibvs.run(60)
ibvs.plot_p();
for l=get(gca, 'Children')'
    if strcmp(l.LineStyle, '-')
        l.LineWidth = 1.5;
    end
end
rvcprint('subfig', 'a')

ibvs.plot_vel();
l = findobj(gcf, 'type', 'legend');
l.FontSize = 10;
rvcprint('subfig', 'b', 'thicken', 1.5)

ibvs = IBVS(cam, 'pose0', Tc0, 'pstar', pStar, 'depth', 10)
ibvs.run(20)
ibvs.plot_p();
for l=get(gca, 'Children')'
    if strcmp(l.LineStyle, '-')
        l.LineWidth = 1.5;
    end
end
rvcprint('subfig', 'c')

ibvs.plot_vel();
l = findobj(gcf, 'type', 'legend');
l.FontSize = 10;
rvcprint('subfig', 'd', 'thicken', 1.5)