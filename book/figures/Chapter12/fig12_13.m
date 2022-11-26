mona = iread('monalisa.png', 'double', 'grey');
idisp(mona, 'nogui')
rvcprint('subfig', 'a', 'svg');

K = ones(21,21) / 21^2;
idisp( iconv(K, mona), 'nogui' );
rvcprint('subfig', 'b', 'svg');

K = kgauss(5);
idisp( iconv(K, mona), 'nogui')
rvcprint('subfig', 'c', 'svg');