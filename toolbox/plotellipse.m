function handles = plotellipse(E, varargin)
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
%   Specify the options after all other input arguments.
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
% The ellipse is defined by x' * E * x = s^2 where x is in R^2
% and s is the scale factor.
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
%
% See also PLOTCIRCLE, PLOT_BOX, CHI2INV.

% Copyright 2022-2023 Peter Corke, Witek Jachimczyk, Remo Pillat

    opt.fillcolor = 'none';
    opt.alpha = 1;
    opt.edgecolor = 'k';
    opt.alter = [];
    opt.npoints = 40;
    opt.confidence = [];
    opt.inverted = 0;

    [opt,arglist,ls] = tb_optparse(opt, varargin);

    % process some arguments

    if ~isempty(ls)
        opt.edgecolor = ls{1};
    end

    % process the probability
    if isempty(opt.confidence)
        s = 1;
    else
        if exist('chi2inv', 'file') == 2
            s = sqrt(chi2inv(opt.confidence, 2));
        else
            s = sqrt(chi2inv_rtb(opt.confidence, 2));
        end
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
        if ~opt.inverted
            E = inv(E);
        end
    else
        error('ellipse is defined by a 2x2  matrix');
    end


    %% plot an ellipse

    % define points on a unit circle
    th = linspace(0, 2*pi, opt.npoints);
    pc = [cos(th);sin(th)];

    % warp it into the ellipse
    pe = sqrtm(E)*pc * s;

    % offset it to optional non-zero center point
    center = center(:);
    if nargin > 1
        pe = bsxfun(@plus, center(1:2), pe);
    end
    x = pe(1,:); y = pe(2,:);

    % plot 2D data

    if length(center) > 2
        % plot 3D data
        z = ones(size(x))*center(3);
    else
        z = zeros(size(x));
    end


    if strcmpi(opt.fillcolor, 'none')
        % outline only, draw a line

        if isempty(ls)
            if ~isempty(opt.edgecolor)
                arglist = ['Color', opt.edgecolor, arglist];
            end
        else
            arglist = [ls arglist];
        end

        if isempty(opt.alter)
            h = plot3(x', y', z', arglist{:});
        else
            set(opt.alter, 'xdata', x, 'ydata', y);
        end
    else
        % fillcolored, use a patch

        if ~isempty(opt.edgecolor)
            arglist = ['EdgeColor', opt.edgecolor, arglist];
        end

        arglist = [ls, 'FaceAlpha', opt.alpha, arglist];


        if isempty(opt.alter)
            h = patch(x', y', z', opt.fillcolor, arglist{:});
        else
            set(opt.alter, 'xdata', x, 'ydata', y);
        end

    end

    if ~holdon
        hold off
    end

    if nargout > 0
        handles = h;
    end
end

function f = chi2inv_rtb(confidence, n)
    %CHI2INV_RTB Inverse chi-squared function
    %
    % X = CHI2INV_RTB(P, N) is the inverse chi-squared CDF function of N-degrees of freedom.
    %
    % Notes::
    % - only works for N=2
    % - uses a table lookup with around 6 figure accuracy
    % - an approximation to chi2inv() from the Statistics & Machine Learning Toolbox
    %
    % See also chi2inv.

    assert(n == 2, 'RTB:chi2inv_rtb:badarg', 'only valid for 2DOF');

    c = linspace(0,1,101);

    % build a lookup table:
    %x = chi2inv(c,2)
    %fprintf('%f ');

    % use the lookup table
    x = [0.000000 0.020101 0.040405 0.060918 0.081644 0.102587 0.123751 0.145141 0.166763 0.188621 0.210721 0.233068 0.255667 0.278524 0.301646 0.325038 0.348707 0.372659 0.396902 0.421442 0.446287 0.471445 0.496923 0.522730 0.548874 0.575364 0.602210 0.629421 0.657008 0.684981 0.713350 0.742127 0.771325 0.800955 0.831031 0.861566 0.892574 0.924071 0.956072 0.988593 1.021651 1.055265 1.089454 1.124238 1.159637 1.195674 1.232372 1.269757 1.307853 1.346689 1.386294 1.426700 1.467938 1.510045 1.553058 1.597015 1.641961 1.687940 1.735001 1.783196 1.832581 1.883217 1.935168 1.988505 2.043302 2.099644 2.157619 2.217325 2.278869 2.342366 2.407946 2.475749 2.545931 2.618667 2.694147 2.772589 2.854233 2.939352 3.028255 3.121295 3.218876 3.321462 3.429597 3.543914 3.665163 3.794240 3.932226 4.080442 4.240527 4.414550 4.605170 4.815891 5.051457 5.318520 5.626821 5.991465 6.437752 7.013116 7.824046 9.210340 Inf];

    f = interp1(c, x, confidence);
end
