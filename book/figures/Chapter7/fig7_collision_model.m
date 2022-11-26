close all; clear;

panda = loadrobot("frankaEmikaPanda", DataFormat="row");
qp = [0, -0.3, 0, -2.2, 0, 2, 0.7854, 0, 0];

%% Subfigure (a) - Panda arm colliding with box
box = collisionBox(1, 1, 1);
box.Pose = trvec2tform([1.0, -0.5, 0]);

figure;
panda.show(qp, Visuals="off", Collisions="on", Frames="off")
hold on; box.show

view(145.2725, 20.8440);
set(gca, "CameraPosition", [13.5962   19.0875    9.3635]);
set(gca, "CameraTarget", [0.1699   -0.2826    0.3901]);
set(gca, "CameraViewAngle", 1.8330);

rvcprint("opengl", subfig="_a")

%% Subfigure (b) - Panda arm next to vehicle with witness points
vehicleMesh = stlread("groundvehicle.stl");
vehicle = collisionMesh(vehicleMesh.Points ./ 100);
vehicle.Pose = trvec2tform([0.5, 0, 0]);
[isColl, sepDist, witPts] = panda.checkCollision(qp, {vehicle}, ...
    IgnoreSelfCollision="on");

figure;
panda.show(qp, Visuals="off", Collisions="on", Frames="off")
hold on; vehicle.show;

% Remove distracting face edges for vehicle
allPatches = findall(gcf, Type="patch");
allPatches(1).EdgeAlpha = 0;

%for i = 1:size(witPts,1)/3
for i = [2,3,5,11]
    w = witPts((i-1)*3 + 1:(i-1)*3 + 3, :)';

    % Connect witness points by thin red line
    l = plot3(w(:,1), w(:,2), w(:,3), '-', "LineWidth", 2);

    % Draw the witness points as red circles    
    plot3(w(:,1), w(:,2), w(:,3), 'o', MarkerSize=10, MarkerFaceColor=l.Color, MarkerEdgeColor="k");
    %"MarkerFaceColor", "r", 

end

view(145.2725, 20.8440);
set(gca, "CameraPosition", [13.9465   19.7426    9.5056]);
set(gca, "CameraTarget", [0.1146   -0.2127    0.2611]);
set(gca, "CameraViewAngle", 1.8330);

rvcprint("opengl", subfig="_b")