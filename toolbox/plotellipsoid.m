%PLOTELLIPSOID Draw an ellipse or ellipsoid
%
%   PLOTELLIPSOID(E) draws an ellipsoid defined by X'EX =
%   0 on the current plot, centered at the origin. E is a 3-by-3 matrix.
%
%   PLOTELLIPSOID(E, C) as above but centered at C = [X,Y,Z].
%
%   H = PLOTELLIPSOID(...) returns a graphic handle, H, to the plotted
%   ellipsoid. 
%   
%   PLOTELLIPSOID(..., Name=Value) specifies additional
%   options using one or more name-value pair arguments.
%   Specify the options after all other input arguments.
% 
%   inverted   - If true, E is inverted (e.g. covariance matrix)
%                Default: false   
%   alter      - Alter existing ellipsoids with handle H. This can be used to
%                create a smooth animation.
%   npoints    - Use N points to define the ellipsoid
%                Default: 40
%   edgecolor  - Color of the ellipsoid boundary edge, MATLAB color spec
%                Default: "black"
%   fillcolor  - Color of the ellipsoid's interior, MATLAB color spec
%                Default: "none"
%   alpha      - Transparency of the fillcolored ellipsoid: 0=transparent, 1=solid
%                Default: 1
%   shadow     - If true, shows shadows on the 3 walls of the plot box
%                Default: false
%
%
% The ellipsoid is defined by x' * E * x = s^2 where x is in R^2
% and s is the scale factor.
% For some common cases we require inv(E), for example
%     - for robot manipulability
%       \nu inv(J*J') \nu
%     - a covariance matrix
%       (x - \mu)' inv(P) (x - \mu)
%  so to avoid inverting E twice to compute the ellipsoid, we flag that
%  the inverse is provided using "inverted".
%
% - For an unfilled ellipse:
%   - any standard MATLAB LineStyle such as 'r' or 'b---'.
%   - any MATLAB LineProperty options can be given such as 'LineWidth', 2.
% - For a filled ellipse any MATLAB PatchProperty options can be given
%
% Notes::
% - The 'alter' option can be used to create a smooth animation.
% - The ellipse is added to the current plot irrespective of hold status.
%
% See also PLOTELLIPSE, PLOTCIRCLE, PLOT_BOX, PLOTPOLY, CHI2INV.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function handles = plotellipsoid(E, varargin)

assert(size(E,1) == size(E,2), 'ellipse is defined by a square matrix');
assert( size(E,1) == 3, 'E must be 3x3 for an ellipsoid');

opt.fillcolor = 'none';
opt.alpha = 1;
opt.edgecolor = 'k';
opt.alter = [];
opt.npoints = 40;
opt.shadow = 0;
opt.inverted = 0;

[opt,arglist,ls] = tb_optparse(opt, varargin);

% process some arguments

if ~isempty(ls)
    opt.edgecolor = ls{1};
end


if ~isempty(arglist) && isnumeric(arglist{1})
    % ellipse center is provided
    center = arglist{1};
    arglist = arglist(2:end);
else
    % default to origin
    center = zeros(1, size(E,1));
end

% check the ellipse to be altered
if ~isempty(opt.alter) && ~ishandle(opt.alter)
    error('SMTB:plotellipse:badarg', 'argument to alter must be a valid graphic object handle');
end

if ~opt.inverted
    E = inv(E);
end

holdon = ishold();
hold on

%% plot an ellipsoid

% define mesh points on the surface of a unit sphere
[Xs,Ys,Zs] = sphere();
ps = [Xs(:) Ys(:) Zs(:)]';

% warp it into the ellipsoid
pe = sqrtm(E) * ps;

% offset it to optional non-zero center point
if nargin > 1
    pe = bsxfun(@plus, center(:), pe);
end

% put back to mesh format
Xe = reshape(pe(1,:), size(Xs));
Ye = reshape(pe(2,:), size(Ys));
Ze = reshape(pe(3,:), size(Zs));


if isempty(opt.alter)
    % plot it
    %             Ce = ones(size(Xe));
    %             Ce = cat(3, Ce*0.8, Ce*0.4, Ce*0.4);
    h = mesh(Xe, Ye, Ze, 'FaceColor', opt.fillcolor, ...
        'FaceAlpha', opt.alpha, 'EdgeColor', opt.edgecolor, arglist{:});
else
    % update an existing plot
    set(opt.alter, 'xdata', Xe, 'ydata', Ye, 'zdata', Ze,  ...
        arglist{:});
end

% draw the shadow
if opt.shadow
    I = ones(size(Xe));
    a = [xlim ylim zlim];
    mesh(a(1)*I, Ye, Ze, 'FaceColor', 0.7*[1 1 1], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
    mesh(Xe, a(3)*I, Ze, 'FaceColor', 0.7*[1 1 1], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
    mesh(Xe, Ye, a(5)*I, 'FaceColor', 0.7*[1 1 1], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
end



if ~holdon
    hold off
end

if nargout > 0
    handles = h;
end
end
