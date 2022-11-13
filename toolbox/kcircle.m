%KCIRCLE Circular structuring element
%
% K = KCIRCLE(R) is a square matrix (WxW) where W=2R+1 of zeros with a
% maximal centered circular region of radius R pixels set to one.
%
% K = KCIRCLE(R,W) as above but the dimension of the kernel is explicitly 
% specified.
%
% Notes::
% - If R is a 2-element vector the result is an annulus of ones, and
%   the two numbers are interpretted as inner and outer radii.
%
% See also ONES, KTRIANGLE, IMORPH.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function s = kcircle(r, w)

    if ~isscalar(r) 
        rmax = max(r(:));
        rmin = min(r(:));
    else
        rmax = r;
    end


    if nargin == 2
        w = w*2 + 1;
    elseif nargin == 1
        w = 2*rmax+1;
    end
    s = zeros(w,w);

    c = ceil(w/2);

    if ~isscalar(r) 
        s = kcircle(rmax,w) - kcircle(rmin, w);
    else
        [x,y] = imeshgrid(s);
        x = x - c;
        y = y - c;
        l = find(round(x.^2 + y.^2 - r^2) <= 0);
        s(l) = 1;
    end
