rng(0)
x = 2*randn(1000000,1) + 5;

y = (x+2).^2 / 4;

close all


% ypdf = histogram(y, 'Normalization', 'pdf');
% figure

[ypdf, bin] = hist(y, 100);
ypdf = ypdf / sum(ypdf);

%%
x = linspace(-10, 50, 200);
px = gaussfunc(0, 4, x-5);
% px = max(ypdf.Values) / max(px) * px;
plot(x, px, 'r')
hold on
% plot(ypdf.BinEdges(1:end-1)+ypdf.BinWidth, ypdf.Values, 'k');
plot(bin, ypdf, 'k')
grid

lims = axis();
plot(mean(y)*[1 1], lims(3:4), 'b--')
std(y)
xlabel('x');
ylabel('PDF')
legend('$x=N(\mu=2, \sigma=2)$', '$y =(x+2)^2/4$', '$\bar{y}$', Interpreter='latex')
xlim([-5, 40])
rvcprint('here', 'thicken', 1.5)