function [robot,configs] = loadrvcrobot(robotName, varargin)
%LOADRVCROBOT Create rigidBodyTree and configurations for various robots
%
%   ROBOT = LOADRVCROBOT("NAME") creates a rigidBodyTree object ROBOT for the
%   robot with NAME. The DataFormat of the rigidBodyTree will be "row". 
%   Valid strings for NAME:
%   - "puma" - PUMA 560 robot
%   - "cobra" - Omron eCobra 600 robot
%   - "hyper3d" - Hyper redundant robot
%                 Additional argument N for number of segments.
%   - "xypanda" - Franka Emika Panda robot carried by an XY base
%
%   [ROBOT, CONFIGS] = LOADRVCROBOT(___) also returns a set of valid robot
%   configurations in the struct, CONFIGS.
%
%   ___ = LOADRVCROBOT("NAME", DataFormat="DF") also set the DataFormat
%   that is used in the ROBOT object. By default, the ROBOT object will use
%   the "row" DataFormat.
%   Valid strings for DF: "row", "column"
%
%   ___ = LOADRVCROBOT("NAME", ARGS) pass additional arguments ARGS for
%   constructing the robot. The arguments have to be listed before any
%   name-value pairs.
%
%
%   Example:
%      puma = LOADRVCROBOT("puma")
%      [cobra,cfgs] = LOADRVCROBOT("cobra", DataFormat="column")
%      hyper3d = LOADRVCROBOT("hyper3d", 10)
%
%   See also LOADROBOT.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

narginchk(1,4);

% Parse inputs
validRobotName = validatestring(robotName, ["puma", "cobra", "hyper3d", "xypanda"], ...
    "loadrvcrobot", "robotName");

% Find all (optional) arguments before name-value pairs
dfIdx = length(varargin) + 1;
for i = 1:length(varargin)
    if string(varargin(i)) == "DataFormat"       
        dfIdx = i;
        break;
    end
end
args = varargin(1:dfIdx-1);

% Parse name-value pairs
p = inputParser;
p.addParameter("DataFormat", "row");
v = varargin(dfIdx:end);
if ~isempty(v)
    p.parse(v{:});   
else
    p.parse;
end
dataFormat = p.Results.DataFormat;
validDataFormat = validatestring(dataFormat, ["row", "column"], "loadrvcrobot", "DataFormat");

% Validation ensures that we have a valid robot name from here
switch string(validRobotName)
    case "puma"
        [robot, configs] = loadPuma560Robot(validDataFormat);
    case "cobra"
        [robot, configs] = loadCobra600Robot(validDataFormat);
    case "hyper3d"
        [robot, configs] = loadHyper3DRobot(validDataFormat, args{:});
    case "xypanda"
        [robot, configs] = loadXYPandaRobot(validDataFormat);
end

end
