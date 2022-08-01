bag.remove_stop(50)
bag
M = bag.wordvector;
S = bag.similarity(bag)
idisp(S, 'nogui'); 
xlabel('Image index'); ylabel('Image index'); 
h = colorbar
%% 
h.Label.String = 'Similarity';
h.Label.FontSize = 12;

rvcprint('eps', 'opengl')