%PLOT2 Plot trajectories
%
% Convenience function for plotting 2D or 3D trajectory data stored in a
% matrix with one row per time step.
%
% PLOT2(P) plots a line with coordinates taken from successive rows of P(Nx2 or Nx3).
%
% If P has three dimensions, ie. Nx2xM or Nx3xM then the M trajectories are
% overlaid in the one plot.
%
% PLOT2(P, LS) as above but the line style arguments LS are passed to plot.
%
% See also MPLOT, PLOT.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function h = plot2(p1, varargin)

if ismatrix(p1)
    switch size(p1, 2)
        case 3
            hh = plot3(p1(:,1), p1(:,2), p1(:,3), varargin{:});
        case 2
            hh = plot(p1(:,1), p1(:,2), varargin{:});
        otherwise
            error('SMTB:plot2:badarg', 'Data must have 2 or 3 columns');
    end
    if nargout == 1
        h = hh;
    end
else
    clf
    hold on
    for i=1:size(p1,2)
        plot2( squeeze(p1(:,:,i)) );
    end
end

end