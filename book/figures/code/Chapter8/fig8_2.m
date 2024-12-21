% This figure depends on the arrow3 package.
% You can load it directly from this repository:
% >> websave arrow3.m https://raw.githubusercontent.com/petercorke/spatialmath-matlab/master/arrow3.m
%
% See https://www.mathworks.com/matlabcentral/fileexchange/14056-arrow3/
% for more information.

close all; clear;

[puma, conf] = loadrvcrobot("puma");

% Remove mesh from last link to reduce visualization clutter
puma.getBody("link6").clearVisual;

figure
puma.show(conf.qn, Frames="off", FastUpdate=true, PreservePlot=false, Visuals="on");

xlim([-0.5 1.2]);
ylim([-1 0.5])
zlim([0 1.2])

camlight right

% Display the joint axes 
hold on

baseTform = puma.getTransform(conf.qn, "base");
link1Tform = puma.getTransform(conf.qn, "link1");
link2Tform = puma.getTransform(conf.qn, "link2");
link3Tform = puma.getTransform(conf.qn, "link3");
link4Tform = puma.getTransform(conf.qn, "link4");
link5Tform = puma.getTransform(conf.qn, "link5");
link6Tform = puma.getTransform(conf.qn, "link6");

baseHg = hgtransform(Tag="baseHg"); baseHg.Matrix = baseTform;
link1Hg = hgtransform(Tag="link1Hg"); link1Hg.Matrix = link1Tform;
link2Hg = hgtransform(Tag="link2Hg"); link2Hg.Matrix = link2Tform;
link3Hg = hgtransform(Tag="link3Hg"); link3Hg.Matrix = link3Tform;
link4Hg = hgtransform(Tag="link4Hg"); link4Hg.Matrix = link4Tform;
link5Hg = hgtransform(Tag="link5Hg"); link5Hg.Matrix = link5Tform;
link6Hg = hgtransform(Tag="link6Hg"); link6Hg.Matrix = link6Tform;

fontSize=14;
fontWeight="bold";
lineColor = [0.5 0.2 0];    % Corresponds to "n" color setting for arrow

% Draw arrow for q1
baseArr = arrow3([0 0 0], [0 0 1.2], 'n1.0', 2);
baseArr(1).Color = lineColor;
set(baseArr, "Parent", baseHg);
text(0, 0.05, 1.2, "q1", Parent=baseHg, FontSize=fontSize, FontWeight=fontWeight)

% Draw arrow for q2
link1Arr = arrow3([0 0 0], [0 0 0.75], 'n1.0', 2);
link1Arr(1).Color = lineColor;
set(link1Arr, "Parent", link1Hg);
text(0, 0, 0.9, "q2", Parent=link1Hg, FontSize=fontSize, FontWeight=fontWeight)

% Draw arrow for q3
link2Arr = arrow3([0 0 0], [0 0 0.75], 'n1.0', 2);
link2Arr(1).Color = lineColor;
set(link2Arr, "Parent", link2Hg);
text(0, 0, 0.9, "q3", Parent=link2Hg, FontSize=fontSize, FontWeight=fontWeight)

% Draw arrow for q4
link3Arr = arrow3([0 0 0], [0 0 0.85], 'n1.0', 2);
link3Arr(1).Color = lineColor;
set(link3Arr, "Parent", link3Hg);
text(0, 0, 0.9, "q4", Parent=link3Hg, FontSize=fontSize, FontWeight=fontWeight)

% Draw arrow for q5
link4Arr = arrow3([0 0 0], [0 0 0.5], 'n1.0', 2);
link4Arr(1).Color = lineColor;
set(link4Arr, "Parent", link4Hg);
text(0, 0, 0.6, "q5", Parent=link4Hg, FontSize=fontSize, FontWeight=fontWeight)

% Draw arrow for q6
link5Arr = arrow3([0 0 0], [0 0 0.6], 'n1.0', 2);
link5Arr(1).Color = lineColor;
set(link5Arr, "Parent", link5Hg);
text(0, -0.1, 0.7, "q6", Parent=link5Hg, FontSize=fontSize, FontWeight=fontWeight)

% Draw x-y-z end effector coordinate frame
xArr = arrow3([0 0 0], [0.25 0 0], 'r1.0', 1.25);
yArr = arrow3([0 0 0], [0 0.25 0], 'g1.0', 1.25);
zArr = arrow3([0 0 0], [0 0 0.25], 'b1.0', 1.25);
set(xArr, "Parent", link6Hg);
text(0.3, 0, 0, "x", Parent=link6Hg, FontSize=fontSize, FontWeight=fontWeight, Color="r")
set(yArr, "Parent", link6Hg);
text(0, 0.3, 0, "y", Parent=link6Hg, FontSize=fontSize, FontWeight=fontWeight, Color="g")
set(zArr, "Parent", link6Hg);
text(0, 0, 0.3, "z", Parent=link6Hg, FontSize=fontSize, FontWeight=fontWeight, Color="b")

view(122.3479, 22.3388);

rvcprint("opengl", figy=50)