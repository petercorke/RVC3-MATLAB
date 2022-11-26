%%
im = iread('sharks.png');
fv = iblobs( im, 'boundary', 'class', 1)

[r,th] = fv(2).boundary;
clf
plot([r th])
h = plotyy(1:400, r, 1:400, th)
ylabel(h(1), 'radius (pixels)');
ylabel(h(2), 'angle (radians)');
xlabel('perimeter index')
rvcprint('subfig', 'a', 'thicken', 2)

%%
clf
hold on
for i=1:4
    f = fv(i);
    [r,t] = f.boundary();
    if i == 1
    plot(r/sum(r), '--')
    else
        plot(r/sum(r));
    end
end
ylabel('normalized radius');
xlabel('perimeter index')

rvcprint('subfig', 'b', 'thicken', 2)
