[word,f] = bag.wordfreq()
bar( sort(f, 'descend'), 'b' )
xaxis(2000)
xlabel('Visual word label');
ylabel('Number of occurrences');

rvcprint