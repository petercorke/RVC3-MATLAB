%MORPHDEMO Demonstrate morphology using animation
%
% MORPHDEMO(IM, SE, OPTIONS) displays an animation to show the principles
% of the mathematical morphology operations dilation or erosion.  Two
% windows are displayed side by side, input binary image on the left and
% output image on the right.  The structuring element moves over the input
% image and is colored red if the result is zero, else blue.  Pixels in
% the output image are initially all grey but change to black or white
% as the structuring element moves.
%
% OUT = MORPHDEMO(IM, SE, OPTIONS) as above but returns the output image.
%
% Options::
% 'dilate'      Perform morphological dilation
% 'erode'       Perform morphological erosion
% 'delay'       Time between animation frames (default 0.5s)
% 'scale',S     Scale factor for output image (default 64)
% 'movie',M     Write image frames to the folder M
%
% Notes::
% - This is meant for small images, say 10x10 pixels.
%
% See also IMORPH, IDILATE, IERODE.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

% xxx WJ: see also needs a fix, parsing and use of ireplicate

function out = morphdemo(input, se, varargin)
    
    opt.op = {[], 'erode', 'dilate', 'min', 'max'};
    opt.delay = 0.1;
    opt.movie = [];
    opt.scale = 64;
    opt = tb_optparse(opt, varargin);
    
    if ~isempty(opt.movie)
        mkdir(opt.movie);
        framenum = 1;
    end
    
    input = im2double(input>0);
    
    clf

    %se = [0 1 0; 1 1 1; 0 1 0];
    
    white = [1 1 1] * 0.5;
    red = [1 0 0] * 0.8;
    blue = [0 0 1] * 0.8;
    
    result = ones(size(input)) * 0.5;
    
    subplot(121);
    h1 = gca;
    im = icolor(input);
    h1 = image(im);
    set(h1, 'CDataMapping', 'direct');
    axis equal
    
    subplot(122);
    h2 = image(result);
    colormap(gray);
    set(h2, 'CDataMapping', 'scaled');
    set(gca, 'CLim', [0 1]);
    set(gca, 'CLimMode', 'manual');
    axis equal
    
    nr_se = (size(se.Neighborhood,1)-1)/2;
    nc_se = (size(se.Neighborhood,2)-1)/2;
    
    for r=nr_se+1:size(input,1)-nr_se
        for c=nc_se+1:size(input,2)-nc_se
            im = icolor(input*0.7);
            
            win = input(r-nr_se:r+nr_se, c-nc_se:c+nc_se);
            
            rr = win .* se.Neighborhood;
            switch opt.op
                case {'erode', 'min'}
                if all(rr(find(se.Neighborhood)))
                    color = blue;
                    result(r,c) = 1;
                else
                    color = red;
                    result(r,c) = 0;
                end
                case {'dilate', 'max'}
                if any(rr(find(se.Neighborhood)))
                    color = blue;
                    result(r,c) = 1;
                else
                    color = red;
                    result(r,c) = 0;
                end
            end
            
            for i=-nr_se:nr_se
                for j=-nc_se:nc_se
                    if se.Neighborhood(i+nr_se+1,j+nc_se+1) > 0
                        im(r+i,c+j,:) = min(1, im(r+i,c+j,:) + reshape(color, [1 1 3]));
                    end
                end
            end
            
            set(h1, 'CData', im);
            
            set(h2, 'CData', result);
            
            if isempty(opt.movie)
                pause(opt.delay);
            else
                frame1 = ireplicate(im, opt.scale);
                frame2 = ireplicate(icolor(result), opt.scale);
                frame = cat(2, frame1, frame2);
                imwrite(frame, sprintf('%s/%04d.png', opt.movie, framenum));
                framenum = framenum+1;    
            end
        end
    end
    
    if nargout > 0
        out = result > 0.6;
    end
