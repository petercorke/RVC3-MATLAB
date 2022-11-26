objects = iread('segmentation.png');
idisp(objects, 'nogui', 'invert');
rvcprint('subfig', 'a', 'svg')

S = kcircle(3)
closed = iclose(objects, S);
idisp( closed, 'nogui', 'invert');
rvcprint('subfig', 'b', 'svg')


clean = iopen(closed, S);
idisp(clean, 'nogui', 'invert');
rvcprint('subfig', 'c', 'svg')

opened = iopen(objects, S);
closed = iclose(opened, S);
idisp(opened, 'nogui', 'invert');
rvcprint('subfig', 'd', 'svg')

