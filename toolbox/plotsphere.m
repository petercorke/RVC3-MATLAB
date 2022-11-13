%PLOTSPHERE Draw sphere
%
% PLOTSPHERE(C, R, LS) draws spheres in the current plot.  C is the 
% center of the sphere (1x3), R is the radius and LS is an optional MATLAB 
% ColorSpec, either a letter or a 3-vector.  
%
% PLOTSPHERE(C, R, COLOR, ALPHA) as above but ALPHA specifies the opacity
% of the sphere where 0 is transparant and 1 is opaque.  The default is 1.
%
% If C (Nx3) then N sphhere are drawn and H is Nx1.  If R (1x1) then all
% spheres have the same radius or else R (1xN) to specify the radius of
% each sphere.
%
% H = PLOTSPHERE(...) as above but returns the handle(s) for the
% spheres.
%
% Notes::
% - The sphere is always added, irrespective of figure hold state.
% - The number of vertices to draw the sphere is hardwired.
%
% Example::
%         plotsphere( mkgrid(2, 1), .2, 'b'); % Create four spheres
%         lighting gouraud  % full lighting model
%         light
%
% See also: plotpoint, plot_box, plot_circle, plotellipse, plot_poly.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat


% TODO
% inconsistant call format compared to other plot_xxx functions.

function out = plotsphere(c, r, varargin)

    opt.color = 'b';
    opt.alpha = 1;
    opt.mesh = 'none';
    opt.n = 40;

    [opt,args] = tb_optparse(opt, varargin);
    
    % backward compatibility with RVC
    if length(args) > 0
        opt.color = args{1};
    end
    if length(args) > 1
        opt.alpha = args{2};
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
        h = surf(x,y,z, ones(size(z)), 'FaceColor', opt.color, 'EdgeColor', opt.mesh, 'FaceAlpha', opt.alpha);
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
