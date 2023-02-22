%ISTFORM2D Test if value is SE(2) homogeneous transformation matrix
%
% ISTFORM2D(T) is true (1) if the argument T is of dimension 3x3 or 3x3xN,
% else false (0).
%
% ISTFORM2D(T, check=true) as above, but also checks the validity of the
% rotation sub-matrix.
%
% Notes:
% - A valid rotation sub-matrix R has R'*R = I and det(R)=1.
% - The first form is a fast, but incomplete, test that a matrix belong
%   to SE(2).
%
% See also ISTFORM, ISROTM2D, ISVEC.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function h = istform2d(T, options)
    arguments
        T
        options.check (1,1) logical = false
    end

    h = false;
    if ~isnumeric(T)
        return
    end

    dims = size(T);
    % first two dimensions must be 3x3
    if ~(all(dims(1:2) == [3 3]))
        return %false
    end
       
    if options.check
        % each plane must contain a valid rotation matrix
        for i = 1:size(T,3)
            % check rotational part
            R = T(1:2,1:2,i);
            % check transpose is inverse
            e = R'*R - eye(2,2);
            if norm(e) > 10*eps
                return %false
            end
            % check determinant is +1
            e = abs(det(R) - 1);
            if norm(e) > 10*eps
                return %false
            end
            % check bottom row
            if ~all(T(3,:,i) == [0 0 1])
                return %false
            end
        end
    end
    h = true;
end