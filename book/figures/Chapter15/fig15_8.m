close all
cam = CentralCamera('default');
P = mkgrid( 2, 0.5, 'T', trvec2tform([0,0,3]) );
pd = 200*[-1 -1 1 1; -1 1 1 -1] + cam.pp';
Tc0 = trvec2tform([1,1,-3]) * tformrz(0.6);
% Tc0 = trvec2tform([0,0,-3]) * tformrz(0);

ibvs = IBVS(cam, 'pose0', Tc0, 'pstar', pd, 'verbose', true)
ibvs.run(40);

ibvs.plot_p();
for l=get(gca, 'Children')'
    if strcmp(l.LineStyle, '-')
        l.LineWidth = 1.5;
    end
end
rvcprint('subfig', 'a')

ibvs.plot_vel();
l = findobj('type', 'legend');
l.FontSize = 10;
rvcprint('subfig', 'b', 'thicken', 1.5)

ibvs.plot_camera();
l = findobj('type', 'legend');
l(1).FontSize = 10;
l(2).FontSize = 10;
rvcprint('subfig', 'c', 'thicken', 1.5)

ibvs.plot_jcond();
rvcprint('subfig', 'd', 'thicken', 1.5)
