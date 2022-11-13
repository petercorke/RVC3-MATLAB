%TRISTIM2CC Tristimulus to chromaticity coordinates
%
% CC = TRISTIM2CC(TRI) is the chromaticity coordinate (1x2) corresponding to the
% tristimulus TRI (1x3).  If TRI is RGB then CC is rg, if TRI is XYZ then 
% CC is xy.  Multiple tristimulus values can be given as rows of TRI (Nx3)
% in which case the chromaticity coordinates are the corresponding rows 
% of CC (Nx2).
%
% [C1,C2] = TRISTIM2CC(TRI) as above but the chromaticity coordinates are
% returned in separate vectors, each Nx1.
%
% OUT = TRISTIM2CC(IM) is the chromaticity coordinates corresponding to every
% pixel in the tristimulus image IM (HxWx3).  OUT (HxWx2) has planes
% corresponding to r and g, or x and y.
%
% [O1,O2] = TRISTIM2CC(IM) as above but the chromaticity is returned as
% separate images (HxW).

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function [a,b] = tristim2cc(tri)

    if ndims(tri) < 3
        % each row is R G B or X Y Z

        s = sum(tri')';

        cc = tri(:,1:2) ./ [s s];
        if nargout == 2
            a = cc(:,1);
            b = cc(:,2);
        else
            a = cc;
        end
    else

        s = sum(tri, 3);

        if nargout == 2
            a = tri(:,:,1) ./ s;
            b = tri(:,:,2) ./ s;
        else
            a = tri(:,:,1:2) ./ cat(3, s, s);
        end
    end
