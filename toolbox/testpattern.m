%TESTPATTERN Create test images
%
% IM = TESTPATTERN(TYPE, D, ARGS) creates a test pattern image.  If D is a
% scalar the image is DxD else D=[W H] the image is WxH.  The image is specified by the
% string TYPE and one or two (type specific) arguments:
%
% 'rampx'     intensity ramp from 0 to 1 in the x-direction. ARGS is the number
%             of cycles.
% 'rampy'     intensity ramp from 0 to 1 in the y-direction. ARGS is the number
%             of cycles.
% 'sinx'      sinusoidal intensity pattern (from -1 to 1) in the x-direction. 
%             ARGS is the number of cycles.
% 'siny'      sinusoidal intensity pattern (from -1 to 1) in the y-direction. 
%             ARGS is the number of cycles.
% 'dots'      binary dot pattern.  ARGS are dot pitch (distance between 
%             centers); dot diameter.
% 'squares'   binary square pattern.  ARGS are pitch (distance between 
%             centers); square side length.
% 'line'      a line.  ARGS are theta (rad), intercept.
%   
% Examples::
%
% A 256x256 image with 2 cycles of a horizontal sawtooth intensity ramp:
%      testpattern('rampx', 256, 2);
%
% A 256x256 image with a grid of dots on 50 pixel centers and 20 pixels in
% diameter:
%      testpattern('dots', 256, 50, 25);
%
% Notes::
% - With no output argument the testpattern in displayed using idisp.
%
% See also IDISP.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat


function Z = testpattern(type, w, varargin)

    if length(w) == 1
        z = zeros(w);
    elseif length(w) == 2
        z = zeros(w(2), w(1));
    end
    
    switch type,
    case {'sinx'}
        if nargin > 2,
            ncycles = varargin{1};
        else
            ncycles = 1;
        end
        x = 0:(size(z,2)-1);
        clength = size(z,2)/ncycles;
        z = repmat( sin(x/(clength)*ncycles*2*pi), size(z,1), 1);

    case {'siny'}
        if nargin > 2
            ncycles = varargin{1};
        else
            ncycles = 1;
        end
        clength = size(z,1)/ncycles;
        y = [0:(size(z,1)-1)]';
        z = repmat( sin(y/(clength)*ncycles*2*pi), 1, size(z,1));
        
    case {'rampx'}
        if nargin > 2
            ncycles = varargin{1};
        else
            ncycles = 1;
        end
        clength = size(z,2)/ncycles;
        x = 0:(size(z,2)-1);
        z = repmat( mod(x, clength) / (clength-1), size(z,1), 1);
        
    case {'rampy'}
        if nargin > 2
            ncycles = varargin{1};
        else
            ncycles = 1;
        end
        clength = size(z,1)/ncycles;
        y = [0:(size(z,1)-1)]';
        z = repmat( mod(y, clength) / (clength-1), 1, size(z,2));
        
    case {'line'}
        % args:
        %   angle intercept
        nr = size(z,1);
        nc = size(z,2);
        c = varargin{2};
        theta = varargin{1};

        if abs(tan(theta)) < 1,
            x = 1:nc;
            y = round(x*tan(theta) + c);
            
            s = find((y >= 1) & (y <= nr));

        else
            y = 1:nr;
            x = round((y-c)/tan(theta));
            
            s = find((x >= 1) & (x <= nc));

        end
        for k=s,    
            z(y(k),x(k)) = 1;
        end
        
    case {'squares'}
        % args:
        %   pitch diam 
        nr = size(z,1);
        nc = size(z,2);
        d = varargin{2};
        pitch = varargin{1};
        if d > (pitch/2),
            fprintf('warning: squares will overlap\n');
        end
        rad = floor(d/2);
        d = 2*rad;
        for r=pitch/2:pitch:(nr-pitch/2)
            for c=pitch/2:pitch:(nc-pitch/2),
                z(r-rad:r+rad,c-rad:c+rad) = ones(d+1);
            end
        end
        
    case {'dots'}
        % args:
        %   pitch diam 
        nr = size(z,1);
        nc = size(z,2);
        d = varargin{2};
        pitch = varargin{1};
        if d > (pitch/2)
            fprintf('warning: dots will overlap\n');
        end
        rad = floor(d/2);
        d = 2*rad;
        s = kcircle(d/2);
        for r=pitch/2:pitch:(nr-pitch/2),
            for c=pitch/2:pitch:(nc-pitch/2),
                z(r-rad:r+rad,c-rad:c+rad) = s;
            end
        end
        
    otherwise
        disp('Unknown pattern type')
        im = [];
    end

    if nargout == 0
        idisp(z);
    else
        Z = z;
    end
