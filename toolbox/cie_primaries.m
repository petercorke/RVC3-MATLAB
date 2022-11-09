%CIE_PRIMARIES Define CIE primary colors
%
% P = CIE_PRIMARIES() is a 3-vector with the wavelengths [m] of the
% CIE 1976 red, green and blue primaries respectively.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function p = cie_primaries

    p = [700, 546.1, 435.8]*1e-9;
