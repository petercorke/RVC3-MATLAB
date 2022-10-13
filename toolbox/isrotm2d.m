%ISROTM2D Test if value is SO(2) rotation matrix
%
% ISROTM2D(R) is true (1) if the argument is of dimension 2x2 or 2x2xN,
% else false (0).
%
% ISROTM2D(R, check=true) as above, but also checks the validity of the
% rotation matrix.
%
% Notes:
% - A valid rotation matrix R has R'*R = I and det(R)=1.
% - The first form is a fast, but incomplete, test that a matrix belong
%   to SO(2).
%
% See also ISROT, ISHOMOG2, ISVEC.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function h = isrotm2d(R, options)
    arguments
        R double
        options.check (1,1) logical = false
    end

    h = false;
    d = size(R);
    
    if ndims(R) >= 2
        if ~(all(d(1:2) == [2 2]))
            return %false
        end
        
        if nargin > 1
            for i = 1:size(R,3)
                RR = R(:,:,i);
                % check transpose is inverse
                e = RR'*RR - eye(2,2);
                if norm(e) > 10*eps
                    return %false
                end
                % check determinant is +1
                e = abs(det(RR) - 1);
                if norm(e) > 10*eps
                    return %false
                end
            end
        end
    end
    
    h = true;

end