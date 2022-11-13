%COLORNAME Map between color names and RGB values
%
% RGB = COLORNAME(NAME) is the RGB-tristimulus value (1x3) corresponding to
% the color specified by the string NAME.  If RGB is a cell-array (1xN) of
% names then RGB is a matrix (Nx3) with each row being the corresponding
% tristimulus.
%
% XYZ = COLORNAME(NAME, 'xyz') as above but the XYZ-tristimulus value
% corresponding to the color specified by the string NAME.
%
% XY = COLORNAME(NAME, 'xy') as above but the xy-chromaticity coordinates
% corresponding to the color specified by the string NAME.
%
% NAME = COLORNAME(RGB) is a string giving the name of the color that is
% closest (Euclidean) to the given RGB-tristimulus value (1x3).  If RGB is
% a matrix (Nx3) then return a cell-array (1xN) of color names.
%
% NAME = COLORNAME(XYZ, 'xyz') as above but the color is the closest
% (Euclidean) to the given XYZ-tristimulus value.
%
% NAME = COLORNAME(XYZ, 'xy') as above but the color is the closest
% (Euclidean) to the given xy-chromaticity value with assumed Y=1.
%
% Notes::
% - Color name may contain a wildcard, eg. "?burnt"
% - Based on the standard X11 color database rgb.txt.
% - Tristimulus values are in the range 0 to 1

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function out = colorname(a, varargin)

    if isstring(a)
      a = char(a); % deal with strings
    end
  
    opt.space = {'rgb', 'xyz', 'xy', 'lab', 'ab'};
    opt = tb_optparse(opt, varargin);

    persistent  rgbtable;
        
    % ensure that the database is loaded
    if isempty(rgbtable)
        % load mapping table from file
        fprintf('loading rgb.txt\n');
        f = fopen('data/rgb.txt', 'r');
        k = 0;
        rgb = [];
        names = {};
        xy = [];
        
        while ~feof(f)
            line = fgets(f);
            if line(1) == '#',
                continue;
            end
            
            [A,count,errm,next] = sscanf(line, '%d %d %d');
            if count == 3
                k = k + 1;
                rgb(k,:) = A' / 255.0;
                names{k} = lower( strtrim(line(next:end)) );
            end
        end
        s.rgb = rgb;
        s.names = names;
        rgbtable = s;
    end
    
    if isstr(a)
        % map name to rgb/xy
        if a(1)  == '?' 
            % just do a wildcard lookup
            out = namelookup(rgbtable, a(2:end), opt);
        else
            out = name2color(rgbtable, a, opt);
        end
    elseif iscell(a)
        % map multiple names to colorspace
        out = [];
        for name=a
            color = name2color(rgbtable, name{1}, opt);
            if isempty(color)
                warning('Color %s not found', name{1});
            end
            out = [out; color];
        end
    else
        % map values to strings
        out = string([]);

        switch opt.space
            case {'rgb', 'xyz', 'lab'}
                assert(size(a,2) == 3, 'Color value must have 3 elements');
                % convert reference colors to input color space
                table = colorspace(['RGB->' opt.space], rgbtable.rgb);
                for color=a'
                    d = distance(color, table');
                    [~,k] = min(d);
                    out = [out string(rgbtable.names{k})];
                end
                        
            case {'xy', 'ab'}
                assert(size(a,2) == 2, 'Color value must have 2 elements');
                % convert reference colors to input color space
                
                switch opt.space
                    case 'xy'
                        table = colorspace('RGB->XYZ', rgbtable.rgb);
                        table = table(:,1:2) ./ (sum(table,2)*[1 1]);
                    case 'ab'
                        table = colorspace('RGB->Lab', rgbtable.rgb);
                        table = table(:,2:3);
                end
                
                for color=a'
                    d = distance(color, table');
                    [~,k] = min(d);
                    out = [out string(rgbtable.names{k})];
                end
                
        end
    end
end
    
function r = namelookup(table, s, opt)
    s = lower(s);   % all matching done in lower case
    
    r = string([]);
    count = 1;
    for k=1:length(table.names),
        if ~isempty( findstr(table.names{k}, s) )
            r(count) = string(table.names{k});
            count = count + 1;
        end
    end
end

function out = name2color(table, s, opt)

    s = lower(s);   % all matching done in lower case
    
    for k=1:length(table.names),
        if strcmp(s, table.names(k)),
            rgb = table.rgb(k,:);
            switch opt.space
                case {'rgb', 'xyz', 'lab'}
                    out = colorspace(['RGB->' opt.space], rgb);
                case 'xy'
                    XYZ = colorspace('RGB->XYZ', rgb);
                    out = tristim2cc(XYZ);
                case 'ab';
                    Lab = colorspace('RGB->Lab', rgb);
                    out = Lab(2:3);
            end
            return;
        end
    end
    out = [];
end

%DISTANCE Euclidean distances between sets of points
%
% D = DISTANCE(A,B) is the Euclidean distances between L-dimensional points
% described by the matrices A (LxM) and B (LxN) respectively.  The distance 
% D is MxN and element D(I,J) is the distance between points A(I) and B(J).
%
% Example:: 
%    A = rand(400,100); B = rand(400,200);
%    d = distance(A,B);
%
% Notes::
% - This fully vectorized (VERY FAST!)
% - It computes the Euclidean distance between two vectors by:
%         ||A-B|| = sqrt ( ||A||^2 + ||B||^2 - 2*A.B )
%
% Author::
%  Roland Bunschoten,
%  University of Amsterdam,
%  Intelligent Autonomous Systems (IAS) group,
%  Kruislaan 403  1098 SJ Amsterdam,
%  tel.(+31)20-5257524,
%  bunschot@wins.uva.nl
%  Last Rev: Oct 29 16:35:48 MET DST 1999,
%  Tested: PC Matlab v5.2 and Solaris Matlab v5.3,
%  Thanx: Nikos Vlassis.
%
% See also CLOSEST.

function d = distance(a,b)

if (nargin ~= 2)
   error('Not enough input arguments');
end

if (size(a,1) ~= size(b,1))
   error('A and B should be of same dimensionality');
end

aa=sum(a.*a,1); bb=sum(b.*b,1); ab=a'*b; 
d = sqrt(abs(repmat(aa',[1 size(bb,2)]) + repmat(bb,[size(aa,2) 1]) - 2*ab));

end
