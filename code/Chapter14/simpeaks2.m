function simpeaks2(DSI, u, v)
    clf
    plot(squeeze(DSI(v,u,:)), '-o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'MarkerSize', 6);
    yaxis([-1 1])
    grid
    xlabel('Disparity $d - d_{min}$ (pixels)', 'Interpreter', 'LaTeX');
    ylabel('NCC similarity');
    text(5, -0.9, sprintf('pixel at (%d,%d)', u, v), 'FontSize', 11);
