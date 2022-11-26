b1 = iread('building2-1.png', 'grey', 'double');
% get all features

sf1 = isurf(b1)

% get the histogram of scales
%[n,x] = hist(sf1.scale, 50)


% plot it with log axis
clf
histogram(sf1.scale, 'EdgeColor', 'none')

% bar(x, n, 'b')
set(gca, 'yscale', 'log')

% make a finite mark for n==1
% hold on
% k= n==1;
% plot(x(k), n(k), '.b')
xlabel('Scale'); 
ylabel('Number of occurrences'); 
%set(gca, 'Yminorgrid', 'off')

rvcprint