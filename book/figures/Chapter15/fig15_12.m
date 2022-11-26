% Chaumette conundrum

close all

%% 1 rad
ibvs = IBVS(cam, 'pose0', trvec2tform([0,0,-1])*tformrz(1), 'pstar', pStar);
ibvs.run()

ibvs.plot_p();
for l=get(gca, 'Children')'
    if strcmp(l.LineStyle, '-')
        l.LineWidth = 1.5;
    end
end
rvcprint('subfig', 'a')


ibvs.plot_camera();
l = findobj('type', 'legend');
l(1).FontSize = 10;
l(2).FontSize = 10;
rvcprint('subfig', 'b', 'thicken', 1.5)

%% pi rad
ibvs = IBVS(cam, 'pose0',  trvec2tform([0,0,-1])*tformrz(pi), ...
    'pstar', pStar, 'niter', 10);
ibvs.run()

ibvs.plot_p();
for l=get(gca, 'Children')'
    if strcmp(l.LineStyle, '-')
        l.LineWidth = 1.5;
    end
end
rvcprint('subfig', 'c')

ibvs.plot_camera();
l = findobj('type', 'legend');
l(1).FontSize = 10;
l(2).FontSize = 10;

xaxis(1,10, 'all')

rvcprint('subfig', 'd', 'thicken', 1.5)