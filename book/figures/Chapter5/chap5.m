%% RVC3: Chapter 5 (Navigation)
close all
clear
clc

%% Section 5.1.1 - Braitenberg Vehicles
sl_braitenberg
sim("sl_braitenberg");

%% Section 5.1.2 - Simple Automata
load house
whos floorplan
floorMap = binaryOccupancyMap(flipud(floorplan));
figure; floorMap.show
places

bug = Bug2(floorMap);
bug.plot
bug.run(places.br3,places.kitchen,animate=true);

p = bug.run(places.br3,places.kitchen);
whos p

%% Box: Creating an Occupancy Grid Map
mapMatrix = false(100, 100);
map = binaryOccupancyMap(mapMatrix);
map.setOccupancy([40,20], true(10,60), "grid");
map.show

rng(0);
map = mapClutter(10, ["Box", "Circle"]);
figure; map.show

%% Section 5.3 - Planning with a Graph-Based Map
data = jsondecode(fileread("queensland.json"))

figure
geobasemap colorterrain
hold on
for p=string(fieldnames(data.places))'
  place = data.places.(p);
  geoplot(place.lat,place.lon, ".b",MarkerSize=20)
  text(place.lat,place.lon+0.25,p)
end

data.routes(1)

g = UGraph;
for name=string(fieldnames(data.places))'
  place = data.places.(name);
  g.add_node(place.utm,name=place.name);
end

% Add edges for connections
for route=data.routes'
  g.add_edge(route.start,route.end,route.distance);
end

figure; g.plot;
g.n
g.ne

g.neighbors("Brisbane")
nodeID = g.lookup("Brisbane")
g.neighbors(nodeID)

g.degree("Brisbane")
mean(g.degree)

g.nc

e = g.edges("Brisbane")
g.edgeinfo(e)

%% Section 5.3.1 - Breadth-First Search
[pathNodes,pathLength] = g.path_BFS("Hughenden","Brisbane")
gPlot = g.plot;
g.highlight_path(gPlot,pathNodes,labels=true)

%% Section 5.3.2 - Uniform Cost Search
[pathNodes,pathLength,searchTree] = g.path_UCS("Hughenden","Brisbane");
pathLength

pathNodes

gPlot = searchTree.plot;
g.highlight_node(gPlot,["Hughenden","Brisbane"])

g.path_UCS("Hughenden","Brisbane",verbose=true)
[~,costStartToBedourie] = g.path_UCS("Hughenden","Bedourie")

costBedourieToBirdsville = g.cost("Bedourie","Birdsville")

%% Section 5.3.3 - A*
[pathNodes,pathLength,searchTree] = g.path_Astar("Hughenden","Brisbane",summary=true);
pathLength
pathNodes
visitedNodes = string(searchTree.Nodes.Name)';
gPlot = g.plot(labels=true);
g.highlight_node(gPlot,visitedNodes,NodeColor=[0.9290 0.6940 0.1250])

g.path_Astar("Hughenden","Brisbane",verbose=true)

%% Section 5.3.4 - Minimum-Time Path Planning
g = UGraph;
for name=string(fieldnames(data.places))'
  place = data.places.(name);
  g.add_node(place.utm,name=place.name);
end
for route=data.routes'
  g.add_edge(route.start,route.end,route.distance/route.speed);
end

g.measure = @(x1, x2) vecnorm(x1-x2)/100;
[pathNodes,time] = g.path_Astar("Hughenden","Brisbane")

%% Section 5.4 - Planning with an Occupancy Grid Map

%% Section 5.4.1 - Distance Transform
simplegrid = binaryOccupancyMap(false(7,7));
simplegrid.setOccupancy([3 3],true(2,3),"grid");
simplegrid.setOccupancy([5 4],true(1,2),"grid");
dx = DistanceTransformPlanner(simplegrid)

dx.plan([2 2])
dx.plot

dx = DistanceTransformPlanner(simplegrid,metric="manhattan");
dx.plan([2 2]);
pathPoints = dx.query([4 6])
dx.plot(pathPoints,labelvalues=true)

pathPoints = dx.query([6 5])
dx.plot(pathPoints)
dx.plot3d(pathPoints)
dx.query([6 5],animate=true)
dx = DistanceTransformPlanner(floorplan);
dx.plan(places.kitchen)
dx.plot

pathPoints = dx.query(places.br3);
length(pathPoints)
dx.plot(pathPoints);

dx = DistanceTransformPlanner(floorMap,inflate=6);
dx.plan(places.kitchen);
pathPoints = dx.query(places.br3);
dx.plot(pathPoints,inflated=true);


%% Section 5.4.2 - D*
ds = DStarPlanner(floorMap);
c = ds.costmap;
ds.plan(places.kitchen)
ds.niter
ds.query(places.br3);

ds.modifyCost([290 335; 100 125],5);
ds.plan

ds.niter
ds.query(places.br3);

%% Section 5.5 - Planning with Roadmaps
%% Section 5.5.1 - Introduction to Roadmap Methods
free = 1-floorplan;
free(1,:) = 0; free(end,:) = 0;
free(:,1) = 0; free(:,end) = 0;
skeleton = bwmorph(free, skel=Inf);


%% Section 5.5.2 - Proabilistic Roadmap Method (PRM)
rng(10)
prm = mobileRobotPRM(floorMap)
prm.show

figure
prm.NumNodes = 300;
prm.show;

p = prm.findpath(places.br3,places.kitchen)


%% Box: Random numbers
rand
rand
rand
rng("default")
rand
rand


%% Section 5.6 - Planning Drivable Paths
qs = [0 0 pi/2];
qg = [1 0 pi/2];

%% Section 5.6.1 - Dubins Path Planner

dubins = dubinsConnection(MinTurningRadius=1)
[paths,pathLength] = dubins.connect(qs,qg)
p = paths{1};
p.show

p

samples = p.interpolate(0:0.1:p.Length);
whos samples

allTransPoints = p.interpolate;
samplesNoTrans = setdiff(samples,allTransPoints(2:end-1,:),"rows");
whos samplesNoTrans

%% Section 5.6.2 - Reeds-Shepp Path Planner
rs = reedsSheppConnection(MinTurningRadius=1);
[paths,pathLength] = rs.connect(qs,qg);
p = paths{1}

[samples,directions] = p.interpolate(0:0.3:p.Length)
p.show

rs.ReverseCost = 3;
[paths,cost] = rs.connect(qs,qg);
p = paths{1}; 
cost
p.Length

[paths, pathLength] = rs.connect(qs,qg,PathSegments="all");
validPaths = find(~isnan(pathLength));
numel(validPaths)

%% Section 5.6.3 - Lattice Planner

lp = LatticePlanner;
lp.plan(iterations=1)
lp.plot

lp.plan(iterations=2)
lp.plot

lp.plan(iterations=8)
lp.plot

p = lp.query(qs,qg)
lp.plot

lp.plan(cost=[1 10 1]); % S, L, R
lp.query(qs,qg);
lp.plot

og = binaryOccupancyMap(false(11,11), GridOriginInLocal=[-5.5 -5.5]);
og.setOccupancy([-2.5 -2.5],true(1,5));
og.setOccupancy([-2.5 -1.5],true(1,3));
og.setOccupancy([1.5 -0.5],true(5,2));

lp = LatticePlanner(og);
lp.plan
lp.query(qs,qg)
lp.plot

%% Section 5.6.4 - Clothoids

p = referencePathFrenet([qs;qg])
p.show;

p = referencePathFrenet([0 -0.2; 0 -0.1; qs(1:2); qg(1:2); 1 0.1; 1 0.2]);
p.show;
openExample("autonomous_control/HighwayTrajectoryPlanningUsingFrenetReferencePathExample")

%% Section 5.6.5 - Planning in Configuration Space (RRT)
bicycleModel = mobileRobotPropagator(KinematicModel="bicycle");
bicycleModel.SystemParameters.KinematicModel
bicycleModel.SystemParameters.KinematicModel.SteerLimit = [-0.5 0.5];
bicycleModel.SystemParameters.KinematicModel.SpeedLimit = [0 1];

rrt = plannerControlRRT(bicycleModel)

start = [0 0 pi/2];
goal = [8 2 0];
rng(0);
[p,solnInfo] = rrt.plan(start, goal);
showControlRRT(p,solnInfo,[],start,goal); % [] for no map

load parkingMap
inflatedMap = parkingMap.copy;
inflatedMap.inflate(0.5,"world");

carModel = mobileRobotPropagator( ...
    KinematicModel="bicycle",DistanceEstimator="reedsshepp", ...
    ControlPolicy="linearpursuit",Environment=inflatedMap);
carModel.SystemParameters.KinematicModel.WheelBase = 2;
carModel.StateSpace.StateBounds(1:2,:) = ...
     [parkingMap.XWorldLimits; parkingMap.YWorldLimits];

carModel.ControlStepSize = 0.1;
carModel.MaxControlSteps = 50;

rrt = plannerControlRRT(carModel);
rrt.NumGoalExtension = 2;
rrt.GoalReachedFcn = @(planner,q,qTgt) ...
  abs(angdiff(q(3),qTgt(3))) < 0.25 && ...
  norm(q(1:2)-qTgt(1:2)) < 0.75;

start = [9.5 4 0];
goal = [5.5 2 0];
rng(0); % obtain repeatable results
[p,solnInfo] = rrt.plan(start,goal);
showControlRRT(p,solnInfo,parkingMap,start,goal);

plotPath = p.copy; plotPath.interpolate;
plotvehicle(plotPath.States,"box",scale=1/20, ...
  edgecolor=[0.5 0.5 0.5],linewidth=1)
openExample("nav/TractorTrailerPlanningUsingPlannerControlRRTExample")

%% Section 5.7.3 - Converting Between Graphs and Matrices
g = UGraph;
for i=1:4 % add 4 nodes
    g.add_node([0 0]);
end
g.add_edge(1,2,1); % Connect nodes 1 and 2 with cost 1
g.add_edge(1,4,2); % Connect nodes 1 and 4 with cost 2
g.add_edge(2,3,3); % Connect nodes 2 and 3 with cost 3
g.adjacency
