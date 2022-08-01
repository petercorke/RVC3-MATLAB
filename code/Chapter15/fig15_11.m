close all
cam = CentralCamera("default");
Tc0 = trvec2tform([1,1,-3]) * tformrz(0.6);
%%
TcStar_t = trvec2tform([0, 0, 1]);
pbvs = PBVS(cam, 'pose0', Tc0, 'posef', TcStar_t, 'axis', [-1 2 -1 2 -3 0.5])
pbvs.T0 = trvec2tform([-2.1, 0, -3])*tformrz(5*pi/4);
% pbvs.run()
% clf
% pbvs.plot_p()
% for l=get(gca, 'Children')'
%     if strcmp(l.LineStyle, '-')
%         l.LineWidth = 1.5;
%     end
% end
% rvcprint('subfig', 'a')

%%
pd = 200*[-1 -1;-1 1;1 1;1 -1] + cam.pp
ibvs = IBVS(cam, 'pose0', pbvs.T0, 'p_d', pd, 'lambda', 0.008, 'niter', Inf, 'eterm', 5, verbose=true)
ibvs.run()
clf
ibvs.plot_p();
for l=get(gca, 'Children')'
    if strcmp(l.LineStyle, '-')
        l.LineWidth = 1.5;
    end
end
%rvcprint('subfig', 'b')