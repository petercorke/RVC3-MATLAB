%UGraph An Undirected Embedded Graph
%
%   g = UGraph()        create a 2D, planar embedded, undirected graph
%   g = UGraph(n)       create an n-d, embedded, undirected graph
%
% Provides support for graphs that:
%   - are undirected
%   - are embedded in a coordinate system (2D or 3D)
%   - have multiple unconnected components
%   - have symmetric cost edges (A to B is same cost as B to A)
%   - have no loops (edges from A to A)
%
% Graph representation:
%   - nodes are represented by integer node ids (vid)
%   - edges are represented by integer edge ids (eid)
%   - each node can have arbitrary associated data
%   - each edge can have arbitrary associated data
%
% Methods::
%
% Constructing the graph::
%   g.add_node(coord)      add node
%   g.add_edge(v1, v2)     add edge between nodes
%   g.setcost(e, c)        set cost for edge
%   g.setedata(e, u)       set user data for edge
%   g.setvdata(v, u)       set user data for node
%
% Modifying the graph::
%   g.clear()              remove all nodes and edges from the graph
%   g.delete_edge(e)       remove edge
%   g.delete_node(v)       remove node
%   g.setcoord(v)          set coordinate of node
%
% Information from graph::
%   g.about()                   summary information about node
%   g.component(v)              component id for node
%   g.componentnodes(c)         nodes in component
%   g.connectivity()            number of edges for all nodes
%   g.coord(v)                  coordinate of node
%   g.cost(e)                   cost of edge
%   g.degree(v)                 degree of node
%   g.distance_metric(v1,v2)    distance between nodes
%   g.edata(e)                  get edge user data
%   g.edges(v)                  list of edges for node
%   g.edges_out(v)              list of edges from node
%   g.lookup(name)              node ID from node name
%   g.name(v)                   node name from node ID
%   g.neighbors(v)              neighbors of node
%   g.samecomponent(v1,v2)      test if nodes in same component
%   g.vdata(v)                  node user data
%   g.nodes(e)                  nodes for edge
%
% Display::
%
%   g.char()                   convert graph to string
%   g.display()                display summary of graph
%   g.highlight_node(v)        highlight node
%   g.highlight_edge(e)        highlight edge
%   g.highlight_path(p)        highlight nodes and edge along path
%   g.pick(coord)              node closest to coord
%   g.plot()                   plot graph
%
%
% Matrix representations::
%   g.adjacency()          adjacency matrix
%   g.degreeMatrix()             degree matrix
%   g.incidence()          incidence matrix
%   g.laplacian()          Laplacian matrix
%
% Planning paths through the graph::
%   g.path_BFS(s, g)       breadth-first search from s to g
%   g.path_UCS(s, g)       uniform cost search from s to g
%   g.path_Astar(s, g)     shortest path from s to g
%
% Graph and world points::
%   g.closest(coord)       node closest to coord
%   g.coord(v)             coordinate of node v
%   g.distance(v1, v2)     distance between v1 and v2
%   g.distances(coord)     return sorted distances from coord to all nodes
%
% Object properties (read only)::
%   g.n            number of nodes
%   g.ne           number of edges
%   g.nc           number of components
%
% Example::
%         g = UGraph();
%         g.add_node([1 2]');  % add node 1
%         g.add_node([3 4]');  % add node 2
%         g.add_node([1 3]');  % add node 3
%         g.add_edge(1, 2);    % add edge 1-2
%         g.add_edge(2, 3);    % add edge 2-3
%         g.add_edge(1, 3);    % add edge 1-3
%         g.plot()
%
% Notes::
% - Support for edge direction is quite simple.
% - The method distance_metric() could be redefined in a subclass.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

classdef UGraph < matlab.mixin.Copyable
    properties
        measure         % distance measure: 'Euclidean', 'SE2'
    end

    properties (SetAccess=private, GetAccess=public)
        graph           % Underlying MATLAB graph object

        goaldist        % distance from goal, after planning

        ndims           % number of coordinate dimensions, height of nodes matrix
        verbose
        dweight         % distance weighting for SE2 measure
    end

    properties (Dependent)
        n               % number of nodes/nodes
        ne              % number of edges
        nc              % number of components
    end

    properties (Access = private)
        % These private properties are maintained automatically when the
        % graph structure changes. These are stored to provide maximum
        % performance for planning algorithms.

        nodelist = []   % node coordinates, columnwise, node number is the column number
        edgelist = []   % 2xN matrix, each column is node index of edge start and end
        names = ""      % node names as string array
        labels = [];    % label of each node (1xN)
        edgelen = [];   % length (cost) of this edge
    end

    methods (Access = private)
        function refresh(g)
            %REFRESH Refresh internal properties (for performance)

            if g.graph.numnodes > 0
                g.nodelist = g.graph.Nodes.Coord';
                g.names = string(g.graph.Nodes.Name);
                g.labels = g.graph.conncomp;
            else
                g.nodelist = [];
                g.names = "";
                g.labels = [];
            end

            if g.graph.numedges > 0
                g.edgelen = g.graph.Edges.Weight';
                [s,t] = g.graph.findedge;
                g.edgelist = [s'; t'];
            else
                g.edgelen = [];
                g.edgelist = [];
            end
        end
    end

    methods

        function g = UGraph(ndims, varargin)
            %UGraph.UGraph Graph class constructor
            %
            % G=UGraph(D, OPTIONS) is a graph object embedded in D dimensions.
            %
            % Options::
            %  'distance',M   Use the distance metric M for path planning which is either
            %                 'Euclidean' (default) or 'SE2'.
            %  'verbose'      Specify verbose operation
            %
            % Notes::
            % - Number of dimensions is not limited to 2 or 3.
            % - The distance metric 'SE2' is the sum of the squares of the difference
            %   in position and angle modulo 2pi.
            % - To use a different distance metric create a subclass of UGraph and
            %   override the method distance_metric().


            if nargin < 1
                ndims = 2;  % planar by default
            elseif isa(ndims, 'UGraph')
                % do a deep copy of input object
                g = ndims.copy();
                return
            end
            g.ndims = ndims;
            opt.distance = 'Euclidean';
            opt.dweight = 1;
            opt = tb_optparse(opt, varargin);

            g.clear();
            g.verbose = opt.verbose;
            g.measure = opt.distance;
            g.dweight = opt.dweight;
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% GRAPH MAINTENANCE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function v = add_node(g, coord, varargin)
            %UGraph.add_node Add a node
            %
            % V = G.add_node(X, OPTIONS) adds a node/node with coordinate X (Dx1) and
            % returns the integer node id V.
            %
            % Options:
            % 'name',N    Assign a string name N to this node
            % 'from',V    Create a directed edge from node V with cost equal to the distance between the nodes.
            % 'cost',C    If an edge is created use cost C
            %
            % Notes::
            % - Distance is computed according to the metric specified in the
            %   constructor.
            %
            % See also UGraph.add_edge, UGraph.data, UGraph.getdata.

            if length(coord) ~= g.ndims
                error('coordinate length different to graph coordinate dimensions');
            end

            opt.from = [];
            opt.name = [];
            opt.cost = NaN;

            opt = tb_optparse(opt, varargin);

            % append the coordinate as a column in the node matrix
            %g.nodelist = [g.nodelist coord(:)];

            % Pick default name if not provided by user
            if isempty(opt.name)
                name = ['Node' num2str(g.n+1)];
            else
                name = opt.name;
            end

            % Add node to graph and return new node ID
            g.graph = g.graph.addnode(table({name}, coord(:)', ...
                'VariableNames', {'Name' 'Coord'}));
            v = g.n;

            if g.verbose
                fprintf('add node (%d) = ', v);
                fprintf('%f ', coord);
                fprintf('\n');
            end

            % optionally add an edge
            if ~isempty(opt.from)
                if isnan(opt.cost)
                    opt.cost = g.distance(v, opt.from);
                end
                g.add_edge(opt.from, v, opt.cost);
            end

            g.refresh();
        end

        function e = add_edge(g, v1, v2, d)
            %UGraph.add_edge Add an edge
            %
            % E = G.add_edge(V1, V2) adds a directed edge from node id V1 to node id V2, and
            % returns the edge id E.  The edge cost is the distance between the nodes.
            %
            % E = G.add_edge(V1, V2, C) as above but the edge cost is C.
            %
            % Notes::
            % - If V2 is a vector add edges from V1 to all elements of V2
            % - Distance is computed according to the metric specified in the
            %   constructor.
            %
            % See also UGraph.add_node, UGraph.edgedir.

            v1num = g.lookup(v1);
            v2num = g.lookup(v2)';

            if g.verbose
                fprintf('add edge %d -> %d\n', v1num, v2num);
            end
            e = [];

            for vv = v2num
                if (nargin < 4) || isempty(d)
                    d = g.distance(v1, vv);
                end

                g.graph = g.graph.addedge(table([v1num vv], d, ...
                    'VariableNames', {'EndNodes' 'Weight'}));
                e = [e g.graph.numedges]; %#ok<AGROW>
            end

            g.refresh();
        end


        function delete_node(g, vv)
            g.graph = g.graph.rmnode(vv);
            g.refresh();
        end

        function delete_edge(g, e)
            g.graph = g.graph.rmedge(e);
            g.refresh();
        end


        function clear(g)
            %UGraph.clear Clear the graph
            %
            % G.clear() removes all nodes, edges and components.

            g.graph = graph; %#ok<CPROP>
            g.refresh();
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% GRAPH STRUCTURE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % which edges contain v
        %  elist = g.edges(v)
        function e = edges(g, v)
            %UGraph.edges Find edges given node
            %
            % E = G.edges(V) is a vector containing the id of all edges connected to node id V.
            %
            % See also UGraph.edgedir.

            v = g.lookup(v);
            e = find(g.edgelist(1,:) == v | g.edgelist(2,:) == v);
        end

        function v = nodes(g, e)
            %UGraph.nodes Find nodes given edge
            %
            % V = G.nodes(E) return the id of the nodes that define edge E.
            v = g.edgelist(:,e);
        end


        function [n,c] = neighbors(g, v)
            %UGraph.neighbors Neighbors of a node
            %
            % N = G.neighbors(V) is a vector of ids for all nodes which are
            % directly connected neighbors of node V.
            %
            % [N,C] = G.neighbors(V) as above but also returns a vector C whose elements
            % are the edge costs of the paths corresponding to the node ids in N.

            n = g.graph.neighbors(v)';

            if nargout > 1
                e = g.edges(v);
                c = g.cost(e);
            end

        end

        function c = connectivity(g,nn)
            %UGraph.connectivity Node connectivity
            %
            % C = G.connectivity() is a vector (Nx1) with the number of edges per
            % node.
            %
            % The average node connectivity is
            %         mean(g.connectivity())
            %
            % and the minimum node connectivity is
            %         min(g.connectivity())

            if nargin == 1
                c = zeros(1, g.n);
                for k=1:g.n
                    c(k) = length(g.edges(k));
                end
            elseif nargin == 2
                c = zeros(1, length(nn));
                for k=1:length(nn)
                    c(k) = length(g.edges(nn(k)));
                end
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% NODE PROPERTIES
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function p = coord(g, v)
            %UGraph.coord Coordinate of node
            %
            % X = G.coord(V) is the coordinate vector (Dx1) of node id V.

            if nargin < 2
                p = g.nodelist;
            else
                p = g.nodelist(:,v);
            end
        end

        function p = name(g, v)
            %UGraph.name Name(s) of node by ID
            %
            % X = G.name(V) is the name (string) of node id V. This works
            % for one or more node IDs as input


            if nargin < 2
                p = [g.names];
            else
                p = g.names(v);
            end
        end

        function p = lookup(g, name)
            %UGraph.lookup Find node ID(s) for node name(s)

            if isnumeric(name)
                % If input is already numeric, return the same value.
                p = name;
                return;
            end

            % Syntax with second output required, so this function works
            % correctly if multiple names are provided.
            [p,~] = find( [g.names] == name );
        end

        function setcoord(g, v, c)
            %UGraph.setcoord Set coordinate of node

            if nargin < 3
                if ~all(size(v) == size(g.nodelist))
                    error('SMTB:UGraph:badarg', 'value must be size of node table');
                end

                % Set all coordinates at once
                g.graph.Nodes.Coord = v';
            else
                g.graph.Nodes.Coord(v,:) = c(:)';
            end

            g.refresh;
        end

        function u = ndata(g, v)
            %UGraph.ndata Get user data for node
            %
            % U = G.ndata(V) gets the user data of node V which can be of any
            % type such as a number, struct, object or cell array.
            %
            % See also UGraph.setdata.

            % Return if no user data is stored yet
            if ~any(contains(g.graph.Nodes.Properties.VariableNames, "UserData"))
                u = [];
            else
                u = g.graph.Nodes.UserData(g.lookup(v));
            end
        end

        function u = setndata(g, v, u)
            %UGraph.setndata Set user data for node
            %
            % G.setndata(V, U) sets the user data of node V to U which can be of any
            % type such as a number, struct, object or cell array.
            %
            % See also UGraph.data.

            g.graph.Nodes.UserData(g.lookup(v)) = u;
        end

        function d = distance(g, v1, v2)
            %UGraph.distance Distance between nodes
            %
            % D = G.distance(V1, V2) is the geometric distance between
            % the nodes V1 and V2.
            %
            % See also UGraph.distances.

            d = g.distance_metric( g.nodelist(:,g.lookup(v1)), g.nodelist(:,g.lookup(v2)));

        end

        function [d,k] = distances(g, p)
            %UGraph.distances Distances from point to nodes
            %
            % D = G.distances(X) is a vector (1xN) of geometric distance from the point
            % X (Dx1) to every other node sorted into increasing order.
            %
            % [D,W] = G.distances(P) as above but also returns W (1xN) with the
            % corresponding node id.
            %
            % Notes::
            % - Distance is computed according to the metric specified in the
            %   constructor.
            %
            % See also UGraph.closest.

            d = g.distance_metric(p(:), g.nodelist);
            [d,k] = sort(d, 'ascend');
        end

        function [c,dn] = closest(g, p, tol)
            %UGraph.closest Find closest node
            %
            % V = G.closest(X) is the node geometrically closest to coordinate X.
            %
            % [V,D] = G.closest(X) as above but also returns the distance D.
            %
            % See also UGraph.distances.
            d = g.distance_metric(p(:), g.nodelist);
            [mn,c] = min(d);

            if nargin > 2 && mn > tol
                c = []; dn = [];
            end

            if nargout > 1
                dn = mn;
            end

        end

        function about(g, vv)
            if nargin < 2
                disp('pick a node using the mouse');
                vv = g.pick();
            end

            for v=vv
                fprintf('Node %d #%d@ (', v, g.labels(v)); fprintf('%g ', g.coord(v)); fprintf(')\n');
                fprintf('  neighbors: ');
                fprintf('%d ', g.neighbors(v)); fprintf('\n');

                fprintf('  edges: ');
                fprintf('%d ', g.edges(v)); fprintf('\n');
            end
        end

        function d = degree(g, v)
            %UGraph.degree Degree of vertex
            %
            % D = G.degree returns the degree for all nodes as an 1xN
            % vector
            % D = G.degree(V) is the degree (number of neighbors) of the
            % node V.

            if nargin == 1
                d = g.graph.degree;
            else
                d = g.graph.degree(v);
            end
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% EDGE PROPERTIES
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function d = cost(g, varargin)
            %UGraph.cost Cost of edge
            %
            % C = G.cost(E) is the cost of edge id E.
            % C = G.cost(N1, N2) is the cost of the edge connection nodes N1 and N2.
            if nargin == 2
                % Syntax: C = G.cost(E)
                d = g.edgelen(varargin{1});
            else
                % Syntax: C = G.cost(N1, N2)
                node1 = varargin{1};
                node2 = varargin{2};

                allCosts = g.edgelen(g.edges(node1));
                [~,edgeIdx] = ismember(node2, g.neighbors(node1));
                if edgeIdx == 0
                    d = 0;
                else
                    d = allCosts(edgeIdx);
                end
            end

        end

        function setcost(g, e, c)
            %UGraph.cost Set cost of edge
            %
            % G.setcost(E, C) set cost of edge id E to C.
            g.graph.Edges.Weight(e) = c;
            g.refresh;
        end

        function u = edata(g, e)
            %UGraph.edata Get user data for edge
            %
            % U = G.edata(E) gets the user data of edge E which can be of any
            % type such as a number, struct, object or cell array.
            %
            % See also UGraph.setedata.

            % Return if no user data is stored yet
            if ~any(contains(g.graph.Edges.Properties.VariableNames, "UserData"))
                u = [];
            else
                u = g.graph.Edges.UserData(e);
            end
        end

        function u = setedata(g, e, u)
            %UGraph.setedata Set user data for edge
            %
            % G.setedata(E, U) sets the user data of edge E to U which can be of any
            % type such as a number, struct, object or cell array.
            %
            % See also UGraph.edata.

            g.graph.Edges.UserData(e) = u;
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% GRAPH INFORMATION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function n = get.n(g)
            %UGraph.n Number of nodes in the graph
            %
            % G.n is the number of nodes in the graph.
            %
            % See also UGraph.ne.
            n = g.graph.numnodes;
        end

        function ne = get.ne(g)
            %UGraph.ne Number of edges
            %
            % G.ne is the number of edges in the graph.
            %
            % See also UGraph.n.
            ne = g.graph.numedges;
        end

        function ne = get.nc(g)
            %UGraph.nc Number of components
            %
            % G.nc is the number of components in the graph.
            %
            % See also UGraph.component.

            comps = g.graph.conncomp;
            if isempty(comps)
                ne = 0;
            else
                ne = max(comps);
            end
        end

        function disp(g)
            %UGraph.disp Display graph
            %
            % G.disp() displays a compact human readable representation of the
            % state of the graph including the number of nodes, edges and components.
            %
            % See also UGraph.char.
            loose = strcmp( get(0, 'FormatSpacing'), 'loose'); %#ok<GETFSP>
            if loose
                disp(' ');
            end
%             disp([inputname(1), ' = '])
            disp( char(g) );
        end % display()

        function s = char(g)
            %UGraph.char Convert graph to string
            %
            % S = G.char() is a compact human readable representation of the
            % state of the graph including the number of nodes, edges and components.

            s = char(...
                sprintf('  %d dimensions', g.ndims), ...
                sprintf('  %d nodes', g.n), ...
                sprintf('  %d edges', g.ne), ...
                sprintf('  %d components', g.nc));
        end

        function edgeinfo(g, e)
            edgeTable = g.graph.Edges(e,:);

            for i = 1:size(edgeTable,1)
                nodes = string(edgeTable(i,"EndNodes").EndNodes);
                cost = edgeTable(i,"Weight").Weight;
                disp("[" + nodes(1) + "] -- [" + nodes(2) + "], cost=" + cost);
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% GRAPH COMPONENTS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function c = component(g, v)
            %UGraph.component Graph component
            %
            % C = G.component(V) is the id of the graph component that contains node
            % V.
            c = g.labels(g.lookup(v));
        end

        function v = componentnodes(g, c)
            %UGraph.component Graph component
            %
            % C = G.component(V) are the ids of all nodes in the graph component V.
            v = find(g.labels == c);
        end


        function c = samecomponent(g, v1, v2)
            %UGraph.component Graph component
            %
            % C = G.component(V) is the id of the graph component that contains node
            % V.

            c = g.labels(g.lookup(v1)) == g.labels(g.lookup(v2));
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% GRAPHICS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function gPlot = plot(g, varargin)
            %UGraph.plot Plot the graph
            %
            % G.plot(OPT) plots the graph in the current figure.  Nodes
            % are shown as colored circles.
            %
            % Options::
            %  'labels'              Display node id (default false)
            %  'edges'               Display edges (default true)
            %  'edgelabels'          Display edge id (default false)
            %  'thickweight'         Display edges with higher weight thicker (default false)
            %  'NodeMarker',m        Type of marker used for nodes (default 'o')
            %  'NodeSize',S          Size of node circle (default 8)
            %  'NodeColor',C         Node circle color (default plot color)
            %  'NodeFontSize',S      Node label text size (default 10)
            %  'NodeLabelColor',C    Node label text color (default black)
            %  'EdgeColor',C         Edge color (default plot color)
            %  'EdgeFontSize',S      Edge label text size (default 8)
            %  'EdgeLabelColor',C    Edge label text color (default black)
            %  'EdgeWidth',W         Width of edge line (default 2.0)

            ax = newplot;

            colororder = ax.ColorOrder;
            nextColor = colororder(1,:);

            % parse options
            opt.labels = false;
            opt.edges = true;
            opt.edgelabels = false;
            opt.thickweight = false;
            opt.NodeMarker = 'o';
            opt.NodeSize = 8;
            opt.NodeColor = nextColor;
            opt.NodeFontSize = 10;
            opt.NodeLabelColor = 'k';
            opt.EdgeColor = nextColor;
            opt.EdgeFontSize = 8;
            opt.EdgeLabelColor = 'k';
            opt.EdgeWidth = 2.0;
            opt.only = 1:g.n;

            opt = tb_optparse(opt, varargin);

            if opt.labels
                nodeLabels = g.names;
            else
                nodeLabels = {};
            end

            if opt.edgelabels
                edgeLabels = string(g.edgelen);
            else
                edgeLabels = {};
            end

            if ~opt.edges
                % If edges are disabled, override user-provided edge color.
                opt.EdgeColor = 'none';
            end

            if opt.thickweight
                edgeWidth = opt.EdgeWidth * g.edgelen/ max(g.edgelen);
            else
                edgeWidth = opt.EdgeWidth;
            end

            gPlot = g.graph.plot("XData", g.nodelist(1,:), "YData", g.nodelist(2,:), ...
                "NodeLabel", nodeLabels, "EdgeLabel", edgeLabels, ...
                "Marker", opt.NodeMarker, "MarkerSize", opt.NodeSize, ...
                "NodeColor", opt.NodeColor, "NodeFontSize", opt.NodeFontSize, ...
                "NodeLabelColor", opt.NodeLabelColor, "EdgeColor", opt.EdgeColor, "EdgeAlpha", 0.5, ...
                "EdgeFontSize", opt.EdgeFontSize, "EdgeLabelColor", opt.EdgeLabelColor, ...
                "LineWidth", edgeWidth, "Parent", ax);

            if g.ndims == 3
                gPlot.ZData = g.nodelist(3,:);
            end

            grid(ax, "on");
        end

        function v = pick(g)
            %UGraph.pick Graphically select a node
            %
            % V = G.pick() is the id of the node closest to the point clicked
            % by the user on a plot of the graph.
            %
            % See also UGraph.plot.
            [x,y] = ginput(1);
            d = vecnorm( bsxfun(@minus,[x; y], g.nodelist(1:2,:)) );

            [~,v] = min(d);
        end

        function highlight_node(~, gPlot, verts, varargin)
            %UGraph.highlight_node Highlight a node
            %
            % G.highlight_node(GPLOT, V, OPTIONS) highlights the node V with a red marker.
            % If V is a list of nodes then all are highlighted. Apply the
            % highlight to the GPLOT object returned by the PLOT call.
            %
            % Options::
            %  'NodeSize',S          Size of node circle (default 12)
            %  'NodeColor',C         Node circle color (default red)
            %
            % See also UGraph.highlight_edge, UGraph.highlight_path.

            % parse options
            opt.NodeSize = 12;
            opt.NodeColor = 'r';

            opt = tb_optparse(opt, varargin);

            gPlot.highlight(verts, "MarkerSize", opt.NodeSize, ...
                "NodeColor", opt.NodeColor);
        end

        function highlight_edge(~, gPlot, e, varargin)
            %UGraph.highlight_node Highlight a node
            %
            % G.highlight_edge(GPLOT, V1, V2) highlights the edge between nodes V1 and V2.
            % Apply the highlight to the GPLOT object returned by the PLOT call.
            %
            % G.highlight_edge(GPLOT, E) highlights the edge with id E.
            %
            % Options::
            % 'EdgeColor',C         Edge edge color (default red)
            % 'EdgeWidth',T         Edge line width (default 4)
            %
            % See also UGraph.highlight_node, UGraph.highlight_path.

            % parse options
            opt.EdgeColor = 'r';
            opt.EdgeWidth = 4;

            [opt,args] = tb_optparse(opt, varargin);

            if ~isempty(args)
                % highlight_edge(V1, V2)
                v1 = e;
                v2 = args{1};
                gPlot.highlight(v1, v2, "EdgeColor", opt.EdgeColor, ...
                    "LineWidth", opt.EdgeWidth);
            else
                % highlight_edge(E)
                gPlot.highlight("Edges", e, "EdgeColor", opt.EdgeColor, ...
                    "LineWidth", opt.EdgeWidth);
            end
        end

        function highlight_path(g, gPlot, path, varargin)
            %UGraph.highlight_path Highlight path
            %
            % G.highlight_path(GPLOT, P, OPTIONS) highlights the path defined by vector P
            % which is a list of node ids comprising the path.
            %
            % Options::
            %  'labels'              Display node id (default false)
            %  'NodeSize',S          Size of node circle (default 12)
            %  'NodeColor',C         Node circle color (default red)
            %  'EdgeColor',C         Edge line color (default red)
            %  'EdgeWidth',T         Edge line width (default 4)
            %
            % See also UGraph.highlight_node, UGraph.highlight_edge.

            % parse options
            opt.NodeSize = 12;
            opt.NodeColor = 'r';
            opt.EdgeColor = 'r';
            opt.EdgeWidth = 4;
            opt.labels = false;

            opt = tb_optparse(opt, varargin);

            gPlot.highlight(path, ...
                "MarkerSize", opt.NodeSize, "NodeColor", opt.NodeColor, ...
                "EdgeColor", opt.EdgeColor, "LineWidth", opt.EdgeWidth);

            if opt.labels
                if isnumeric(path)
                    pathNames = g.names(path);
                else
                    pathNames = path;
                end
                gPlot.labelnode(path,pathNames)
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% MATRIX REPRESENTATIONS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function L = laplacian(g)
            %UGraph.laplacian Laplacian matrix of graph
            %
            % L = G.laplacian() is the Laplacian matrix (NxN) of the graph.
            %
            % Notes::
            % - L is always positive-semidefinite.
            % - L has at least one zero eigenvalue.
            % - The number of zero eigenvalues is the number of connected components
            %   in the graph.
            %
            % See also UGraph.adjacency, UGraph.incidence, UGraph.degree.

            L = full(g.graph.laplacian);
        end

        function D = degreeMatrix(g)
            %UGraph.degreeMatrix Degree matrix of graph
            %
            % D = G.degreeMatrix() is a diagonal matrix (NxN) where element D(i,i) is the number
            % of edges connected to node id i.
            %
            % See also UGraph.adjacency, UGraph.incidence, UGraph.laplacian.

            D = diag( g.connectivity() );
        end

        function A = adjacency(g)
            %UGraph.adjacency Adjacency matrix of graph
            %
            % A = G.adjacency() is a matrix (NxN) where element A(i,j) is the cost
            % of moving from node i to node j.
            %
            % Notes::
            % - Matrix is symmetric.
            % - Eigenvalues of A are real and are known as the spectrum of the graph.
            % - The element A(I,J) can be considered the number of walks of one
            %   edge from node I to node J (either zero or one).  The element (I,J)
            %   of A^N are the number of walks of length N from node I to node J.
            %
            % See also UGraph.degree, UGraph.incidence, UGraph.laplacian.

            % Use the weighted adjacency matrix.
            A = full(g.graph.adjacency("weighted"));
        end

        function I = incidence(g)
            %UGraph.degree Incidence matrix of graph
            %
            % IN = G.incidence() is a matrix (NxNE) where element IN(i,j) is
            % non-zero if node id i is connected to edge id j.
            %
            % See also UGraph.adjacency, UGraph.degree, UGraph.laplacian.

            % Take absolute value of incidence, since it doesn't matter if
            % edges are inbound or outbound.
            I = abs(full(g.graph.incidence));
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% PATH PLANNING
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [path, length] = path_BFS(g, vstartIn, vgoalIn, varargin)
            %UGraph.path_BFS Breadth-first search for path
            %
            % PATH = G.path_BFS(V1, V2) is the path from node V1 to
            % node V2.  PATH is a list of nodes starting with V1 and ending
            % with V2. If no path is found, PATH is returned as [].
            %
            % [PATH,C] = G.path_BFS(V1, V2) as above but also returns the
            % total cost C of traversing PATH. If no path is found, C is 0.
            %
            % The heuristic is the distance function selected in the constructor.

            vstart = g.lookup(vstartIn);
            vgoal = g.lookup(vgoalIn);

            opt.verbose = false;
            opt.summary = false;
            opt = tb_optparse(opt, varargin);

            % Keep list of frontier and explored nodes
            frontier = vstart;
            explored = [];
            parent = containers.Map("KeyType", "double", "ValueType", "double");
            costToParent = containers.Map("KeyType", "double", "ValueType", "double");
            done = false;

            while ~isempty(frontier)
                if opt.verbose
                    disp(newline);
                    disp("FRONTIER: " + g.name(frontier).join(", "))
                    if isempty(explored)
                        disp("EXPLORED: ");
                    else
                        disp("EXPLORED: " + g.name(explored).join(", "));
                    end
                end

                x = frontier(1);
                frontier(1) = [];
                if opt.verbose
                    disp("   expand " + g.name(x));
                end

                % Expand the node by exploring its neighbors
                [neighbors,costs] = g.neighbors(x);
                for i = 1:numel(neighbors)
                    node = neighbors(i);
                    if node == vgoal
                        % Reached the goal node. Break the depth-first
                        % search.
                        if opt.verbose
                            disp("   goal " + g.name(node) + " reached");
                        end
                        parent(node) = x;
                        costToParent(node) = costs(i);
                        done = true;
                        break;
                    end

                    if ~ismember(node, frontier) && ~ismember(node, explored)
                        % Add the node to the frontier
                        frontier(end+1) = node; %#ok<AGROW>
                        if opt.verbose
                            disp("   add " + g.name(node) + " to the frontier");
                        end
                        parent(node) = x;
                        costToParent(node) = costs(i);
                    end
                end

                if done
                    break;
                end
                explored(end+1) = x; %#ok<AGROW>
                if opt.verbose
                    disp("   move " + g.name(x) + " to the explored list");
                end
            end

            if ~done
                % The goal node was never found. There is no path from
                % start to goal.
                path = [];
                length = 0;
                return;
            end

            % reconstruct the path from start to goal
            x = vgoal;
            path = vgoal;
            length = 0;

            while x ~= vstart
                p = parent(x);
                length = length + costToParent(x);
                path = [p path]; %#ok<AGROW>
                x = p;
            end
            if ~isnumeric(vstartIn)
                % Return path as strings if input was string
                path = g.name(path)';
            end

            if opt.summary || opt.verbose
                disp(num2str(numel(explored)) + " nodes explored, " + ...
                    num2str(numel(frontier)) + " remaining on the frontier");
            end

        end

        function [path, length, searchTree] = path_UCS(g, vstartIn, vgoalIn, varargin)
            %UGraph.path_UCS Uniform cost search for path
            %
            % PATH = G.path_UCS(V1, V2) is the path from node V1 to
            % node V2.  PATH is a list of nodes starting with V1 and ending
            % with V2. If no path is found, PATH is returned as [].
            %
            % [PATH,C] = G.path_UCS(V1, V2) as above but also returns the
            % total cost C of traversing PATH. If no path is found, C is 0.
            %
            % [PATH,C,SEARCHTREE] = G.path_UCS(V1, V2) as above but also returns the
            % SEARCHTREE with visited nodes (explored + on frontier). The
            % SEARCHTREE is returned as digraph object.
            %
            % The heuristic is the distance function selected in the constructor.

            vstart = g.lookup(vstartIn);
            vgoal = g.lookup(vgoalIn);

            opt.verbose = false;
            opt.summary = false;
            opt = tb_optparse(opt, varargin);

            % Keep list of frontier and explored nodes
            frontier = vstart;
            explored = [];
            parent = containers.Map("KeyType", "double", "ValueType", "double");
            costToParent = containers.Map("KeyType", "double", "ValueType", "double");
            done = false;

            f = containers.Map("KeyType", "double", "ValueType", "double");
            f(vstart) = 0;

            while ~isempty(frontier)
                frontierCosts = arrayfun(@(n) f(n), frontier);

                if opt.verbose
                    disp(newline);
                    frString = "";
                    % Print frontier sorted by minimum cost
                    [~,sortOrder] = sort(frontierCosts);
                    for i = 1:numel(frontier)
                        node = frontier(sortOrder(i));
                        frString(i) = g.name(node) + "(" + num2str(f(node)) + ")";
                    end                    
                    disp("FRONTIER: " + frString.join(", "))
                    if isempty(explored)
                        disp("EXPLORED: ");
                    else
                        disp("EXPLORED: " + g.name(explored).join(", "));
                    end
                end

                % Find minimum f in frontier and pop node with minimum cost from frontier
                [~,i] = min(frontierCosts);
                x = frontier(i);
                frontier(i) = [];
                if opt.verbose
                    disp("   expand " + g.name(x));
                end

                if x == vgoal
                    done = true;
                    break;
                end

                % Expand the node by exploring its neighbors
                [neighbors,costs] = g.neighbors(x);
                for i = 1:numel(neighbors)
                    node = neighbors(i);
                    fnew = f(x) + costs(i);

                    if ~ismember(node, frontier) && ~ismember(node, explored)
                        % Add the node to the frontier
                        frontier(end+1) = node; %#ok<AGROW>
                        f(node) = fnew;
                        parent(node) = x;
                        costToParent(node) = costs(i);
                        if opt.verbose
                            disp("   add " + g.name(node) + " to the frontier");
                        end
                    elseif ismember(node, frontier)
                        % Neighbour is already in the frontier
                        % Cost of path via x is lower than previous, reparent it
                        if fnew < f(node)
                            if opt.verbose
                                disp(" reparent " + g.name(node) + ": cost " + num2str(fnew) + ...
                                    " via " + g.name(x) + " is less than cost " + num2str(f(node)) + ...
                                    " via " + g.name(parent(node)) + ", change parent from " + ...
                                    g.name(parent(node)) + " to " + g.name(x));
                            end
                            f(node) = fnew;
                            parent(node) = x;
                            costToParent(node) = costs(i);
                        end
                    end
                end

                explored(end+1) = x; %#ok<AGROW>
                if opt.verbose
                    disp("   move " + g.name(x) + " to the explored list");
                end
            end

            if ~done
                % The goal node was never found. There is no path from
                % start to goal.
                path = [];
                length = 0;
                if nargout == 3
                    searchTree = digraph;
                end
                return;
            end

            % reconstruct the path from start to goal
            x = vgoal;
            path = vgoal;
            length = 0;

            while x ~= vstart
                p = parent(x);
                length = length + costToParent(x);
                path = [p path]; %#ok<AGROW>
                x = p;
            end
            if ~isnumeric(vstartIn)
                % Return path as strings if input was string
                path = g.name(path)';
            end

            if opt.summary || opt.verbose
                disp(num2str(numel(explored)) + " nodes explored, " + ...
                    num2str(numel(frontier)) + " remaining on the frontier");
            end

            if nargout == 3
                % Construct search tree as digraph object
                searchTree = digraph;
                for node = cellfun(@(c) double(c), parent.keys)
                    nodeName = g.name(node);
                    parentName = g.name(parent(node));

                    searchTree = searchTree.addedge(parentName, nodeName);
                end
            end

        end

        function [path, length, searchTree] = path_Astar(g, vstartIn, vgoalIn, varargin)
            %UGraph.path_Astar A* search for path
            %
            % PATH = G.path_Astar(V1, V2) is the lowest cost path from node V1 to
            % node V2.  PATH is a list of nodes starting with V1 and ending
            % with V2. If no path is found, PATH is returned as [].
            %
            % [PATH,C] = G.path_Astar(V1, V2) as above but also returns the
            % total cost C of traversing PATH. If no path is found, C is 0.
            %
            % [PATH,C,SEARCHTREE] = G.path_Astar(V1, V2) as above but also returns the
            % SEARCHTREE with visited nodes (explored + on frontier). The
            % SEARCHTREE is returned as digraph object.
            %
            % Notes::
            % - Uses the efficient A* search algorithm.
            % - The heuristic is the distance function selected in the constructor, it
            %   must be  admissible, meaning that it never overestimates the actual
            %   cost to get to the nearest goal node.
            %   You can change the heuristic to a custom value by setting
            %   the g.measure property to a function handle.
            %
            % References::
            % - Correction to "A Formal Basis for the Heuristic Determination of Minimum Cost Paths".
            %   Hart, P. E.; Nilsson, N. J.; Raphael, B.
            %   SIGART Newsletter 37: 28-29, 1972.

            vstart = g.lookup(vstartIn);
            vgoal = g.lookup(vgoalIn);

            opt.verbose = false;
            opt.summary = false;
            opt = tb_optparse(opt, varargin);

            % Keep list of frontier and explored nodes
            frontier = vstart;
            explored = [];
            parent = containers.Map("KeyType", "double", "ValueType", "double");
            costToParent = containers.Map("KeyType", "double", "ValueType", "double");
            done = false;

            % Evaluation function
            f = containers.Map("KeyType", "double", "ValueType", "double");
            f(vstart) = 0;

            % Cost to come
            gcost = containers.Map("KeyType", "double", "ValueType", "double");
            gcost(vstart) = 0;

            while ~isempty(frontier)
                frontierCosts = arrayfun(@(n) f(n), frontier);

                if opt.verbose
                    disp(newline);
                    frString = "";
                    % Print frontier sorted by minimum cost
                    [~,sortOrder] = sort(frontierCosts);
                    for i = 1:numel(frontier)
                        node = frontier(sortOrder(i));
                        frString(i) = g.name(node) + "(" + num2str(f(node)) + ")";
                    end
                    disp("FRONTIER: " + frString.join(", "))
                    if isempty(explored)
                        disp("EXPLORED: ");
                    else
                        disp("EXPLORED: " + g.name(explored).join(", "));
                    end
                end

                % Find minimum f in frontier
                [~,i] = min(frontierCosts);
                x = frontier(i);
                frontier(i) = [];
                if opt.verbose
                    disp("   expand " + g.name(x));
                end

                if x == vgoal
                    done = true;
                    break;
                end

                % Expand the node by exploring its neighbors
                [neighbors,costs] = g.neighbors(x);
                for i = 1:numel(neighbors)
                    node = neighbors(i);

                    if ~ismember(node, frontier) && ~ismember(node, explored)
                        % Add the node to the frontier
                        frontier(end+1) = node; %#ok<AGROW>
                        parent(node) = x;
                        costToParent(node) = costs(i);

                        % Update cost to come
                        gcost(node) = gcost(x) + costs(i);
                        % Heuristic
                        f(node) = gcost(node) + g.distance(node, vgoal);

                        if opt.verbose
                            disp("   add " + g.name(node) + " to the frontier");
                        end
                    elseif ismember(node, frontier)
                        % Neighbour is already in the frontier
                        gnew = gcost(x) + costs(i);

                        % Cost of path via x is lower than previous, reparent it
                        if gnew < gcost(node)
                            if opt.verbose
                                disp(" reparent " + g.name(node) + ": cost " + num2str(gnew) + ...
                                    " via " + g.name(x) + " is less than cost " + num2str(gcost(node)) + ...
                                    " via " + g.name(parent(node)) + ", change parent from " + ...
                                    g.name(parent(node)) + " to " + g.name(x));
                            end
                            gcost(node) = gnew;
                            f(node) = gcost(node) + g.distance(node, vgoal);
                            parent(node) = x;
                            costToParent(node) = costs(i);
                        end
                    end
                end

                explored(end+1) = x; %#ok<AGROW>
                if opt.verbose
                    disp("   move " + g.name(x) + " to the explored list");
                end
            end

            if ~done
                % The goal node was never found. There is no path from
                % start to goal.
                path = [];
                length = 0;
                if nargout == 3
                    searchTree = digraph;
                end
                return;
            end

            % reconstruct the path from start to goal
            x = vgoal;
            path = vgoal;
            length = 0;

            while x ~= vstart
                p = parent(x);
                length = length + costToParent(x);
                path = [p path]; %#ok<AGROW>
                x = p;
            end

            if ~isnumeric(vstartIn)
                % Return path as strings if input was string
                path = g.name(path)';
            end

            if opt.summary || opt.verbose
                disp(num2str(numel(explored)) + " nodes explored, " + ...
                    num2str(numel(frontier)) + " remaining on the frontier");
            end

            if nargout == 3
                % Construct search tree as digraph object
                searchTree = digraph;
                for node = cellfun(@(c) double(c), parent.keys)
                    nodeName = g.name(node);
                    parentName = g.name(parent(node));

                    searchTree = searchTree.addedge(parentName, nodeName);
                end
            end
        end

        function d = distance_metric(g, x1, x2)

            % distance between coordinates x1 and x2 using the relevant metric
            % x2 can be multiple points represented by multiple columns
            if isa(g.measure, 'function_handle')
                d = g.measure(x1(:), x2(:));
                if ~isscalar(d) && d <= 0
                    error('SMTB:UGraph:badresult', 'distance function must return a positive scalar');
                end
            else
                switch g.measure
                    case 'Euclidean'
                        d = vecnorm( bsxfun(@minus, x1, x2) );

                    case 'SE2'
                        d = bsxfun(@minus, x1, x2) * g.dweight;
                        x1row = x1(3) * ones(1,size(x2,2));
                        d(3,:) = angdiff(x2(3,:), x1row);
                        d = vecnorm( d );

                    case 'Lattice'
                        d = bsxfun(@minus, x1, x2) * g.dweight;
                        x1row = x1(3) * ones(1,size(x2,2));
                        d(3,:) = angdiff(x2(3,:)*pi/2, x1row.*pi/2 );
                        d = vecnorm( d );
                    otherwise
                        error(['unknown distance measure ' g.measure]);
                end
            end
        end
    end %  methods

end % classdef
