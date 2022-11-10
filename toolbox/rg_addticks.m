%RG_ADDTICKS Label spectral locus
%
% RG_ADDTICKS() adds wavelength ticks to the spectral locus.
%
% See also XYCOLOURSPACE.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function rg_addticks(lam1, lam2, lamd)

    % well spaced points around the locus
    lambda = [460:10:540];
    lambda = [lambda 560:20:600];

    rgb = cmfrgb(lambda*1e-9);        
    r = rgb(:,1)./sum(rgb')';    
    g = rgb(:,2)./sum(rgb')';    
    hold on
    plot(r,g, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6)
    hold off

    for i=1:size(lambda,2)
        text(r(i), g(i), sprintf('  %d', lambda(i)));
    end

