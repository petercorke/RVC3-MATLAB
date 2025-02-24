function p = slcamera(cam, u)
    if all(u == 0)
        % Simulink is probing for the dimensions
        np = (length(u)-16)/3;
        p = zeros(np, 2);
    else
        P = reshape(u(17:end), [], 3);
        Tcam = reshape(u(1:16), 4, 4);
        p = cam.plot(P, pose=Tcam);
        drawnow;
    end

% function slcamera(block)
%     setup(block);
% end
% 
% function setup(block)
%     % Set number of input ports
%     block.NumInputPorts = 1;
%     block.InputPort(1).DimensionsMode = 'Variable'; % Allow variable dimensions
%     block.InputPort(1).DirectFeedthrough = true;
% 
%     % Set the number of output ports
%     block.NumOutputPorts = 1; % Assuming one output port
%     block.OutputPort(1).Dimensions = 2; % Example output dimensions, adjust as needed
% 
%     % Set block sample time
%     block.SampleTimes = [0 0]; % Continuous
% 
%     % Set the block methods
%     block.RegBlockMethod('InitializeConditions', @mdlInitializeConditions);
%     block.RegBlockMethod('Outputs', @mdlOutputs);
% end
% 
% function mdlInitializeConditions(block)
%     % Initialize conditions if needed
% end
% 
% function mdlOutputs(block)
%     u = block.InputPort(1).Data; % Get input data
%     if all(u == 0)
%         % Simulink is probing for the dimensions
%         np = (length(u) - 16) / 3;
%         p = zeros(np, 2);
%     else
%         P = reshape(u(17:end), [], 3);
%         Tcam = reshape(u(1:16), 4, 4);
%         p = cam.plot(P, 'pose', Tcam, 'drawnow');
%     end
%     block.OutputPort(1).Data = p; % Set output data
% end
