%SHOWCOLORSPACE Display spectral locus
%
% SHOWCOLORSPACE('xy') display a fully colored spectral locus in terms of CIE x and y 
% coordinates.
%
% SHOWCOLORSPACE('Lab') display a fully colored spectral locus in terms of CIE L*a*b* 
% coordinates.
%
% SHOWCOLORSPACE(WHICH, P) as above but plot the points whose xy- or a*b*-chromaticity
% is given by the columns of P.
%
% [IM,AX,AY] = SHOWCOLORSPACE(...) as above returns the spectral locus as an
% image IM, with corresponding x- and y-axis coordinates AX and AY 
% respectively.
%
% Notes::
% - The colors shown within the locus only approximate the true colors, due
%   to the gamut of the display device.
%
% See also RG_ADDTICKS.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

% Based on code by Pascal Getreuer 2006
% Demo for colorspace.m - the CIE xyY "tongue"

function [im,ax_,ay_] = showcolorspace(varargin)
    opt.N = 501;
    opt.L = 90; % luminance 0 to 100
    opt.colorspace = {'', 'xy', 'ab', 'Lab'};
    
    [opt,args] = tb_optparse(opt, varargin);
    
    switch opt.colorspace
        case 'xy'
            Nx = round(opt.N*0.8);
            Ny = round(opt.N*0.9);
            e = 0.01;
            % Generate colors in the xyY color space
            ax = linspace(e,0.8-e,Nx);
            ay = linspace(e,0.9-e,Ny);
            [xx,yy] = meshgrid(ax,ay);
            iyy = 1./(yy + 1e-5*(yy == 0));
            
            % Convert from xyY to XYZ
            Y = ones(Ny,Nx);
            X = Y.*xx.*iyy;
            Z = Y.*(1-xx-yy).*iyy;
            % Convert from XYZ to R'G'B'
            color = colorspace('rgb<-xyz',cat(3,X,Y,Z));
            
            % define the boundary
            lambda = [400:5:700]*1e-9';
            xyz = ccxyz(lambda);
            
            xy = xyz(:,1:2);
            
            % Make a smooth boundary with spline interpolation
            xi = [interp1(xy(:,1),1:0.25:size(xy,1),'spline'),xy(1,1)];
            yi = [interp1(xy(:,2),1:0.25:size(xy,1),'spline'),xy(1,2)];
            
            % create a mask image, colors within the boundary
            in = inpolygon(xx, yy, xi,yi);
            
            color(~cat(3,in,in,in)) = 1; % set outside pixels to white
            
        case {'ab', 'Lab'}
            % Generate colors in the Lab color space
            ax = linspace(-100, 100, opt.N);
            ay = linspace(-100, 100, opt.N);
            [aa,bb] = meshgrid(ax, ay);
            
            % Convert from Lab to R'G'B'
            color = colorspace('rgb<-lab',[opt.L*ones(size(aa(:))) aa(:) bb(:) ]);
            
            color = col2im(color, [opt.N opt.N]);
            
            color = ipixswitch(kcircle(floor(opt.N/2)), color, [1 1 1]);
        otherwise
            error('no or unknown color space provided');
    end
    
    if nargout == 0
        % Render the colors on the plane
        image(ax, ay, color)
        if length(args) > 0
            points = args{1};
            plotpoint(points, 'k*', 'textsize', 18, 'sequence', 'textcolor', 'k');
        end
        
        set(gca, 'Ydir', 'normal');
        axis equal
        
        switch opt.colorspace
            case 'xy'
                xaxis(0, 0.8); yaxis(0, 0.9)
                xlabel('x');
                ylabel('y');
            case {'ab', 'Lab'}
                xaxis(-100, 100); yaxis(-100, 100)
                xlabel('a*'); ylabel('b*')
        end
        grid
        shg;
    else
        im = color;
        if nargout > 1
            ax_ = ax;
        end
        if nargout > 2
            ay_ = ay;
        end
    end
end

% This is a local version from RVC2 copied here to avoid a clash with IPT's col2im
function im = col2im(col, img)

    ncols = size(col,2);

    if numel(img) == 2
        sz = img;
    elseif numel(img) == 3
        sz = img(1:2);
    else
        sz = size(img);
        sz = sz(1:2);
    end

    if ncols > 1
        sz = [sz ncols];
    end

    im = reshape(col, sz);
end
