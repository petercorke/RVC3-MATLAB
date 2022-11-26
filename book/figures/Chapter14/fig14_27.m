%%

%{
L = iread('rocks2-l.png', 'reduce', 2);
R = iread('rocks2-r.png', 'reduce', 2);
%}

[d,sim] = istereo(L, R, [40 90], 3);
sim(isnan(sim)) = Inf;
idisp(sim, 'nogui')

c=colormap;
c=[c; 1 0 0];
colormap(c)

h = colorbar;
h.Label.String = 'ZNCC similarity';
h.Label.FontSize = 10;
rvcprint('subfig', 'a', 'svg')

%%
z = ipixswitch(isinf(sim), 'red', d/90);
z = ipixswitch(sim<0.7, 'yellow', z);
idisp(z, 'nogui')
rvcprint('subfig', 'b', 'svg')