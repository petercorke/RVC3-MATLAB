%LOADSPECTRUM Load spectrum data
%
% S = LOADSPECTRUM(LAMBDA, FILENAME) is spectral data (NxD) from file
% FILENAME interpolated to wavelengths [metres] specified in LAMBDA (Nx1).
% The spectral data can be scalar (D=1) or vector (D>1) valued.
%
% [S,LAMBDA] = LOADSPECTRUM(LAMBDA, FILENAME) as above but also returns the 
% passed wavelength LAMBDA.
%
% Notes::
% - The file is assumed to have its first column as wavelength in metres, the 
%   remainding columns are linearly interpolated and returned as columns of S.
% - The files are kept in the private folder inside the MVTB folder.
%
% References::
%  - Robotics, Vision & Control, Section 14.3,
%    P. Corke, Springer 2011.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function [s,lam] = loadspectrum(lambda, filename, varargin)

    opt.verbose = true;
    opt.interp = {'spline', 'linear'};
    
    opt = tb_optparse(opt, varargin);

    filename = char(filename); % handle strings
    if isempty(strfind(filename, '.'))
        filename = [filename '.dat'];
    end
    
    lambda = lambda(:);
    tab = load(filename);
    assert(~isempty(tab), 'Spectral file %s not found', filename);

    s = interp1(tab(:,1), tab(:,2:end), lambda, opt.interp, 0);

    
    if nargout == 2
        lam = lambda;
    end
