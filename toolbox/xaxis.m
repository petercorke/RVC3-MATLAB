%XAXIS  Set X-axis scaling
%
% XAXIS(MAX) set x-axis scaling from 0 to MAX.
%
% XAXIS(MIN, MAX) set x-axis scaling from MIN to MAX.
%
% XAXIS([MIN MAX]) as above.
%
% XAXIS restore automatic scaling for x-axis.
%
% See also YAXIS.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function xaxis(varargin)

    opt.all = false;
    [opt,args] = tb_optparse(opt, varargin);
    
    if isempty(args)
        [x,y] = ginput(2);
        mn = x(1);
        mx = x(2);
    elseif length(args) == 1
        if length(args{1}) == 1
            mn = 0;
            mx = args{1};
        elseif length(args{1}) == 2
            mn = args{1}(1);
            mx = args{1}(2);
        end
    elseif length(args) == 2
        mn = args{1};
        mx = args{2};
    end

    if opt.all
        for a=get(gcf,'Children')',
            if strcmp(get(a, 'Type'), 'axes') == 1,
                set(a, 'XLimMode', 'manual', 'XLim', [mn mx])
                set(a, 'YLimMode', 'auto')
            end
        end
    else
        set(gca, 'XLimMode', 'manual', 'XLim', [mn mx])
        set(gca, 'YLimMode', 'auto')
    end