%% Fig 10.12

clf

green_cc = lambda2rg(500e-9);
white_cc = tristim2cc([1 1 1]);

% show locus
[r,g] = lambda2rg( [400:700]*1e-9 );
plot(r, g)
hold on

% show and label primaries
prim = lambda2rg([600, 555, 450]*1e-9);
plot_poly( prim', '--k')
plot(prim(1,1), prim(1,2), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 12);
plot(prim(2,1), prim(2,2), 'ko', 'MarkerFaceColor', 'g', 'MarkerSize', 12);
plot(prim(3,1), prim(3,2), 'ko', 'MarkerFaceColor', 'b', 'MarkerSize', 12);
text(prim(1,1), prim(1,2), '  R''', 'FontSize', 12);
text(prim(2,1), prim(2,2), '  G''', 'FontSize', 12);
text(prim(3,1), prim(3,2)-0.06, '  B''', 'FontSize', 12);

xlabel('r');
ylabel('g');

plot([green_cc(1) white_cc(1)], [green_cc(2) white_cc(2)], 'g')

green_cc = lambda2rg(500e-9);
plot2(green_cc, 'kp', 'MarkerFaceColor', 'g', 'MarkerSize', 10)

white_cc = tristim2cc([1 1 1]);
plot2(white_cc, 'ko', 'MarkerSize', 9)


green = cmfrgb(500e-9);
w = -min(green);
white = [w w w ];

% feasible green
feasible_green = green + white;
feasible_green_cc = tristim2cc(feasible_green);
plot2(feasible_green_cc, 'ks', 'MarkerFaceColor', 'g', 'MarkerSize', 10)

% gamut boundary 
%  - found by picking coordinates from graph
plot2([0.1229 0.4885], 'kv', 'MarkerFaceColor', 'g', 'MarkerSize', 9)

grid on
rvcprint3('fig10_12', 'thicken', 1.5)
