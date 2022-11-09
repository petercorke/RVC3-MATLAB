%IMESHGRID Domain matrices for image
%
% [U,V] = IMESHGRID(IM) are matrices that describe the domain of image IM
% (HxW) and are each HxW.  These matrices are used for the evaluation of
% functions over the image. The element U(R,C) = C and V(R,C) = R.
%
% [U,V] = IMESHGRID(W, H) as above but the domain is WxH.
%
% [U,V] = IMESHGRID(S) as above but the domain is described by S which can
% be a scalar SxS or a 2-vector S=[W, H].
%
% See also MESHGRID, INTERP2.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function [U,V] = imeshgrid(a1, a2)

    if nargin == 1
        if length(a1) == 1
            % we specified a size for a square output image
            [U,V] = meshgrid(1:a1, 1:a1);
        elseif numel(a1) == 2
            % we specified a size for a rectangular output image (w,h)
            [U,V] = meshgrid(1:a1(1), 1:a1(2));
        elseif ndims(a1) >= 2
            [U,V] = meshgrid(1:size(a1,2), 1:size(a1,1));
        else
            error('incorrect argument');
        end
    elseif nargin == 2
        [U,V] = meshgrid(1:a1, 1:a2);
    end
        
        
