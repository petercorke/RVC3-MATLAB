%ISVEC Test if vector
%
% ISVEC(V, L) is true (1) if the argument V is a vector of length L,
% either a row- or column-vector.  Otherwise false (0).
%
% Notes:
% - Differs from MATLAB builtin function ISVECTOR which returns true
%   for the case of a scalar, ISVEC does not.
% - Gives same result for row- or column-vector, ie. 3x1 or 1x3 gives true.
% - Works for a symbolic math symfun.
%
% See also ISHOMOG, ISROT, ISHOMOG2D, ISROT2D.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function h = isvec(vec, len)
    arguments
        vec
        len {mustBeInteger}
    end

    if isa(vec, 'symfun')
        h = logical( length(formula(vec)) == len);
    elseif isnumeric(vec)
        dims = size(vec);
        h = logical(length(dims) == 2 && min(dims) == 1 && numel(vec) == len);
    else
        h = false;
    end
end

