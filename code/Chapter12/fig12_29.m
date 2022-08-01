eroded = imorph(clean, kcircle(1), 'min');
idisp(clean-eroded,'nogui', 'invert');

rvcprint('svg')