%ICOLOR Colorize a greyscale image
%
% C = ICOLOR(IM) is a color image C (HxWx3)where each color plane is equal 
% to IM (HxW).
%
% C = ICOLOR(IM, COLOR) as above but each output pixel is COLOR (3x1) times
% the corresponding element of IM.
%
% Examples::
%
% Create a color image that looks the same as the greyscale image
%         c = icolor(im);
% each set pixel in im is set to [1 1 1] in the output.
%
% Create an rose tinted version of the greyscale image
%         c = icolor(im, colorname('pink'));
% each set pixel in im is set to [0 1 1] in the output.
%
% Notes::
% - Can convert a monochrome sequence (HxWxN) to a color image 
%   sequence (HxWx3xN).
%
% See also IMONO, COLORIZE, IPIXSWITCH.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function out = icolor(im, color)

    if nargin < 2
        color = [1 1 1];
    end
    
    for i=1:size(im,3)
        c = [];
        
        for k=1:numel(color)
            c = cat(3, c, im(:,:,i)*color(k));
        end
        out(:,:,:,i) = c;      
    end
