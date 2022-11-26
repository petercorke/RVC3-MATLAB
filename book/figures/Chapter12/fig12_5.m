clf
subplot(221)
im = testpattern('rampx', 256, 2);
idisp(im, 'plain', 'here');

subplot(222)
im = testpattern('siny', 256, 2);
idisp(im, 'plain', 'here');

subplot(223)
im = testpattern('squares', 256, 50, 25);
idisp(im, 'plain', 'here');

subplot(224)
im = testpattern('dots', 256, 256, 100);
idisp(im, 'plain', 'here');

rvcprint('subfig', 'a', 'svg');


canvas = zeros(1000, 1000);
sq1 = 0.5 * ones(150, 150);
sq2 = 0.9 * ones(80, 80);
canvas = ipaste(canvas, sq1, [100 100]);
canvas = ipaste(canvas, sq2, [300 300]);
circle = 0.6 * kcircle(120);
size(circle)
canvas = ipaste(canvas, circle, [600, 200]);
canvas = iline( canvas, [100 100], [800 800], 0.8);
idisp(canvas, 'nogui', 'black', 0.2)

rvcprint('subfig', 'b', 'svg');
