church = iread('church.png', 'grey');
im = church;
clf
g = uint8(0:255);

idisp(im, 'plain')
rvcprint('subfig', 'a', 'nogrid');

%% threshold
clf
idisp(im>180, 'plain')
pos = get(gca, 'Position');
axes('Position', [pos(1)-0.01 pos(2)+0.05 0.2 0.2])
plot(g, g>180, 'r', 'LineWidth', 2)
xaxis(0, 255, gca); yaxis(0, 1.05, gca)
rvcprint('subfig', 'b', 'nogrid', 'nobgfix');

%% histo equalization
clf
n = ihist(im, 'cdf');
idisp(inormhist(im), 'plain')
pos = get(gca, 'Position');
axes('Position', [pos(1)-0.01 pos(2)+0.05 0.2 0.2])
plot(0:255, n/max(n)*255, 'r', 'LineWidth', 2)
xaxis(0, 255, gca); yaxis(0, 260, gca)
rvcprint('subfig', 'c', 'nogrid', 'nobgfix');

%% gamma
clf
idisp(igamm(im, 1/0.45), 'plain')
pos = get(gca, 'Position');
axes('Position', [pos(1)-0.01 pos(2)+0.05 0.2 0.2])
plot(g, igamm(g, 1/0.45), 'r', 'LineWidth', 2)
xaxis(0, 255, gca); yaxis(0, 260, gca)
rvcprint('subfig', 'd', 'nogrid', 'nobgfix');

%% brighten + clip
clf
idisp(im+100, 'plain')
pos = get(gca, 'Position');
axes('Position', [pos(1)-0.01 pos(2)+0.05 0.2 0.2])
plot(g, g+100, 'r', 'LineWidth', 2)
xaxis(0, 255, gca); yaxis(0, 260, gca)
rvcprint('subfig', 'e', 'nogrid', 'nobgfix');

%% posterize
clf
idisp(im/64, 'plain')
pos = get(gca, 'Position');
axes('Position', [pos(1)-0.01 pos(2)+0.05 0.2 0.2])
plot(g, g/64, 'r', 'LineWidth', 2)
xaxis(0, 255, gca); yaxis(0, 4.1, gca)
rvcprint('subfig', 'f', 'nogrid', 'nobgfix');

% subplot(321)
% idisp(im, 'plain', 'here')
% 
% subplot(322)
% idisp(im>140, 'plain', 'here')
% 
% subplot(323)
% idisp(inormhist(im), 'plain', 'here')
% 
% subplot(324)
% idisp(255-im, 'plain', 'here')
% 
% subplot(325)
% idisp(im+100, 'plain', 'here')
% 
% subplot(326)
% idisp(im/64, 'plain', 'here')
