%PRINTTFORM2D Compact display of SE(2) homogeneous transformation
%
% PRINTTFORM(T) displays pose in a compact single-line format. Pose is
% given as 3x3 homogoneous transform or as an se2, rigidtform2d or Twist2d
% object.  If T is a sequence, a 3x3xN matrix or a vector of objects, then
% each element is printed on a separate line.
%
% PRINTTFORM(R) as above but displays a 2D rotation expressed as a 2x2
% rotation matrix, or as an so2 object.
%
% S = PRINTTFORM(...) as above but returns the string for a single pose
% only.
%
% Options:
% 
% unit   - Rotational units "rad" (default) or "deg"
% fmt    - Format string for all numbers, (default "%.2g" or "%8.2g" for
%          the sequence case)
% label  - Label text to display to the left of the pose.  If not given,
%          and a variable is passed then the variable name is used, use
%          label="" to suppress.
% fid    - File identifier to write string to (defaults to stdout)
%
%
% See also PRINTTFORM.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function out = printtform2d(X, options)
    arguments
        X
        options.fmt (1,1) string = ""
        options.unit (1,1) string {mustBeMember(options.unit, ["rad", "deg"])} = "rad"
        options.fid (1,1) {mustBeInteger} = 1
        options.label (1,1) string = ""
    end

    if istform2d(X)
        T = X;
    elseif isrotm2d(X)
        T = X;
    elseif isa(X,'se2')
        T = X.tform;
    elseif isa(X,'so2')
        T = X.rotm;        
    elseif isa(X, 'Twist2')
        T = X.tform;
    elseif isa(X, "rigidtform2d")
        T = X.T();
    else
        error("RVC3:printtform2d:badarg", "unknown type of pose")
    end

    % Print the label for this pose
    %   label not given, use variable name if available
    %   label="", show no label
    %   label="label", show the given label
    if ~isfield(options, "label")
        options.label = string(inputname(1));
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
        s = tr2s2d(T, options);

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
            s = tr2s2d(T(:,:,i), options);

            if nargout == 0
                fprintf(options.fid, s+"\n");
            end
        end
    end
end

function s = tr2s2d(T, options)
    % print the label is required
    if options.label ~= ""
        s = sprintf("%8s: ", options.label);
    else
        s = "";
    end

    if all(size(T) == [3 3])
        % print the translational part if it exists
        s = s + sprintf("t = (%s), ", vec2s(options.fmt, [T(1,3);T(2,3)]));
        R = T(1:2,1:2);
    else
        R = T;
    end

    % print just the angle
    ang = atan2(R(2,1), R(1,1));

    if options.unit == "deg"
        s = s + sprintf("%s deg", vec2s(options.fmt, rad2deg(ang)));
    else
        s = s + sprintf("%s rad", vec2s(options.fmt, ang));
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
