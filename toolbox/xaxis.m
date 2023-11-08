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

function xaxis(a1, a2)

    if nargin == 0
        set(gca, 'XLimMode', 'auto')
        return
    elseif nargin == 1
        if length(a1) == 1
            mn = 0;
            mx = a1;
        elseif length(a1) == 2
            mn = a1(1);
            mx = a1(2);
        end
    elseif nargin == 2
        mn = a1;
        mx = a2;
    end
    
    set(gca, 'XLimMode', 'manual', 'XLim', [mn mx])

end