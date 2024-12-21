function rvccheck
%RVCCHECK Check MATLAB environment for running RVC3 Toolbox
%   This function is a help to users, and those providing help in forums to
%   understand the user's environment.  Peter's experience is that a mix of
%   toolboxes and path issues is the root cause of a lot of problems.
%
%   This function does the following:
%   - Warns if version of MATLAB is too old (< R2023a)
%   - Checks for presence of required MathWorks toolboxes: Robotics System
%     Toolbox, Navigation Toolbox, Image Processing Toolbox, and Computer 
%     Vision Toolbox. Warn if key ones are missing.
%   - Checks for presence of RTB, MVTB, SMTB
%     It looks like you have the older MATLAB toolboxes installed...

%   Copyright 2022-2024 Peter Corke, Witold Jachimczyk, Remo Pillat

    %% check MATLAB version
    fprintf("rvccheck for RVC3 Toolbox\n")
    fprintf("Checking for MATLAB version: %s Update %d.\n", matlabRelease.Release, matlabRelease.Update)
    if isMATLABReleaseOlderThan("R2023a")
        fprintf("- You have MATLAB release (%s), but at least (R2023a) is required\n", ...
            matlabRelease.Release);
    end

    %% check that required toolboxes are present

    required_toolboxes = [
        "Robotics System Toolbox", "robotics", "Chapters 2-9"
        "Navigation Toolbox", "nav", "Chapter 5"
        "Image Processing Toolbox", "images", "Chapters 10-15"
        "Computer Vision Toolbox", "vision", "Chapters 11-15"
        ];

    if ~isempty(required_toolboxes)
        fprintf("Checking that required Toolboxes are installed.\n")
        for rt = required_toolboxes'
            full = rt(1); short = rt(2); comment = rt(3);
            v = ver(short);
            if isempty(v)
                fprintf("- %s is required for %s and not installed.\n", full, comment);
            end
        end
    end

    %% check for other toolboxes
    fprintf("Checking for the presence of older Toolboxes.\n")
    p = which('trotx');

    if ~isempty(p)
        fprintf("- You have Peter Corke's Robotics and/or Spatial Math Toolbox in your path\n")
    end

    shadows = [];
    shadows = checkshadow(shadows, "Camera");
    if ~isempty(shadows)
        fprintf("- You have Peter Corke's Machine Vision Toolbox shadowing the RVC3 Toolbox, please remove the former from your path\n");
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
