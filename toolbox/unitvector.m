%UNITVECTOR Unitize a vector
%
% VN = UNITVECTOR(V) is a unit-vector parallel to V.
%
% Note::
% - Reports error for the case where V is non-symbolic and norm(V) is zero

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function u = unit(v)
n = norm(v, 'fro');
assert( isa(v, 'sym') || n > eps , 'RVC3:unitvector:zero_norm', 'vector has zero norm');

u = v / n;
end
