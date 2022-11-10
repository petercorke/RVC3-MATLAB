%INVARIANT Compute invariant image
%
% GS = INVARIANT(IM, THETA, OPTIONS) is the greyscale invariant image (HxW)
% computed from the color image IM (HxWx3) with a projection line of slope THETA.
%
% If IM (Nx3) it is assumed to have one row per pixel and GS is similar
% (Nx3).
%
% If IM (HxWx3xN) it is assumed to be a sequence of color images and GS is
% also a sequence (HxWxN).
%
% INVARIANT(IM, THETA, OPTIONS) as above but display the input and the
% invariant image in a new figure.
%
% If THETA is [] then the slope is computed from the camera spectral
% characteristics.
%
% Examples::
% Read a color image and gamma correct it
%         im = iread('image.jpg', 'gamma', 'sRGB', 'double');
%
% If the image comes from the BB2 camera it has gamma=1 so
%         im = iread('image.pnm', 'double');
%
% Compute the invariance image
%         gs = invariance(im, 2.73, 'sharpen', M);
% then display it
%         idisp(gs)
%
% Options::
% 'nogeometricmean'   Compute chromaticity using G channel not geometric mean
% 'offset',F          Add F to all pixel, to eliminate NaN/Inf problems
% 'approxlog',A       Use the log approximation instead of log (faster)
% 'noexp'             Return log image rather than exponentiate it
% 'badpix',B          Ignore low or saturated pixels (<B, >255-B), set
%                     corresponding output pixel to NaN (default 0)
% 'sharpen',M         Use sharpening matrix M (3x3)
% 'sensor',S          Spectral peaks of sensor (default as for BB2 camera)
% 'smooth',H          Apply smoothing kernel of half width H (default 0)
%
% Reference::
% - “Dealing with shadows: Capturing intrinsic scene appear for image-based outdoor localisation,”
%   P. Corke, R. Paul, W. Churchill, and P. Newman
%   Proc. Int. Conf. Intelligent Robots and Systems (IROS), pp. 2085–2 2013.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 


function [out,out2] = invariant(in, varargin)


for i=1:length(varargin) % xxx WJ
    if isstring(varargin{i})
        varargin{i} = char(varargin{i});
    end
end


    nseq = size(in, 4);
    if nseq > 1
        % if in is HxWx3xN (image sequence) then recurse
        out = [];
        for i=1:nseq
            out = cat(3, out, invariant(in(:,:,:,i), theta, varargin{:}));
        end
        return
    end
    theta = [];
    
    % parse arguments
    opt.geometricmean = true;
    opt.offset = 0;
    opt.approxlog = 0;
    opt.exp = true;
    opt.sharpen = [];
    opt.smooth = 0;
    opt.badpix = 0;
    % spectral peaks of the Sony ICX204 sensor used in BB2 camera
    opt.sensor = [610 538 460] * 1e-9;

    [opt,args] = tb_optparse(opt, varargin);
    
    if length(args) > 0
        theta = args{1};
    end
    
    if ndims(in) == 3
        if opt.smooth > 0
            in = ismooth(in, opt.smooth);
        end
            % convert to vector form, 1 row per pixel
            im = im2col(in);
    else
        % otherwise assume already in vector form
        im = in;
    end
    im = double(im);
    
    % apply sharpening matrix if provided and clamp negative values
    if ~isempty(opt.sharpen)
        im = im * opt.sharpen;
        im = max(0, im);
    end
    
    % Planckian illumination constant
    c2 = 1.4388e-2;
    im = im + opt.offset;

    % compute chromaticity
    if opt.geometricmean
        % could do this without the cube root, RR/GB, BB/RG
        denom = prod(im, 2).^(1/3);
    else
        denom = im(:,2);
    end

    r_r = im(:,1) ./ denom;
    r_b = im(:,3) ./ denom;

    % take the log
    if opt.approxlog > 0
        % simple approximation for log = alpha(x^1/alpha-1)
        alpha = opt.approxlog;
        r_rp = alpha * (r_r.^(1/alpha) - 1);
        r_bp = alpha * (r_b.^(1/alpha) - 1);
    else
        % exact log
        r_rp = log(r_r);
        r_bp = log(r_b);
    end

    % figure the illumination invariant direction

    if isempty(theta)
        e_r = -c2 / opt.sensor(1);
        e_b = -c2 / opt.sensor(3);
        
        c = unit([e_b -e_r])
    else
        %c = [sin(theta(:)) -cos(theta(:))];
        c = [cos(theta(:)) sin(theta(:))];
    end
    
    % project the log-chrom coordinates onto the orthogonal line
    gs = [r_rp r_bp] * c';
    
    if 0
        fprintf('%d zeros in denominator\n', length(find(normalize==0)));
        %weirdvals([r_rp; r_bp]);
        weirdvals(gs);
        c
        fprintf('NaN NaN %d\n', length(find(isnan(r_rp) & isnan(r_bp))));
        fprintf('NaN Inf %d\n', length(find(isnan(r_rp) & isinf(r_bp))));
        
        fprintf('Inf NaN %d\n', length(find(isinf(r_rp) & isnan(r_bp))));
        fprintf('Inf Inf %d\n', length(find(isinf(r_rp) & isinf(r_bp))));

        fprintf(' -  NaN %d\n', length(find(isgood(r_rp) & isnan(r_bp))));
        fprintf(' -  Inf %d\n', length(find(isgood(r_rp) & isinf(r_bp))));

        fprintf('NaN  -  %d\n', length(find(isnan(r_rp) & isgood(r_bp))));
        fprintf('Inf  -  %d\n', length(find(isinf(r_rp) & isgood(r_bp))));
    end
    
    % optionally exponentiate the result, all values are positive
    if opt.exp
        gs = exp(gs);
    end
    
    % nobble the pixels that correspond to saturated or dark input pixels
    if opt.badpix > 0
        % convert to double thresholds
        maxthresh = (255-opt.badpix)/255;
        minthresh = opt.badpix/255;

        % nobble the high values
        k = find(max(im, [], 2) >= maxthresh);
        gs(k) = NaN;
        % nobble the low values
        k = find(min(im, [], 2) <= minthresh);   
        gs(k) = NaN;
    end
    
    if ndims(in) == 2
        % column image input
        if nargout == 0
            % convert to image and display
            gs = col2im(gs, in);
            show(in, gs, opt);
        else
            % return the column
            out = gs;
        end

    elseif ndims(in) == 3
        % image input
        gs = col2im(gs, in);
        if nargout == 0
            show(in, gs, opt);
        else
            out = gs;
            if nargout > 1
                out2 = [r_rp r_bp];
            end
        end
    end
end

function out = col2im(col, im)
    d = size(im);
    out = reshape(col, d(1:2));
end

function show(im, gs, opt)
    clf
    subplot(121); idisp(im-opt.offset, 'plain', 'axis', gca);
    subplot(122); idisp(gs, 'plain', 'axis', gca);
    drawnow
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
