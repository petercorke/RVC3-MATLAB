mdl_puma560
sl_opspace
r = sim('sl_opspace');

t = r.find('t');
y = r.find('y');

figure
subplot(3,1,[1 2])
oplot(t, y(:,1:3));
xlabel('Time (s)');
ylabel('Position (m)');
l = legend('x', 'y', 'z');
set(l, 'FontSize', 12);
[~,k] = min(abs(y(:,3)+0.2));
thit = t(k);
vertline(thit)

subplot(3,1, 3);
oplot(t, y(:,6));
xlabel('Time (s)');
ylabel('$F_z$ (N)', 'interpreter', 'latex');
vertline(thit)

rvcprint('thicken', 1.5)