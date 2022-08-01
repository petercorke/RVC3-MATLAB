% runr 15_8 first

ibvs = IBVS(cam, 'pose0', Tc0, 'pstar', pd, 'depthest')
ibvs.run()
ibvs.plot_p();
for l=get(gca, 'Children')'
    if strcmp(l.LineStyle, '-')
        l.LineWidth = 1.5;
    end
end
rvcprint('subfig', 'a')

ibvs.plot_z();
l = legend({'$Z_1$','$Z_2$', '$Z_3$', '$Z_4$', '$\hat{Z}_1$', '$\hat{Z}_2$', '$\hat{Z}_3$', '$\hat{Z}_4$'}, 'Interpreter', 'latex')
l.FontSize = 12;
rvcprint('subfig', 'b', 'thicken', 1.5)