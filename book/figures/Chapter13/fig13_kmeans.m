randinit

a = rand(2, 500);

[cls, centre, r] = kmeans(a, 3);

r

clf
%fmt = {'r.', 'g.', 'b.'}; 
hold on
for i=1:3 plot( a(1,cls==i), a(2,cls==i), '.', 'MarkerSize', 10 ); end
% plot_point(a(:,cls==1), 'r.', 'MarkerSize', 10);
% plot_point(a(:,cls==2), 'g.', 'MarkerSize', 10);
% plot_point(a(:,cls==3), 'b.', 'MarkerSize', 10);

plot_point(centre, 'ok', 'MarkerFaceColor', 'k', 'MarkerSize', 12)
axis equal
xaxis(0,1); yaxis(0,1)
rvcprint