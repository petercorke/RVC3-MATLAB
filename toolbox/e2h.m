%E2H Euclidean to homogeneous
%
% H = E2H(E) is the homogeneous version (NxK+1) of the Euclidean 
% points E (NxK) where each row represents one point in R^K.
%
% Reference::
% - Robotics, Vision & Control: Second Edition, P. Corke, Springer 2016;
% p604.
%
% See also H2E.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function h = e2h(e)
  % This requires NAV toolbox!
  % h = cart2hom(e')';
  h = [e ones(size(e,1),1)];
end
