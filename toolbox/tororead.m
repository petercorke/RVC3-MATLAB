function pGraph = tororead(fileName)
%TOROREAD Create a poseGraph object from TORO format log file
%   G = TOROREAD(FILENAME) returns a poseGraph object
%   by parsing the TORO format log file. The log file can only 
%   contain 'EDGE2' and 'VERTEX2' tokens. 
%
%   See also poseGraph.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

tmp = which(fileName);
if isempty(tmp)
    fileID = fopen(fileName);
else
    fileID = fopen(tmp);
end
coder.internal.errorIf(fileID == -1, 'nav:navalgs:factorgraph:CannotOpenFile');

% Prescan the log file to get some numbers
numEdges = 0;
numNodes = 0;
numLines = 0;
nextLine = fgetl(fileID);
while ischar(nextLine)
    numLines = numLines + 1;
    token = strtok(nextLine);

    if strcmp(token, 'EDGE2')
        numEdges = numEdges + 1;
    elseif strcmp(token, 'VERTEX2')
        numNodes = numNodes + 1;
    end
    nextLine = fgetl(fileID);
end

fclose(fileID);

% Extract the data

nodeIDPair = zeros(numEdges, 2);
measurement = zeros(numEdges, 3);
information = zeros(numEdges, 6);
nodeEstimate = zeros(numNodes, 3);

nodeID = zeros(numNodes, 1);

fileID = fopen(fileName);

nextLine = fgetl(fileID);

edgeCnt = 0;
nodeCnt = 0;
lineCnt = 0;
while ischar(nextLine)
    lineCnt = lineCnt + 1;
    [token, remainingLine] = strtok(nextLine);

    if strcmp(token, 'EDGE2')
        edgeCnt = edgeCnt + 1;
        % EDGE2 eid1 eid2 dx dy dtheta I_11 I_12 I_22 I_33 I_13 I_23
        % TORO order for information matrix is different from g2o
        % -  g2o :  I_11 I_12 I_13 I_22 I_23 I_33
        % -  toro : I_11 I_12 I_22 I_33 I_13 I_23
        % Note that for consistency with MATLAB, we are starting node IDs
        % with 1 (TORO starts at 0).
        
        % Map toro format to g2o format (expected by poseGraph)
        toroOrder = [1 2 5 3 6 4];
        lineData = sscanf(remainingLine, '%f');
        lineData = lineData(:)';
        if numel(lineData) == 11 % expects 11 numeric values on this dataline
            nodeIDPair(edgeCnt,:) = [round(lineData(1)) + 1, round(lineData(2)) + 1];
            measurement(edgeCnt,:) = lineData(3:5);
            infoToro = lineData(6:11);          
            information(edgeCnt,:) = infoToro(toroOrder);
        else
            fclose(fileID);
            coder.internal.error('nav:navalgs:factorgraph:InvalidDataLine', lineCnt);
        end

    elseif strcmp(token, 'VERTEX2')
        nodeCnt = nodeCnt + 1;
        % VERTEX2 vid x y theta
        lineData = sscanf(remainingLine, '%f');
        lineData = lineData(:)';
        if numel(lineData) == 4 % expects 4 numeric values on this dataline
            nodeID(nodeCnt) = round(lineData(1)) + 1;
            nodeEstimate(nodeCnt,:) = lineData(2:4);
        else
            fclose(fileID);
            coder.internal.error('nav:navalgs:factorgraph:InvalidDataLine', lineCnt);
        end 
    end
        
    nextLine = fgetl(fileID);
end
fclose(fileID);

pGraph = poseGraph;
estLength = numel(pGraph.nodeEstimates);


% Add relative pose edges
for i = 1 : size(nodeIDPair,1)

    % Ensure that information matrix is positive definite (the pose graph
    % expects this). Fix diagonal elements only.    
    infovec = information(i,:);
    diagElems = [1 4 6];        
    infovec(diagElems) = infovec(diagElems) + (infovec(diagElems) == 0) * eps;

    pGraph.addRelativePose(measurement(i,:), infovec, ...
        nodeIDPair(i,1), nodeIDPair(i,2));
end

% Add initial node estimates
numNodes = size(nodeID,1);
initialEstimates = zeros(numNodes,estLength);
for j = 1:numNodes
    nid = nodeID(j);
    initialEstimates(nid,:) = nodeEstimate(j,:);
end

pa = rvc.internal.PoseGraphAccess(pGraph);
pa.updateNodeEstimates(initialEstimates);

end
