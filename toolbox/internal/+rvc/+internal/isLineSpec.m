function isLS = isLineSpec(s)
%ISLINESPEC Determine if input character array is a linespec
%   See LineSpec definition in https://www.mathworks.com/help/matlab/ref/plot.html
%   documentation.

% Copyright 2025 Peter Corke, Witold Jachimczyk, Remo Pillat

%#ok<*AGROW>

s = convertStringsToChars(s);

if ~ischar(s)
    isLS = false;
    return;
end

s2 = '';

% get color
removeMask = false(1, length(s));
[b,e] = regexp(s, '[rgbcmywk]');
for j = 1:numel(b)
    s2 = [s2,s(b(j):e(j))]; 
    removeMask(b(j):e(j)) = true;
end
s(removeMask) = [];

% get line style
removeMask = false(1, length(s));
[b,e] = regexp(s, '(--)|(-.)|-|:');
for j = 1:numel(b)
    s2 = [s2,s(b(j):e(j))];
    removeMask(b(j):e(j)) = true;
end
s(removeMask) = [];

% get marker style
removeMask = false(1, length(s));
[b,e] = regexp(s, '[o\+\*\.xsd\^v><ph]');
for j = 1:numel(b)
    s2 = [s2,s(b(j):e(j))];
    removeMask(b(j):e(j)) = true;
end
s(removeMask) = [];

% This is a LineSpec if all characters from s have been removed
isLS = isempty(s);

end

