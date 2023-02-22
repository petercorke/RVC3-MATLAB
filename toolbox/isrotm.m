%ISROTM Test if value is SO(3) rotation matrix
%
% ISROTM(R) is true (1) if the argument is of dimension 3x3 or 3x3xN, else
% false (0).
%
% ISROTM(R, check=true) as above, but also checks the validity of the
% rotation matrix.
%
% Notes::
% - A valid rotation sub-matrix R has R'*R = I and det(R)=1.
% - The first form is a fast, but incomplete, test that a transform belong
%   to SO(3).
%
% See also ISTFORM, ISROTM2, ISVEC.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function h = isrotm(R, options)
    arguments
        R
        options.check (1,1) logical = false
    end

    h = false;

    if ~isnumeric(R)
        return
    end

    d = size(R);
    if ~(all(d(1:2) == [3 3]))
        return %false
    end
        

    if options.check
        for i = 1:size(R,3)
            RR = R(:,:,i);
            % check transpose is inverse
            e = RR'*RR - eye(3,3);
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

    
    h = true;

end