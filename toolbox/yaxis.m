%YAYIS	set Y-axis scaling
%
% YAXIS(MAX) set y-axis scaling from 0 to MAX.
%
% YAXIS(MIN, MAX) set y-axis scaling from MIN to MAX.
%
% YAXIS([MIN MAX]) as above.
%
% YAXIS restore automatic scaling for y-axis.
%
% See also YAXIS.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function yaxis(a1, a2)
	if nargin == 0
		set(gca, 'YLimMode', 'auto')
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

	set(gca, 'YLimMode', 'manual', 'YLim', [mn mx])
end