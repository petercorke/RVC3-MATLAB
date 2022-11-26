clf

DSI2 = DSI;
DSI2(isnan(DSI2)) = 0;

slice(DSI2, [], [100 200 300 400 500], [])
view(-52,18)
shading interp

h = colorbar
h.Label.String = 'ZNCC similarity';
h.Label.FontSize = 10;

xlabel('u (pixels)'); ylabel('v (pixels)'); zlabel('d (pixels)')

% DSI(1,:,:) = 0;
% DSI(end,:,:) = 0;
% DSI(:,1,:) = 0;
% DSI(:,end,:) = 0;

% put frames around the slices
[nr,nc,nd] = size(DSI);
hold on
for v=[100 200 300 400 500]
    plot3([1 nc nc 1 1 ], v*[1 1 1 1 1], [1 1 nd nd 1], 'b', 'LineWidth', 1.5)
end
colormap(parula)

rvcprint('opengl')
