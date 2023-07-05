% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function rvccheck()

% this function is a help to users, and those providing help in forums to understand
% the users environment.  Peter's experience is that a mix of toolboxes and path issues
% is the root cause of a lot of problems.

% Checking installation for RVC3 toolbox

% report version of MATLAB
% warning if version is too old

% check for presence of RST, CVST and other required MW toolboxes
% error if key ones are missing
% warning if some functionality might be lost, ie. The toolboxes required for Part III are not present, you need ....

% check for presence of RTB, MVTB, SMTB
% it looks like you have the older MATLAB toolboxes installed...

% check for shadowing, or which toolboxes are first in the path
% it looks like some older toolboxes are shadowing this toolbox, do you want to automatically fix your MATLAB path...

    %% check MATLAB version
    fprintf("rvccheck for RVC3 Toolbox\n")
    if verLessThan("matlab", "9.14")
        fprintf("You have MATLAB release %s, at least (R2023a) is required\n", ...
            ver("matlab").Release);
    end

    %% check that required toolboxes are present

    required_toolboxes = [
        "Robotics System Toolbox", "robotics", "Chapters 2-9"
        "Navigation Toolbox", "navigation", "Chapter 5"
        "Image Processing Toolbox", "images", "Chapters 10-15"
        "Computer Vision Toolbox", "vision", "Chapters 11-15"
        ];

    if ~isempty(required_toolboxes)
        fprintf("Some required Toolboxes are not installed:\n")
        for rt = required_toolboxes'
            full = rt(1); short = rt(2); comment = rt(3);
            v = ver(short);
            if isempty(v)
                fprintf("  %s is required for %s\n", full, comment);
            end
        end
    end

    %% check for other toolboxes

    p = which('trotx');

    if ~isempty(p)
        fprintf(" You have Peter Corke's Robotics and/or Spatial Math Toolbox in your path\n")
    end

    shadows = [];
    shadows = checkshadow(shadows, "Camera");
    if ~isempty(shadows)
        fprintf(" You have Peter Corke's Machine Vision Toolbox shadowing the RVC3 Toolbox, please remove the former from your path\n");
    end

    

end

function out = checkshadow(shadows, funcname)
    % add to the list if function lives below MATLAB root
    funcpath = which(funcname); % find first instance in path
    out = shadows;
    % if startsWith(funcpath, matlabroot) || startsWith(funcpath, 'built-in')
    %     out = [out; {funcname, which(funcname)}];
    % end
    if ~startsWith(funcpath, rvctoolboxroot)
        out = [out; {funcname, which(funcname)}];
    end
end

function p = getpath(funcname)
    funcpath = which(funcname);
    k = strfind( funcpath, [filesep funcname]);
    p = funcpath(1:k-1);
end

