    %%
    im = testpattern('squares', 256, 256, 128);
    im = irotate(im, -0.3);
    edges = icanny(im) > 0;
    idisp(edges, 'nogui', 'black', 0.3);
    rvcprint('subfig', 'a', 'svg')
    
    %%
    dx = bwdist(edges, 'euclidean');
    idisp(dx, 'plain')
    cb = colorbar();
    cb.Label.String = 'Euclidean distance (pixels)';
    cb.Label.FontSize = 12;
    
    corners = [-1 -1; 1 -1; 1 1; -1 1; -1 -1]' ;

    corners = corners*64 + 128;
    hold on
    plot2(corners', 'r')
    
    rvcprint('subfig', 'b', 'thicken', 1.5, 'opengl')
    
    clf
    surf(dx,dx)
    shading interp
    colormap(parula)
    view(-10, 48)
    hold on
    plot2([corners; 20 20 20 20 20]', 'r')
    xlabel('u (pixels)')
    ylabel('v (pixels)')
    zlabel('Euclidean distance (pixels)')
    
   rvcprint('subfig', 'c', 'thicken', 1.5, 'opengl')