%ANIMTFORM2D Animate a 2D coordinate frame
%
% ANIMTFORM2D(X) animates a 2D coordinate frame moving from the identity pose to
% the orientation or pose X.  A pose is described by an SE(2) matrix
% (3x3), or an se2, rigidtform2d or Twist2d object. An orientation is
% described by an SO(2) rotation matrix (2x2), or an so2 object.
%
% ANIMTFORM2D(X1, X2) as above but animates a coordinate frame moving from X1
% to X2.  X1 and X2 can be different types of objects.
%
% Options:
%  fps     - Number of frames per second to display (default 10)
%  nsteps  - The number of steps along the path (default 50)
%  axis    - Axis bounds [xmin, xmax, ymin, ymax]
%  movie   - Save frames as a movie or sequence of frames
%  cleanup - Remove the frame at end of animation
%  retain  - Retain frames, don't animate
%
% Additional options are passed through to PLOTTFORM2D.
%
% See also PLOTTFORM2D, Animate.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

% TODO
%  auto detect the axis scaling
function animtform2d(varargin)

    % cant catch the unmatched options, use inputParser instead
    ip = inputParser();
    ip.KeepUnmatched = true;
    ip.addRequired("X1");
    ip.addOptional("X2", []);
    ip.addParameter("fps", 10);
    ip.addParameter("nsteps", 50, @(x) isscalar(x));
    ip.addParameter("clock", true, @(x) islogical(x));
    ip.addParameter("axis", []);
    ip.addParameter("movie", "", @(x) isstring(x));
    ip.addParameter("retain", false, @(x) islogical(x));
    ip.addParameter("cleanup", true, @(x) islogical(x));
    ip.parse(varargin{:});
    args = ip.Results;
    
    X1 = args.X1;
    X2 = args.X2;
    plot_args = ip.Unmatched;
    
    tlimits = [0 args.nsteps/args.fps];
    t = linspace(tlimits(1), tlimits(2), args.nsteps);

    if isempty(X2)
        % animtform(X, ...)
        T2 = X2SE2(X1);
        if size(T2,3) == 1
            % single pose given
            T1 = eye(3);
            Ttraj = traj(T1, T2, tlimits, t);
        else
            % sequence given
            Ttraj = T2;
        end
    else
        % animtform(X2, X2, ...)
        T1 = X2SE2(X1);
        T2 = X2SE2(X2);
        assert(size(T1,3) == 1 && size(T2,3) == 1, "RVC3:animtform:badarg", "transforms cannot be sequences")
        Ttraj = traj(T1, T2, tlimits, t);
    end

    if isempty(args.axis)
        % create axis limits automatically based on motion of frame origin
        t = tform2trvec(Ttraj);
        mn = min(t) - 1.5;  % min value + length of axis + some
        mx = max(t) + 1.5;  % max value + length of axis + some
        axlim = [mn; mx];
        axlim = axlim(:)';
        plot_args.axis = axlim;
    else
        plot_args.axis = args.axis;
    end
    
    plot_args_cell = struct2cell(plot_args);

    % convert plot options from a struct to a cell array
    names = fieldnames(plot_args);
    values = struct2cell(plot_args);
    plot_args_cell = {};
    for i=1:length(names)
        plot_args_cell{end+1} = names{i};
        plot_args_cell{end+1} = values{i};
    end

    if args.retain
        hold on
    else
        hplot = plottform2d(Ttraj(:,:,1), plot_args_cell{:});  % create first frame
    end

    if args.clock
        htime = uicontrol(Parent=gcf, ...
                Style="text", ...
                HorizontalAlignment="left", ...
                Position=[50 20 100 20]...
                );
    end
    
    % animate it for all poses in the sequence
    if args.movie ~= ""
        anim = Animate(args.movie);
    end
    r = rateControl(args.fps);
    for i=1:args.nsteps
        T = Ttraj(:,:,i);
        if args.retain
            plottform2d(T, plot_args_cell{:});
        else
            plottform2d(T, handle=hplot);
        end
        
        if args.clock
            htime.String = sprintf("time %g", t(i));
        end

        if args.movie ~= ""
            anim.add();
        end

        drawnow
        waitfor(r);
    end
    
    if args.movie ~= ""
        anim.close();
    end
    if args.cleanup
        try
            delete(hplot);
        catch
        end
    end
end % animtform

function tg = traj(T1, T2, tlimits, t)

    T1 = [T1(1:2,1:2) [0; 0] T1(1:2, 3); 0 0 1 0; 0 0 0 1];
    T2 = [T2(1:2,1:2) [0; 0] T2(1:2, 3); 0 0 1 0; 0 0 0 1];

    tg = transformtraj(T1, T2, tlimits, t);

    tg(3,:,:) = [];
    tg(:,3,:) = [];
end

function T = X2SE2(X)
    % convert various forms to to SE(2) hom transform

    if isrotm2d(X)
        T = rotm2tform(X);
    elseif istform2d(X)
        T = X;
    elseif isa(X, "se2")
        T = X.tform();
    elseif isa(X, "rigidtform2d")
        T = X.T();
    elseif isa(X, "Twist2d")
        T = X.tform();
    elseif isa(X, "so2")
        T = rotm2tform(X.rotm());
    else
        error("RVC3:animtform:badarg", "argument must be 2x2 or 3x3 matrix, so2, se2");
    end
end
