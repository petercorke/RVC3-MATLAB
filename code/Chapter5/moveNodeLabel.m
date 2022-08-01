function moveNodeLabel(graphPlot, label, xDiff, yDiff)
%MOVENODELABEL Move node label in a graph plot by [xDiff, yDiff] (relative)

% To get access to the internal NodeLabelHandles_ property, convert to
% struct.
warning off
s = struct(graphPlot);
warning on
nh = s.NodeLabelHandles_;

% Find the desired label
nhStrings = string(nh.String);
labelIdx = nhStrings.contains(string(label));
nh.VertexData(1,labelIdx) = nh.VertexData(1,labelIdx) + xDiff;
nh.VertexData(2,labelIdx) = nh.VertexData(2,labelIdx) + yDiff;

end

