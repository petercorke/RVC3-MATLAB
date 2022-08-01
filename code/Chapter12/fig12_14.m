clf

h = 15;

K = kgauss(5);
idisp( K, 'nogui' );
rvcprint('subfig', 'a', 'svg')

surf(-h:h, -h:h, K, K);  colormap(jet); shading faceted; set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
invsignedmap(K)
rvcprint('subfig', 'b')

K = kcircle(8, 15);
surf(-h:h, -h:h, K, K);  colormap(jet); shading faceted; set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
invsignedmap(K)
rvcprint('subfig', 'c')

K = kdgauss(5);
surf(-h:h, -h:h, K, K);  colormap(jet); shading faceted; set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
invsignedmap(K)
rvcprint('subfig', 'd')

K = klog(5);
surf(-h:h, -h:h, K, K);  colormap(jet); shading faceted; set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
invsignedmap(K)
rvcprint('subfig', 'e')

K = kdog(4, 4*1.6, 15);
surf(-h:h, -h:h, K, K);  colormap(jet); shading faceted; set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
invsignedmap(K)
rvcprint('subfig', 'f')
