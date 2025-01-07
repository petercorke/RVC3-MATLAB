%STRPRINT	S-function for transformation display in a block
%
% Input is the SE2 or SE3 transform to display.


function sltrprint(block)
    setup(block);
end

function setup(block)
    % Set number of dialog parameters
    block.NumDialogPrms = 1; % Example for options, adjust as needed

    % Set the number of input ports
    block.NumInputPorts = 1;
    block.InputPort(1).DimensionsMode = 'Fixed'; % Allow variable dimensions
    % block.InputPort(1).DirectFeedthrough = true;

    % Set the number of output ports
    block.NumOutputPorts = 0; % No outputs

    % Set block sample time
    block.SampleTimes = [0 0]; % Continuous

    % Set the block methods
    block.RegBlockMethod('InitializeConditions', @mdlInitializeConditions);
    block.RegBlockMethod('Outputs', @mdlOutputs);
end

function mdlInitializeConditions(block)
    % Initialize conditions if needed
end

function mdlOutputs(block)
    u = block.InputPort(1).Data; % Get input data
    options = block.DialogPrm(1).Data; % Get options from dialog

    if ~isempty(u)
        if length(u) == 3
            s = printtform2d(trvec2tform(u(1:2)) * rotm2d(u(3)), options{:});
        elseif istform2d(u)
            s = printtform2d(u, options{:});
        elseif istform(u)
            s = printtform(u);
        else
            error('RVC:sltrprint', 'unknown type passed, expecting 3x1, 3x3, 4x4');
        end
        set_param(block.BlockHandle, MaskDisplay=sprintf("disp('%s');", s));
    end
end
