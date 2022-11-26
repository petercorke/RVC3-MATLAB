
s = S(:,11);
[z,k] = sort(s, 'descend');
[z k]
idisp(images(:,:,11), 'nogui');
text(50, 400, 'image #11', 'FontSize', 22, 'Color', 'w')

rvcprint('subfig', 'a', 'svg')

idisp(images(:,:,13), 'nogui');
text(50, 400, 'image #13', 'FontSize', 22, 'Color', 'w')
rvcprint('subfig', 'b', 'svg')

idisp(images(:,:,9), 'nogui');
text(50, 400, 'image #9', 'FontSize', 22, 'Color', 'w')
rvcprint('subfig', 'c', 'svg')

idisp(images(:,:,12), 'nogui');
text(50, 400, 'image #12', 'FontSize', 22, 'Color', 'w')
rvcprint('subfig', 'd', 'svg')
