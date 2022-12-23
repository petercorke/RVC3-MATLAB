bdclose all; close all; clear;

% Simulate the model
sl_braitenberg
simOutput = sim("sl_braitenberg");

% Display the sensor field
clf
[X,Y] = meshgrid(1:100, 1:100);
field = sensorfield(X, Y);
image(field, "CDataMapping", "scaled")
ax = gca;
ax.YDir = "normal";
c = colorbar(ax);
c.Label.String = "Scalar field magnitude";

% Plot the trajectory
hold(ax, "on")
poseData = simOutput.logsout{1}.Values.Data;
plot(ax, poseData(:,1), poseData(:,2), "g.-")
xlabel(ax, "x"); ylabel(ax, "y")

axis equal
axis([0 100 0 100]);

% Export EPS file
%exportgraphics(ax, "../matfigs/fig5_3_cmyk.eps", "Colorspace", "cmyk" );
rvcprint("nogrid")

% This was the previous way to generate the figure (bitmap, not vector)
%rvcprint("opengl")