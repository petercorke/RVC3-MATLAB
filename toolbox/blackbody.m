%BLACKBODY Compute blackbody emission spectrum
%
% E = BLACKBODY(LAMBDA, T) is the blackbody radiation power density [W/m^3]
% at the wavelength LAMBDA [m] and temperature T [K].
%
% If LAMBDA is a column vector (Nx1), then E is a column vector (Nx1) of
% blackbody radiation power density at the corresponding elements of
% LAMBDA.
%
% Example::
%         l = [380:10:700]'*1e-9; % visible spectrum
%         e = blackbody(l, 6500); % emission of sun
%         plot(l, e)
%
% References::
%  - Robotics, Vision & Control, Section 10.1,
%    P. Corke, Springer 2011.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function e = blackbody(lam, T)
    % physical constants
    c = 2.99792458e8; % m/s         (speed of light)
    h = 6.626068e-34; % m2 kg / s   (Planck's constant)
    k = 1.3806503e-23; % J K-1      (Boltzmann's constant)

    lam = lam(:);

    e = 2*h*c^2 ./ (lam.^5 .* (exp(h*c/k/T./lam) - 1));
