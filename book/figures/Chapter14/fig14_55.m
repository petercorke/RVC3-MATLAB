images2 = iread('campus/holdout/*.jpg', 'mono');
sf2 = isurf(images2, 'thresh', 0)
sf2 = [sf2{:}]
bag2 = BagOfWords(sf2, bag)
S2 = bag.similarity(bag2);
[z,i] = max(S2)

% first recall test
idisp(images2(:,:,1), 'nogui');
text(50, 400, 'test #1', 'FontSize', 22, 'Color', 'w')
rvcprint('subfig', 'a', 'svg')

idisp(images(:,:,i(1)), 'nogui');
text(50, 400, sprintf('recall image #%d', i(1)), 'FontSize', 22, 'Color', 'w')
rvcprint('subfig', 'b', 'svg')

% second recall test
idisp(images2(:,:,2), 'nogui');
text(50, 400, 'test #2', 'FontSize', 22, 'Color', 'w')
rvcprint('subfig', 'c', 'svg')

idisp(images(:,:,i(2)), 'nogui');
text(50, 400, sprintf('recall image #%d', i(2)), 'FontSize', 22, 'Color', 'w')
rvcprint('subfig', 'd', 'svg')