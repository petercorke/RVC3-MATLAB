
g = UGraph(2)
rng(10)
for i=1:5
   g.add_node(rand(2,1));
end
g
g.add_edge(1, 2);
g.add_edge(1, 3);
g.add_edge(1, 4);
g.add_edge(2, 3);
g.add_edge(2, 4);
g.add_edge(4, 5);
g

clf
g.plot('labels')
xlabel('x'); ylabel('y');
rvcprint('here')

g.neighbors(2)
e = g.edges(2)
g.cost(e)
g.nodes(5)'
[n,c] = g.neighbors(2)

g.closest([0.5, 0.5])

g.path_Astar(3, 5)

