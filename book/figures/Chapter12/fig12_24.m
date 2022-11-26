lena = iread('lena.png', 'double', 'grey');

randinit
spotty = lena;
npix = prod(size(lena));
spotty(round(rand(5000,1)*(npix-1)+1)) = 0;
spotty(round(rand(5000,1)*(npix-1)+1)) = 1.0;
idisp(spotty, 'nogui')
rvcprint('subfig', 'a', 'svg')

idisp( irank(spotty, 5, 1), 'nogui' )
rvcprint('subfig', 'b', 'svg')
