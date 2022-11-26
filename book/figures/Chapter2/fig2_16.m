clf
hold on

tformplot( trotx(0), 'noarrow' )                             
rotate([1 0 0], [0 -1 0], -0.5, 0.2, 120, '\pi/2', [0 0 0])

tformplot( transl(2,0,0)*trotx(pi/2), 'noarrow' )            
rotate([0 0 1], [0 -1 0], -0.5, 0.2, 120, '\pi/2', [2 0 0])

tformplot( transl(4,0,0)*trotx(pi/2)*troty(pi/2), 'noarrow' )

grid off
daspect([1 1 1])
set(gca, 'visible', 'off')
view(10, 12)

rvcprint('subfig', 'a')

clf
hold on
tformplot( trotx(0), 'noarrow' )                             
rotate([0 1 0], [0 0 1], -0.8, 0.2, 120, '\pi/2', [0 0 0])

tformplot( transl(2,0,0)*troty(pi/2), 'noarrow' )            
rotate([0 0 -1], [0 -1 0], -0.8, 0.2, 120, '\pi/2', [2 0 0])

tformplot( transl(4,0,0)*troty(pi/2)*trotx(pi/2), 'noarrow' )

grid off
daspect([1 1 1])
set(gca, 'visible', 'off')
view(10, 12)

rvcprint('subfig', 'b')