%% Fig 10.20

wedge = [0:0.1:1];
clf
idisp(wedge, 'nogui', 'xydata', {wedge, [0 0.1]})
xlabel(''); ylabel('');
set(gca, 'YTick', [])
daspect([1 1.5 1])

rvcprint3('fig10_20')
