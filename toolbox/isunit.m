%ISUNIT Test if vector has unit length
%
% ISUNIT(V) is true (1) if the vector has unit length.  A tolerance of 
% TOL*EPS is applied, and by default TOL=100.
%

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function s = isunit(vec, tol)
    arguments
        vec double
        tol (1,1) double = 100
    end

    s = abs(norm(vec)-1) < tol*eps;
end
