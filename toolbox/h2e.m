%H2E Homogeneous to Euclidean 
%
% E = H2E(H) is the Euclidean version (NxK-1) of the homogeneous 
% points H (NxK) where each row represents one point in P^K.
%
% Reference::
% - Robotics, Vision & Control: Second Edition, P. Corke, Springer 2016; p604.
%
% See also E2H.

% Copyright (C) 1993-2019 Peter I. Corke


function e = h2e(h)
    % This requires NAV toolbox!
    % e = hom2cart(h')';
    e = h(:,1:end-1) ./ repmat(h(:,end), 1, size(h,2)-1);

end

