ev = EarthView()


im = ev.grab(-27.475722,153.0285, 17);
idisp(im, 'nogui');
rvcprint('subfig', 'a', 'svg');


im = ev.grab(-27.475722,153.0285, 15, 'roads');
idisp(im, 'nogui');
rvcprint('subfig', 'b', 'svg');