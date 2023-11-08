% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

% show locus
figure;
[r,g] = lambda2rg( [400:700]*1e-9 );
plot(r, g)
rg_addticks
hold on

% show and label primaries
prim = lambda2rg(cie_primaries);

plotpoly( prim', '--k')
plot(prim(1,1), prim(1,2), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 12);
plot(prim(2,1), prim(2,2), 'ko', 'MarkerFaceColor', 'g', 'MarkerSize', 12);
plot(prim(3,1), prim(3,2), 'ko', 'MarkerFaceColor', 'b', 'MarkerSize', 12);
text(prim(1,1), prim(1,2), '  R', 'FontSize', 12);
text(prim(2,1), prim(2,2), '  G', 'FontSize', 12);
text(prim(3,1), prim(3,2)-0.06, '  B', 'FontSize', 12);

xlabel('r');
ylabel('g');
grid on