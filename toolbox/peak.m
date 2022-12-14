%PEAK Find peaks in vector
%
% YP = PEAK(Y, OPTIONS) are the values of the maxima in the vector Y.
%
% [YP,I] = PEAK(Y, OPTIONS) as above but also returns the indices of the maxima
% in the vector Y.
%
% [YP,XP] = PEAK(Y, X, OPTIONS) as above but also returns the corresponding 
% x-coordinates of the maxima in the vector Y.  X is the same length as Y
% and contains the corresponding x-coordinates.
%
% Options::
% 'npeaks',N    Number of peaks to return (default all)
% 'scale',S     Only consider as peaks the largest value in the horizontal 
%               range +/- S points.
% 'interp',M    Order of interpolation polynomial (default no interpolation)
% 'plot'        Display the interpolation polynomial overlaid on the point data
%
% Notes::
% - A maxima is defined as an element that larger than its two neighbours.
%   The first and last element will never be returned as maxima.
% - To find minima, use PEAK(-V).
% - The interp options fits points in the neighbourhood about the peak with
%   an M'th order polynomial and its peak position is returned.  Typically
%   choose M to be even.  In this case XP will be non-integer.
%
% See also PEAK2.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function [yp,xpout] = peak(y, varargin)

    % process input options
    opt.npeaks = [];
    opt.scale = 1;
    opt.interp = 0;
    opt.plot = false;
    
    [opt,args] = tb_optparse(opt, varargin);
    
    
    % if second argument is a matrix we take this as the corresponding x
    % coordinates
    if ~isempty(args)
        x = args{1};
        x = x(:);
        assert(length(x) == length(y), 'RTB:peak:interp', 'second argument must be same length as first');
    else
        x = [1:length(y)]';
    end
    
    y = y(:);
    
    % find the maxima
    if opt.scale > 1
        % compare to a moving window max filtered version
%         k = find(y' == filt1d(y, 'max', 'width', opt.scale*2+1));
            k = find(y == movmax(y, opt.scale*2+1));
    else
        % take the zero crossings
        dv = diff(y);
        k = find( ([dv; 0]<0) & ([0; dv]>0) );
    end
    
    % sort the maxima into descending magnitude
    [m,i] = sort(y(k), 'descend');
    k = k(i);    % indice of the maxima

    if opt.npeaks
        np = min(length(k), opt.npeaks);
        k = k(1:np);
    end

    % optionally plot the discrete data
    if opt.plot
        plot(x, y, '-o');      
        hold on
    end
    

    % interpolate the peaks if required
    if opt.interp
        assert(opt.interp >= 2, 'RTB:peak:badarg',  'interpolation polynomial must be at least second order');
        
        xp = [];
        yp = [];
        N = opt.interp;
        N2 = round(N/2);

        % for each previously identified peak x(i), y(i)
        for i=k'
            % fit a polynomial to the local neighbourhood
            try
                pp = polyfit(x(i-N2:i+N2), y(i-N2:i+N2), N);
            catch
                % handle situation where neighbourhood falls off the data
                % vector
                warning('Peak at %f too close to start or finish of data, skipping', x(i));
                continue;
            end
            
            % find the roots of the polynomial closest to the coarse peak
            r = roots( polyder(pp) );
            [mm,j] = min(abs(r-x(i)));
            xx = r(j);
            
            % store x, y for the refined peak
            xp = [xp; xx];
            yp = [y; polyval(pp, xx)];
            
            if opt.plot
                % overlay the fitted polynomial and refined peak
                xr = linspace(x(i-N2), x(i+N2), 50);
                plot(xr, polyval(pp, xr), 'r');
                plot(xx, polyval(pp, xx), 'rd');
            end
        end
    else
        xp = x(k);
    end
    
    if opt.plot
        grid
        xlabel('x');
        ylabel('y');
        hold off
    end
    
    % return values
    yp = y(k)';
    if nargout > 1
        xpout = xp';
    end
