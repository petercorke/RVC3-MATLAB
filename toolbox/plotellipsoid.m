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
%
% The ellipsoid is defined by x' * E * x = 1 where x is in R^3.
%
% For some common cases we require inv(E), for example
%     - for robot manipulability
%       \nu inv(J*J') \nu
%     - a covariance matrix
%       (x - \mu)' inv(P) (x - \mu)
%  so to avoid inverting E twice to compute the ellipsoid, we flag that
%  the inverse is provided using "inverted".
%
% Options:
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
%   shadow     - If true, shows shadows on the 3 walls of the plot box,
%                eg. as shown in Fig 8.8 (p 341) of RVC3.
%                Default: false
%
% Other options can be passed to the underlying mesh function, for example:
%
%     plotellipsoid(diag([1 2 3]), LineStyle=":")
%
% - For an unfilled ellipse:
%   - any standard MATLAB LineStyle such as "r" or "b---".
%   - any MATLAB LineProperty options can be given such as 'LineWidth', 2.
% - For a filled ellipse any MATLAB PatchProperty options can be given
%
% Notes:
% - The alter option can be used to create a smooth animation.
% - The ellipse is added to the current plot irrespective of hold status.
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Appendix C.1.4
%
% See also PLOTELLIPSE, PLOTSPHERE.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function handles = plotellipsoid(varargin)
    ip = inputParser();
    ip.KeepUnmatched = true;
    ip.addRequired("E", @(x) isnumeric(x) && isreal(x) && all(size(x) == [3 3]));
    ip.addOptional("center", [0 0 0], @(x) isnumeric(x) && isreal(x) && (numel(x) == 3));
    ip.addParameter("fillcolor", "none");
    ip.addParameter("alpha", 1, @(x) isnumeric(x) && isreal(x) && isscalar(x));
    ip.addParameter("edgecolor", "k");
    ip.addParameter("alter", [], @(x) ishandle(x));
    ip.addParameter("npoints", 40);
    ip.addParameter("shadow", false, @(x) islogical(x));
    ip.addParameter("inverted", false, @(x) islogical(x));
    ip.parse(varargin{:});
    args = ip.Results;
    arglist = namedargs2cell(ip.Unmatched);
    E = args.E;

    if ~args.inverted
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
    pe = args.center(:) + pe;
    
    % put back to mesh format
    Xe = reshape(pe(1,:), size(Xs));
    Ye = reshape(pe(2,:), size(Ys));
    Ze = reshape(pe(3,:), size(Zs));
    
    if isempty(args.alter)
        % plot it
        %             Ce = ones(size(Xe));
        %             Ce = cat(3, Ce*0.8, Ce*0.4, Ce*0.4);
        h = mesh(Xe, Ye, Ze, ...
            'FaceColor', args.fillcolor, ...
            'FaceAlpha', args.alpha, ...
            'EdgeColor', args.edgecolor, ...
            arglist{:});
    else
        % update an existing plot
        set(opt.alter, 'xdata', Xe, 'ydata', Ye, 'zdata', Ze,  ...
            arglist{:});
    end
    
    % draw the shadow
    if args.shadow
        I = ones(size(Xe));
        a = [xlim ylim zlim];
        mesh(a(1)*I, Ye, Ze, ...
            'FaceColor', 0.7*[1 1 1], ...
            'EdgeColor', 'none', ...
            'FaceAlpha', 0.5);
        mesh(Xe, a(3)*I, Ze, ...
            'FaceColor', 0.7*[1 1 1], ...
            'EdgeColor', 'none', ...
            'FaceAlpha', 0.5);
        mesh(Xe, Ye, a(5)*I, ...
            'FaceColor', 0.7*[1 1 1], ...
            'EdgeColor', 'none', ...
            'FaceAlpha', 0.5);
    end
    
    if ~holdon
        hold off
    end
    
    if nargout > 0
        handles = h;
    end
end
