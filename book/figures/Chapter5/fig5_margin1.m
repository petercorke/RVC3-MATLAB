close all; clear;

rng(0)
sites = rand(10,2)
voronoi(sites(:,1), sites(:,2))
plotpoint(sites, 'ko', 'MarkerSize', 10, 'solid')
rvcprint('nogrid')