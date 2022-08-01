
idisp(d, 'nogui')

for i=1:1000
    f1
    [u,v] = ginput(1);
    if isempty(u)
        break;
    end
    u = round(u); v = round(v);
    [u v]
    f2
    plot(squeeze(DSI(v,u,:)), '-o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'MarkerSize', 8);
    yaxis([-1 1])
    grid
    xlabel('disparity-d_{min} (pixels)');
    ylabel('NCC similarity');
end
