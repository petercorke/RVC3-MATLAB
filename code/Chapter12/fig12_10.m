person = iread('greenscreen.jpg', 'double');
clf
idisp(person, 'nogui')
rvcprint('subfig', 'a', 'svg')

linear = igamm(person, 'sRGB');
[r,g] = tristim2cc(linear);
ihist(g, 'g')
xlabel('Chromaticity (g)');
vertline(0.45)
rvcprint('subfig', 'b')

mask = g < 0.45;
idisp(mask, 'nogui', 'black', 0.2)
rvcprint('subfig', 'c', 'svg')

mask3 = icolor( idouble(mask) );
idisp(mask3 .* person);
bg = iread('road.png', 'double');
bg = isamesize(bg, person);
idisp(bg .* (1-mask3))
idisp( person.*mask3  + bg.*(1-mask3), 'nogui' );
rvcprint('subfig', 'd', 'svg')
