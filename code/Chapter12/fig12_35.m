mona = iread('monalisa.png', 'grey', 'double');
p = ipyramid(mona);
w = 0;
for i=1:length(p)
    w = w + size(p{i},2);
end
im = 0.3*ones(size(p{1},1), w);
u = 1;
for i=1:length(p)
    [nr,nc] = size(p{i});
    im(1:nr,u:u+nc-1) = p{i};
    u = u + nc;
end
idisp(im, 'square', 'nogui');
rvcprint('svg')