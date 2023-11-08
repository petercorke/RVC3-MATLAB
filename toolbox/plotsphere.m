%PLOTSPHERE Draw sphere
%
% PLOTSPHERE(C, R) draws spheres in the current plot.  C is the 
% center of the sphere (1x3), and R is the radius. 
%
% PLOTSPHERE(C, R, COLOR) as above and COLOR is an optional MATLAB 
% ColorSpec, either a letter or a 3-vector.  
%
% If C (Nx3) then N spheres are drawn.  If R (1x1) then all
% spheres have the same radius or else R (1xN) to specify the radius of
% each sphere.
%
% H = PLOTSPHERE(...) as above but returns the handle(s) for the
% spheres.
%
% Notes:
% - The sphere is always added, irrespective of figure hold state.
%
% Example:
%    plotsphere(mkgrid(2, 1), .2, color="b"); % Create four spheres
%    lighting gouraud  % full lighting model
%    light
%
% Options:
%
% color     - surface color as a MATLAB ColorSpec (defaults to "b")
% alpha     - opaqueness (defaults to 1)
% edgecolor - edge color as a MATLAB ColorSpec (defaults to "none")
% n         - number of points on sphere (defaults to 40)
%
% See also PLOTELLIPSOID.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function out = plotsphere(c, r, color, opt)
    arguments
        c (:,3) {mustBeFloat,mustBeReal};
        r (1,1) {mustBeFloat,mustBeReal,mustBePositive};
        color string = "b";
        opt.color = "";
        opt.alpha = 1;
        opt.edgecolor = "none";
        opt.n = 40;
    end
    
    % backward compatibility with RVC
    if color ~= ""
        opt.color = color;
    end
    
    daspect([1 1 1])
    hold_on = ishold;
    hold on
    [xs,ys,zs] = sphere(opt.n);

    if isvec(c,3)
        c = c(:)';
    end
    if size(r) == 1
        r = r * ones(size(c,1),1);
    end

    if nargin < 4
        alpha = 1;
    end

    % transform the sphere
    for i=1:size(c,1)
        x = r(i)*xs + c(i,1);
        y = r(i)*ys + c(i,2);
        z = r(i)*zs + c(i,3);
                
        % the following displays a nice smooth sphere with glint!
        h = surf(x,y,z, ones(size(z)), ...
            'FaceColor', opt.color, ...
            'EdgeColor', opt.edgecolor, ...
            'FaceAlpha', opt.alpha);
        % camera patches disappear when shading interp is on
        %h = surfl(x,y,z)
    end
    %lighting gouraud
    %light
    if ~hold_on
        hold off
    end
    if nargout > 0
        out = h;
    end
end