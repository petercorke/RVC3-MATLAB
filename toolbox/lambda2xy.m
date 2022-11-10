% XY = LAMBDA2XY(LAMBDA) is the xy-chromaticity coordinate (1x2) for 
% illumination at the specific wavelength LAMBDA [metres]. If LAMBDA is a
% vector (Nx1), then P (Nx2) is a vector whose elements are the luminosity 
% at the corresponding elements of LAMBDA.
%
% XY = LAMBDA2XY(LAMBDA, E) is the rg-chromaticity coordinate (1x2) for an 
% illumination spectrum E (Nx1) defined at corresponding wavelengths
% LAMBDA (Nx1).
%
% References::
%  - Robotics, Vision & Control, Section 10.2,
%    P. Corke, Springer 2011.
%
% See also CMFXYZ, LAMBDA2RG.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function [x,y] = lambda2xy(lambda, varargin)
    cmf = cmfxyz(lambda, varargin{:});

    xy = tristim2cc(cmf);
    if nargout == 2
        x = xy(:,1);
        y = xy(:,2);
    else
        x = xy;
    end

