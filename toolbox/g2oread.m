function [pGraph, lidarScans, lidarTimes, odoEst] = g2oread(fileName)
%G2OREAD Create a poseGraph object from g2o format log file
%   G = G2OREAD(FILENAME) returns a poseGraph object
%   by parsing the g2o format log file. The g2o log file can either only 
%   contain 'EDGE_SE2' and 'VERTEX_SE2' tokens, or only contain
%   'EDGE_SE3:QUAT' and 'VERTEX_SE3:QUAT' tokens. 
%
%   [G, LIDARSCANS, LIDARTIMES] = G2OREAD(FILENAME) also returns the lidar
%   scans and associated times when these lidar scans were collected, in
%   LIDARSCANS and LIDARTIMES respectively. Lidar scans in the g2o file are
%   using the 'ROBOTLASER1' token. LIDARSCANS is returned as an N-by-1
%   matrix of lidarScan objects. LIDARTIMES is an N-by-1 array of datetime
%   objects. N is the number of nodes in the pose graph.
%
%   [G, LIDARSCANS, LIDARTIMES, ODOEST] = G2OREAD(FILENAME) also returns
%   the ground truth odometry, ODOEST, where the lidar scans were
%   collected. ODOEST is an N-by-3 array of [x,y,theta] pose rows. N is the
%   number of nodes in the pose graph
%
%   See also poseGraph, lidarScan.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

tmp = which(fileName);
if isempty(tmp)
    fileLines = readlines(fileName);
else
    fileLines = readlines(tmp);
end

% Prescan the log file to get some numbers
numEdges = 0;
numNodes = 0;
numLines = length(fileLines);
dim = -1; % unset

loopClosureLines = [];
relativeLines = [];

for i = 1:numLines
    nextLine = fileLines(i);
    [token, remainingLine] = strtok(nextLine);

    if dim == -1
        if token == "EDGE_SE2" ||token == "VERTEX_SE2"
            dim = 2;
        elseif token == "EDGE_SE3:QUAT" || token == "VERTEX_SE3:QUAT"
            dim = 3;
        end
    end

    if (dim == 2 && (token == "EDGE_SE3:QUAT" || token == "VERTEX_SE3:QUAT")) || ...
       (dim == 3 && (token == "EDGE_SE2" || token =="VERTEX_SE2"))
        coder.internal.error('nav:navalgs:factorgraph:MismatchedDimension', numLines);
    end

    if token == "EDGE_SE2" || token == "EDGE_SE3:QUAT"
        numEdges = numEdges + 1;

        % Find all loop closure edges
        lineData = sscanf(remainingLine, '%f');
        fromID = round(lineData(1)) + 1;
        toID = round(lineData(2)) + 1;
        if abs(fromID-toID) > 1
            loopClosureLines(end+1,1) = i; %#ok<AGROW> 
        else
            relativeLines(end+1,:) = [i fromID toID]; %#ok<AGROW> 
        end

    elseif token == "VERTEX_SE2" || token == "VERTEX_SE3:QUAT"
        numNodes = numNodes + 1;
    end
end

% Sort the edge lines, so all the relative poses are sorted and all loop
% closures come after the relative poses
relLinesSorted = sortrows(relativeLines, 2);
relativeStrLines = fileLines(relLinesSorted(:,1));
lcStrLines = fileLines(loopClosureLines);
sortedEdgeLines = [relativeStrLines; lcStrLines];


% Extract the data
if dim == 2
    nodeIDPair = zeros(numEdges, 2);
    measurement = zeros(numEdges, 3);
    information = zeros(numEdges, 6);
    nodeEstimate = zeros(numNodes, 3);
else
    nodeIDPair = zeros(numEdges, 2);
    measurement = zeros(numEdges, 7);
    information = zeros(numEdges, 21);
    nodeEstimate = zeros(numNodes, 7);
end
nodeID = zeros(numNodes, 1);
odoEst = zeros(numNodes, 3);
lidarTimes(numNodes,1) = NaT;
lidarScans = lidarScan.empty(1,0);


edgeCnt = 0;
nodeCnt = 0;

% Process data for vertices and lidar scans. The order of the lines doesn't
% matter here.
for i = 1:numLines
    nextLine = fileLines(i);
    lineCnt = i;
    [token, remainingLine] = strtok(nextLine);

    if token == "VERTEX_SE2"
        nodeCnt = nodeCnt + 1;
        % VERTEX_SE2 vid x y theta
        lineData = sscanf(remainingLine, '%f');
        lineData = lineData(:)';
        if numel(lineData) == 4 % expects 4 numeric values on this dataline
            nodeID(nodeCnt) = round(lineData(1)) + 1;
            nodeEstimate(nodeCnt,:) = lineData(2:4);
        else
            fclose(fileID);
            coder.internal.error('nav:navalgs:factorgraph:InvalidDataLine', lineCnt);
        end       

    elseif token == "VERTEX_SE3:QUAT"
        nodeCnt = nodeCnt + 1;
        % VERTEX_SE3:QUAT vid x y z qx qy qz qw
        lineData = sscanf(remainingLine, '%f');
        lineData = lineData(:)';
        if numel(lineData) == 8 % expects 8 numeric values on this dataline
            nodeID(nodeCnt) = round(lineData(1)) + 1;
            nodeEstimate(nodeCnt,:) = [lineData(2:4), lineData(8), lineData(5:7)];  % MATLAB expects quaternion to be in [qw, qx, qy, qz]
        else
            fclose(fileID);
            coder.internal.error('nav:navalgs:factorgraph:InvalidDataLine', lineCnt);
        end

    elseif token == "ROBOTLASER1"
        % ROBOTLASER1. Fields are
        %  From documentation here - http://ais.informatik.uni-freiburg.de/slamevaluation/software.php
        %  laser_type
        %  min scan / start angle (radians)
        %  scan range / field of view (radians)
        %  angular resolution (radians)
        %  maximum range (meters)
        %  accuracy
        %  remission mode
        %  N = number of readings
        %  N laser range data fields
        %  M = number of remissions
        %  M remission data fields
        %  laser pose X
        %  laser pose Y
        %  laser pose Theta
        %  robot pose X
        %  robot pose Y
        %  robot pose Theta
        %  laser_tv
        %  laser_rv
        %  forward_safety_dist
        %  side_safety_dist
        %  turn_axis
        %  timestamp (*nix timestamp)
        %  hostname
        %  logger_timestamp

        scanData = sscanf(remainingLine, '%f');

        % Extract min scan / start angle (radians)
        startAngle = scanData(2);
        
        % Extract angular resolution (radians)
        resolution = scanData(4);

        % Extract ranges
        numRanges = scanData(8);
        ranges = scanData(9:9+numRanges-1);

        lidarScans(1,nodeCnt) = lidarScan(ranges,startAngle:resolution:startAngle + (numRanges-1)*resolution);

        numRemissions = scanData(9+numRanges);
        poseStart = 9+numRanges+numRemissions+1;

        % Extract odometry information (lidar pose)
        odoEst(nodeCnt,:) = scanData(poseStart:poseStart+2)';

        % Extract timestamp
        timeStart = poseStart + 11;
        lidarTimes(nodeCnt) = datetime(scanData(timeStart), ConvertFrom="posixtime");

    end
end

% Now process data for edges. We need to use the sorted list of edges here,
% since the poseGraph object expects nodes to be inserted one-by-one.
for i = 1:length(sortedEdgeLines)
    nextLine = sortedEdgeLines(i);
    lineCnt = i;
    [token, remainingLine] = strtok(nextLine);

    if token == "EDGE_SE2"
        edgeCnt = edgeCnt + 1;
        % EDGE_SE2 eid1 eid2 dx dy dtheta I_11 I_12 I_13 I_22 I_23 I_33
        lineData = sscanf(remainingLine, '%f');
        lineData = lineData(:)';
        if numel(lineData) == 11 % expects 11 numeric values on this dataline
            nodeIDPair(edgeCnt,:) = [round(lineData(1)) + 1, round(lineData(2)) + 1];
            measurement(edgeCnt,:) = lineData(3:5);
            information(edgeCnt,:) = lineData(6:11);
        else
            fclose(fileID);
            coder.internal.error('nav:navalgs:factorgraph:InvalidDataLine', lineCnt);
        end

    elseif token == "EDGE_SE3:QUAT"
        edgeCnt = edgeCnt + 1;
        % EDGE_SE3:QUAT  eid1 eid2  dx dy dz  dqx dqy dqz dqw
        %                           I_11 I_12 I_13 I_14 I_15 I_16
        %                                I_22 I_23 I_24 I_25 I_26
        %                                     I_33 I_34 I_35 I_36
        %                                          I_44 I_45 I_46
        %                                               I_55 I_56
        %                                                    I_66
        lineData = sscanf(remainingLine, '%f');
        lineData = lineData(:)';
        if numel(lineData) == 30 % expects 30 numeric values on this dataline
            nodeIDPair(edgeCnt,:) = [round(lineData(1)) + 1, round(lineData(2)) + 1];
            measurement(edgeCnt,:) = [lineData(3:5), lineData(9), lineData(6:8)]; % MATLAB expects quaternion to be in [qw, qx, qy, qz]
            information(edgeCnt,:) = lineData(10:30);
        else
            fclose(fileID);
            coder.internal.error('nav:navalgs:factorgraph:InvalidDataLine', lineCnt);
        end
    end
end


if dim == 2
    pGraph = poseGraph;
else
    pGraph = poseGraph3D;
end
estLength = numel(pGraph.nodeEstimates);


% Add relative pose edges
for i = 1 : size(nodeIDPair,1)

    % Ensure that information matrix is positive definite (the pose graph
    % expects this). Fix diagonal elements only.    
    infovec = information(i,:);
    if dim == 2
        diagElems = [1 4 6];        
    else
        diagElems = [1 7 12 16 19 21];
    end
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
