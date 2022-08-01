roof = iread('roof.jpg', 'grey');
about(roof)
idisp(roof, 'nogui')
rvcprint('subfig', 'a', 'svg')

smaller = roof(1:7:end,1:7:end);
idisp(smaller, 'nogui')
rvcprint('subfig', 'b', 'svg')

smaller =  idecimate(roof, 7);
idisp(smaller, 'nogui')
rvcprint('subfig', 'c', 'svg')

bigger = ireplicate( smaller, 7 );
idisp(bigger, 'nogui')
rvcprint('subfig', 'd', 'svg')