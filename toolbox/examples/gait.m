function q = gait(cycle, k, phi, flip)

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

k = mod(k+phi-1, size(cycle,1)) + 1;
q = cycle(k,:);
if flip
    q(1) = -q(1);   % for left-side legs
end

end
