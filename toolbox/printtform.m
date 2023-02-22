%PRINTTFORM Compact display of 3D rotation or pose
%
% PRINTTFORM(T) displays pose in a compact single-line format. Pose is
% given as 4x4 homogoneous transform or as an se3, rigidtform3d or Twist
% object.  If T is a sequence, a 4x4xN matrix or a vector of objects, then
% each element is printed on a separate line.
%
% PRINTTFORM(R) as above but displays a 3D rotation expressed as a 3x3
% rotation matrix, or as an so3 or quaternion object.
%
% S = PRINTTFORM(...) as above but returns the string for a single pose
% only.
%
% Options:
%
% mode   - Display mode for rotational component as one of "rpy | "xyz" |
%          "zyx" | "yxz" | "eul" | "euler" | "axang" 
% unit   - Rotational units "rad" (default) or "deg"
% fmt    - Format string for all numbers, (default "%.2g" or "%8.2g" for
%          the sequence case)
% label  - Label text to display to the left of the pose.  If not given,
%          and a variable is passed then the variable name is used, use
%          label="" to suppress.
% fid    - File identifier to write string to (defaults to stdout)
%
% Examples:
%    >> T = se3(rotmx(0.3),[1 2 3])
%    >> printtform(T)
%    t = (1, 2, 3), RPY/zyx = (0, 0, 0.3) rad
%
%    >> printtform(T, label="A")
%           A: t = (1, 2, 3), RPY/zyx = (0, 0, 0.3) rad
%
%    >> printtform(T, mode="axang")
%    t = (1, 2, 3), R = (0.3rad | 1, 0, 0)
%
%
% See also ROTM2EUL, ROTM2AXANG, so3, quaternion, Twist.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function out = printtform(X, options)
    arguments
        X
        options.mode (1,1) string = "rpy";
        options.fmt (1,1) string = ""
        options.unit (1,1) string {mustBeMember(options.unit, ["rad", "deg"])} = "rad"
        options.fid (1,1) {mustBeInteger} = 1
        options.label (1,1) string = ""
    end

    switch options.mode
        case "rpy"
            options.mode = "zyx";
            options.orientation = "RPY/" + options.mode;
        case {"eul", "euler"}
            options.mode = "zyz";
            options.orientation = "EUL";
        case {"xyz", "zyx", "yxz"}
            options.orientation = "RPY/" + options.mode;
        case "axang"
        otherwise
            error("RVC3:printtform:badarg", "bad orientation specified")
    end

    % convert various object instances to a native matrix: 4x4 or 3x3
    if istform(X)
        T = X;
    elseif isrotm(X)
        T = X;
    elseif isa(X, "so3")
        T = X.rotm;
    elseif isa(X, "quaternion")
        T = X.rotmat("point"); 
    elseif isa(X, "se3")
        T = X.tform;
    elseif isa(X, "Twist")
        T = X.tform;
    elseif isa(X, "rigidtform3d")
        T = X.T();
    else
        error("RVC3:printtform:badarg", "unknown type of pose")
    end

    % Print the label for this pose
    %   label not given, use variable name if available
    %   label="", show no label
    %   label="label", show the given label
    if ~isfield(options, "label")
        options.label = string(inputname(1));
    end

    if size(T,3) == 1
        % scalar value
        if options.fmt == ""
            options.fmt = "%.3g";
        end
        s = tr2s(T, options);

        if nargout == 0
            fprintf(options.fid, s + "\n");
        else
            out = s;
        end
    else
        % a sequence
        if options.fmt == ""
            options.fmt = "%8.2g";
        end
        
        for i=1:size(T,3)
            % for each SE(3) matrix in a 3D array
            s = tr2s(T(:,:,i), options);

            if nargout == 0
                fprintf(options.fid, s+"\n");
            end
        end
    end
end

function s = tr2s(T, options)

    % print the label is required
    if options.label ~= ""
        s = sprintf("%8s: ", options.label);
    else
        s = "";
    end

    if all(size(T) == [4 4])
        % print the translational part if it exists
        s = s + sprintf("t = (%s), ", vec2s(options.fmt, tform2trvec(T)));
        R = tform2rotm(T);
    else
        R = T;
    end

    % print the angular part in various representations
    switch (options.mode)
        case "axang"
            % as a vector and angle
            aa = rotm2axang(R);
            th = aa(4); v = aa(1:3);
            if th == 0
                s = s + sprintf(" R = nil");
            elseif options.unit == "rad"
                s = s + sprintf(" R = (%srad | %s)", ...
                    sprintf(options.fmt, th), vec2s(options.fmt, v));
            elseif options.unit == "deg"
                s = s + sprintf(" R = (%sdeg | %s)", ...
                    sprintf(options.fmt, rad2deg(th)), vec2s(options.fmt,v));
            end
        otherwise
            % angle as a 3-vector
            ang = rotm2eul(R, options.mode);
            if options.mode == "zyz"
                % put RPY angles in RPY order
                ang = fliplr(ang);
            end

            if options.unit == "rad"
                s = s + sprintf("%s = (%s) rad", options.orientation, vec2s(options.fmt, ang));
            elseif options.unit == "deg"
                s = s + sprintf("%s = (%s) deg", options.orientation, vec2s(options.fmt, rad2deg(ang)));
            end
    end
end

function s = vec2s(fmt, v)
    % stringify a vector with specified format string and comma separated
    % values
    s = [];
    for i=1:length(v)
        if abs(v(i)) < 1e-12
            v(i) = 0;
        end
        s = [s sprintf(fmt, v(i))]; %#ok<AGROW>
    end
    s = join(s, ", ");
end
