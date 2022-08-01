im = iread('lena.pgm', 'double');
[G,L] = iscalespace(im, 8, 8);
idisp(G,  'flatten', 'wide', 'square');
idisp(G, 'flatten', 'wide', 'square', 'plain');
rvcprint('subfig', 'a', 'nogrid')

idisp(L, 'flatten', 'wide', 'square', 'invsigned', 'plain');
rvcprint('subfig', 'b', 'nogrid')
