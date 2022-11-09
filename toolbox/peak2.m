%PEAK2  Find peaks in a matrix
%
% ZP = PEAK2(Z, OPTIONS) are the peak values in the 2-dimensional signal Z.
%
% [ZP,IJ] = PEAK2(Z, OPTIONS) as above but also returns the indices of the 
% maxima in the matrix Z.  Use SUB2IND to convert these to row and column 
% coordinates
%
% Options::
% 'npeaks',N    Number of peaks to return (default 2)
% 'scale',S     Only consider as peaks the largest value in the horizontal 
%               and vertical range +/- S points.
% 'interp'      Interpolate peak (default no interpolation)
% 'plot'        Display the interpolation polynomial overlaid on the point data
%
% Notes::
% - A maxima is defined as an element that larger than its eight neighbours.
%   Edges elements will never be returned as maxima.
% - To find minima, use PEAK2(-V).
% - The interp options fits points in the neighbourhood about the peak with
%   a paraboloid and its peak position is returned.  In this case IJ will 
%   be non-integer.
%
% See also PEAK, SUB2IND.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function [zp,xypout, aout] = peak2(z, varargin)

    % process input options
    opt.npeaks = 2;
    opt.scale = 1;
    opt.interp = false;
    
    [opt,args] = tb_optparse(opt, varargin);
    
    
    % create a neighbourhood mask for non-local maxima
    % suppression
    h = opt.scale;
    w = 2*h+1;
    M = ones(w,w);
    M(h+1,h+1) = 0;
    
    % compute the neighbourhood maximum
    znh = imdilate(double(z), M);
    
    % find all pixels greater than their neighbourhood
    k = find(z > znh);
    
    
    % sort these local maxima into descending order
    [zpk,ks] = sort(z(k), 'descend');

    k = k(ks);
    
    npks = min(length(k), opt.npeaks);
    k = k(1:npks);
    
    [y,x] = ind2sub(size(z), k);
    xy = [x y]';
    

    % interpolate the peaks if required
    if opt.interp
        
        
        xyp = [];
        zp = [];
        ap = [];
               
        % for each previously identified peak x(i), y(i)
        for xyt=xy
            % fit a polynomial to the local neighbourhood
            try
                
                x = xyt(1); y = xyt(2);

                
                % now try to interpolate the peak over a 3x3 window
                
                zc = z(y,   x);
                zn = z(y-1, x);
                zs = z(y+1, x);
                ze = z(y,   x+1);
                zw = z(y,   x-1);
                
                dx = (ze - zw)/(2*(2*zc - ze - zw));
                dy = (zn - zs)/(2*(zn - 2*zc + zs));

                zest = zc - (ze - zw)^2/(8*(ze - 2*zc + zw)) - (zn - zs)^2/(8*(zn - 2*zc + zs));
                
                aest = min(abs([ze/2 - zc + zw/2, zn/2 - zc + zs/2]));

                
            catch
                % handle situation where neighbourhood falls off the data
                % vector
                warning('Peak at (%d,%d) too close to edge of image, skipping', x, y);
                continue;
            end
            %
            
            % store x, y for the refined peak
            xyp = [xyp [x+dx; y+dy]];
            zp = [zp zest];
            ap = [ap aest];

        end
    else
        % no interpolation case
        xyp = xy;
        zp = z(k)';
        ap = [];

    end
    
    
    % return values
    if nargout > 1
        xypout = xyp;
    end
    if nargout > 2
        aout = ap;
    end
        



    
   
