%PLOTELLIPSE Draw an ellipse
%
%   PLOTELLIPSE(E) draws an ellipse defined by X'EX = 1
%   on the current plot, centered at the origin. E is a 2-by-2 matrix. 
%   The ellipse is added to the current plot irrespective of hold status.
%
%   PLOTELLIPSE(EV) draws an ellipse defined by EV = [A B ALPHA],  
%   which are the radius in the x and y directions, and the angle of
%   rotation, ALPHA, in radians.
%
%   PLOTELLIPSE(..., C) as above but the ellipse is centered at C = [X Y].  
%
%   H = PLOTELLIPSE(...) returns a graphic handle, H, to the plotted
%   ellipse. 
%   
%   PLOTELLIPSE(..., Name=Value) specifies additional
%   options using one or more name-value pair arguments.
%
% The ellipse is defined by x' * E * x = s^2 where x is in R^2
% and s is the scale factor.
%
% Options:
%
%   confidence - Confidence interval, range 0 to 1. If a confidence interval 
%                is given then E is interpretted as an inverse covariance
%                matrix and the ellipse size is computed using an inverse 
%                chi-squared function. This uses CHI2INV, if available, or
%                an internal implementation.
%                Default: 1
%   inverted   - If true, E is inverted (e.g. covariance matrix)
%                Default: false   
%   alter      - Alter existing ellipses with handle H. This can be used to
%                create a smooth animation.
%   npoints    - Use N points to define the ellipse
%                Default: 40
%   edgecolor  - Color of the ellipse boundary edge, MATLAB color spec
%                Default: "black"
%   fillcolor  - Color of the ellipses's interior, MATLAB color spec
%                Default: "none"
%   alpha      - Transparency of the fillcolored ellipse: 0=transparent, 1=solid
%                Default: 1
%
%
% For some common cases we require inv(E), for example
%     - for robot manipulability
%       \nu inv(J*J') \nu
%     - a covariance matrix
%       (x - \mu)' inv(P) (x - \mu)
%  so to avoid inverting E twice to compute the ellipse, we flag that
%  the inverse is provided using "inverted".
%
%   For an unfilled ellipse:
%   - any standard MATLAB LineStyle such as 'r' or 'b---'.
%   - any MATLAB LineProperty options can be given such as 'LineWidth', 2.
%   For a filled ellipse any MATLAB PatchProperty options can be given.
%
%
%   Example:
%      % Draw red ellipse
%      H = PLOTELLIPSE(diag([1 2]), [3 4], "r");
% 
%      % Move the ellipse
%      PLOTELLIPSE(diag([1 2]), [5 6], alter=H);
% 
%      % Change color to black
%      PLOTELLIPSE(diag([1 2]), [5 6], alter=H, LineColor="k");
%
%      % Draw 95% confidence ellipse
%      PLOTELLIPSE(COVAR, confidence=0.95);
%
% References:
% - Robotics, Vision & Control: Fundamental algorithms in MATLAB, 3rd Ed.
%   P.Corke, W.Jachimczyk, R.Pillat, Springer 2023.
%   Appendix C.1.4
%
% See also PLOTCIRCLE, PLOT_BOX, CHI2INV.

% Copyright 2022-2023 Peter Corke, Witek Jachimczyk, Remo Pillat

function handles = plotellipse(varargin)
    % If the second parameter is a Linespec, add a default center.
    % inputParser cannot handle only passing the 2nd optional argument.
    if length(varargin) > 1 && validateLinespec(varargin{2})
        varargin = [varargin(1) {[0 0]} varargin(2:end)];
    end

    % Standard input parsing
    ip = inputParser();
    ip.KeepUnmatched = true;
    ip.addRequired("E", @(x) isnumeric(x) && isreal(x));
    ip.addOptional("center", [0 0], @(x) isnumeric(x) && isreal(x) && (numel(x) == 2));
    ip.addOptional("ls", "", @validateLinespec);
    ip.addParameter("fillcolor", "none");
    ip.addParameter("alpha", 1, @(x) isnumeric(x) && isreal(x) && isscalar(x));
    ip.addParameter("edgecolor", "k");
    ip.addParameter("alter", [], @(x) ishandle(x));
    ip.addParameter("npoints", 40);
    ip.addParameter("confidence", [], @(x) isnumeric(x));
    ip.addParameter("inverted", false, @(x) islogical(x));
    ip.parse(varargin{:});
    args = ip.Results;
    arglist = namedargs2cell(ip.Unmatched);
    E = args.E;

    % process the probability
    if isempty(args.confidence)
        s = 1;
    else
        if exist('chi2inv', 'file') == 2
            s = sqrt(chi2inv(args.confidence, 2));
        else
            s = sqrt(chi2inv_rvc(args.confidence, 2));
        end
    end

    holdon = ishold();
    hold on

    if all(size(E) == [1 3])
        % ellipse defined by parameters
        a = E(1); b = E(2); orientation = E(3);
        A = (b^2-a^2)*sin(orientation)^2 + a^2;
        B = (a^2-b^2)*sin(orientation)^2 + b^2;
        C = sin(2*orientation)*(a^2-b^2)/2;
        E = [A C;C B];

    elseif all(size(E) == [2 2])
        if ~args.inverted
            E = inv(E);
        end
    else
        error('RVC3:plotellipse:badarg', ...
            'ellipse is defined by a 1x3 or 2x2  matrix');
    end


    %% plot an ellipse

    % define points on a unit circle
    th = linspace(0, 2*pi, args.npoints);
    pc = [cos(th);sin(th)];

    % warp it into the ellipse
    pe = sqrtm(E)*pc * s;

    % offset it to optional non-zero center point
    pe = args.center(:) + pe;
    x = pe(1,:); y = pe(2,:);

    % plot 2D data

    if length(args.center) > 2
        % plot 3D data
        z = ones(size(x))*args.center(3);
    else
        z = zeros(size(x));
    end


    if strcmpi(args.fillcolor, "none")
        % outline only, draw a line

        if isempty(args.ls)
            if ~isempty(args.edgecolor)
                arglist = [{"Color"}, args.edgecolor, arglist];
            end
        else
            arglist = [{args.ls}, arglist];
        end

        if isempty(args.alter)
            h = plot3(x', y', z', arglist{:});
        else
            set(args.alter, "xdata", x, "ydata", y);
        end
    else
        % fillcolored, use a patch

        if ~isempty(args.edgecolor)
            arglist = ["EdgeColor", args.edgecolor, arglist];
        end

        arglist = ["FaceAlpha", args.alpha, arglist];


        if isempty(args.alter)
            h = patch(x', y', z', args.fillcolor, arglist{:});
        else
            set(args.alter, "xdata", x, "ydata", y);
        end

    end

    if ~holdon
        hold off
    end

    if nargout > 0
        handles = h;
    end
end

function valid = validateLinespec(linespec)
%validateLinespec Validate a LineSpec input

if ~(ischar(linespec) || isStringScalar(linespec))
    valid = false;
    return;
end

[style, color, marker] = colstyle(linespec);
valid = ~isempty(style) || ~isempty(color) || ~isempty(marker);

end

