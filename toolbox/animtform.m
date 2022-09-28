%ANIMTFORM Animate a 3D coordinate frame
%
% ANIMTFORM(X) animates a coordinate frame moving from the identity pose to
% the 3D pose or orientation X.  A pose is described by an SE(3) matrix as
% a 4x4 matrix, se3 object, rigid3d object. A rotation is described by an
% SO(3) rotation matrix as a 3x3 matrix or so3 object, or by a quaternion
% object.
%
% ANIMTFORM(X1, X2) as above but animates a coordinate frame moving from X1
% to X2.
%
% ANIMTFORM(XS) animates a trajectory, where XS is a sequence of SE(3)
% homogeneous transformation matrices (4x4xN) or a 3D rotation expressed as
% an SO(3) orthonormal rotation matrix (3x3)  (3x3xN).
%
% ANIMTFORM(..., fps=F) number of frames per second to display (default
% 10).
% ANIMTFORM(..., axis=[xmin, xmax, ymin, ymax, zmin, zmax]) set axis
% bounds.
%
% ANIMTFORM(..., movie=M) save frames as a movie file, where M is the
% filename and the movie type is specified by the file extension.
%
% ANIMTFORM(..., retain=true) retain each frame in the animation.
%

%  Additional options are passed through to tformplot.
%
% Notes::
% - Uses the Animate helper class to record the frames.
%
% See also tformplot, Animate, SE3.animate.

% TODO
%  auto detect the axis scaling
function animtform(X2, varargin)

opt.fps = 10;
opt.nsteps = 50;
opt.axis = [];
opt.movie = [];
opt.retain = false;
opt.time = [];

[opt, args] = tb_optparse(opt, varargin);

ud.opt = opt;
ud.args = args;

if ~isempty(opt.movie)
    ud.anim = Animate(opt.movie);
end
if ~isempty(opt.time) && isempty(opt.fps)
    opt.fps = 1 /(opt.time(2) - opt.time(1));
end

T1 = [];

% convert various forms to to hom transform
if isrot(X2)
    % animtform(R1, options)
    % animtform(R1, R2, options)
    T2 = r2t(X2);
    if ~isempty(args) && isrot(args{1})
        T1 = T2;
        T2 = r2t(args{1});
        args = args(2:end);
    else
        T1 = eye(4,4);
    end
elseif ishomog(X2)
    % animtform(T1, options)
    % animtform(T1, T2, options)
    T2 = X2;
    if ~isempty(args) && ishomog(args{1})
        T1 = T2;
        T2 = args{1};
        args = args(2:end);
    end
elseif isa(X2, 'se3')
    % animtform(T1, options)
    % animtform(T1, T2, options)
    T2 = X2.tform();
    if ~isempty(args) && isa(args{1}, 'se3')
        T1 = T2;
        T2 = args{1}.tform();
        args = args(2:end);
    end
elseif isa(X2, 'rigid3d')
    % animtform(T1, options)
    % animtform(T1, T2, options)
    T2 = X2.T();
    if ~isempty(args) && isa(args{1}, 'se3')
        T1 = T2;
        T2 = args{1}.T();
        args = args(2:end);
    end
elseif isa(X2, 'so3')
    % animtform(R1, options)
    % animtform(R1, R2, options)
    T2 = rotm2tform(X2.rotm());
    if ~isempty(args) && isa(args{1}, 'so3')
        T1 = T2;
        T2 = rotm2tform(args{1}.rotm());
        args = args(2:end);
    end
elseif isa(X2, 'quaternion')
    % animtform(R1, options)
    % animtform(R1, R2, options)
    T2 = rotm2tform(X2.rotmat("point"));
    if ~isempty(args) && isa(args{1}, 'so3')
        T1 = T2;
        T2 = rotm2tform(args{1}.rotmat("point"));
        args = args(2:end);
    end
elseif isa(X2, 'function_handle')
    % we were passed a handle
    %
    % animtform( @func(x), x, options)
    T2 = [];
    for x = args{1}
        T2 = cat(3, T2, X2(x));
    end
else
    error('RVC3:animtform:badarg', 'argument must be 3x3 or 4x4 matrix, so3, se3 or quaternion');
end

% at this point
%   T1 is the initial pose
%   T2 is the final pose
%
%  T2 may be a sequence

if size(T2,3) > 1
    % animtform(Ts)
    % we were passed a homog sequence
    if ~isempty(T1)
        error('only 1 input argument if sequence specified');
    end
    Ttraj = T2;
else
    % animtform(P1, P2)
    % create a path between them
    if isempty(T1)
        T1 = eye(4);
    end
    Ttraj = trinterp(T1, T2, linspace(0, 1, opt.nsteps));
end

if isempty(opt.axis)
    % create axis limits automatically based on motion of frame origin
    t = tform2trvec(Ttraj);
    mn = min(t) - 1.5;  % min value + length of axis + some
    mx = max(t) + 1.5;  % max value + length of axis + some
    axlim = [mn; mx];
    axlim = axlim(:)';
    args = [args 'axis' axlim];
else
    args = [args 'axis' opt.axis];
end

if opt.retain
    hold on
    ud.hg = [];  % indicate no animation
else
    ud.hg = plottform(eye(4,4), args{:});  % create a frame at the origin
end
ud.Ttraj = Ttraj;

if ~isempty(opt.time)
    ud.htime = uicontrol('Parent', gcf, 'Style', 'text', ...
        'HorizontalAlignment', 'left', 'Position', [50 20 100 20]);
end
% animate it for all poses in the sequence

%TODO: should be done with rate control

t = timer('ExecutionMode', 'fixedRate', ...
    'BusyMode', 'queue', ...
    'UserData', ud, ...
    'TasksToExecute', length(ud.Ttraj), ...
    'Period', 1/opt.fps/2);
t.TimerFcn = @timer_callback;
start(t);

waitfor(t)

if ~isempty(ud.opt.movie)
    ud.anim.close();
end
delete(t)
if opt.cleanup
    delete(ud.hg);
end
end

function guts(ud, i)
if isa(ud.Ttraj, 'so3')
    T = ud.Ttraj(i);
else
    T = ud.Ttraj(:,:,i);
end
if ud.opt.retain
    plottform(T, ud.args{:});
else
    plottform(T, handle=ud.hg);
end

if ~isempty(ud.opt.movie)
    ud.anim.add();
end

if ~isempty(ud.opt.time)
    set(ud.htime, 'String', sprintf('time %g', ud.opt.time(i)));
end
drawnow

end

function timer_callback(timerObj, ~)
ud = get(timerObj, 'UserData');
if ~ishandle(ud.hg)
    % the figure has been closed
    stop(timerObj);
    delete(timerObj);
end

i = timerObj.TasksExecuted;

guts(ud, i);

end
