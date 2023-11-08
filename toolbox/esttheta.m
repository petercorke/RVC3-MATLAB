%ESTTHETA Estimate projection line of best fit
%
% Options::
% 'mi'               Estimate similarity using mutual information
% 'zncc'             Estimate similarity using normalized cross correlation
% 'zssd'             Estimate similarity using SSD
% 'mask',M           Use only pixels corresponding to mask image M
% 'geometricmean'    Compute chromaticity using geom mean of R,G,B
% 'approxlog',A      Use approximation to log with alpha value A
% 'offset',OFF       Add offset OFF to images to eliminate Inf, Nan
% 'sharpen',M        Sharpening transform
%
% See also shadowRemoval, SIMILARITY

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function th = esttheta(im, varargin)

    opt.mask = [];
    opt.sharpen = [];
    [opt,args] = tb_optparse(opt, varargin);

    if isempty(opt.mask)
        fprintf('pick shaded/lit region of same material\nclick several points on the perimeter of the region then hit RETURN\n'); beep;
        k_region = pickregion(im);
        drawnow
        im = im2col(im, k_region);
    else
        im = im2col(im, opt.mask);
    end

    if ~isempty(opt.sharpen)
        im = double(im) * opt.sharpen;
        im = max(0, im);
    end
    
    theta_v = [0:0.02:pi];
    sim = [];

    %for theta = theta_v
    for i=1:numel(theta_v)
        theta = theta_v(i);
        gs = shadowRemoval(im, theta, args{:});
        k = isinf(gs) | isnan(gs);
        sim = [sim std(gs(~k))];
    end

    figure
    plot(theta_v, sim);
    xlabel('invariant line angle (rad)');
    ylabel('invariance image variance');

    [~,k] = min(sim);
    fprintf('best angle = %f rad\n', theta_v(k));
    %idisp( invariant(gs, theta) );
    
    if nargout > 0
        th = theta_v(k);
    end
end

function k = pickregion(im)

    imshow(im)
    
    xy = ginput;
    
    plotpoly(xy', 'g');
    
    [X,Y] = imeshgrid(im);
    
    in = inpolygon(X, Y, xy(:,1), xy(:,2));
    
    k = find(in);
end

function c = im2col(im, mask)

    if ndims(im) == 3
        c = reshape(shiftdim(im, 2), 3, [])';
    else
        c = reshape(im, 1, [])';
    end
    
    if nargin > 1 && ~isempty(mask)
        d = size(im);
        if ndims(mask) == 2 && all(d(1:2) == size(mask))
            k = find(mask);
        elseif isvector(mask)
            k = mask;
        else
            error('MVTB:im2col:badarg', 'mask must be same size as image or a vector');
        end
        
        c = c(k,:);
    end
end
