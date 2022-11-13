% [R,Q] = vgg_rq(S)  Just like qr but the other way around.
%
% If [R,Q] = vgg_rq(X), then R is upper-triangular, Q is orthogonal, and X==R*Q.
% Moreover, if S is a real matrix, then det(Q)>0.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function [U,Q] = vgg_rq(S)

S = S';
[Q,U] = qr(S(end:-1:1,end:-1:1));
Q = Q';
Q = Q(end:-1:1,end:-1:1);
U = U';
U = U(end:-1:1,end:-1:1);

if det(Q)<0
  U(:,1) = -U(:,1);
  Q(1,:) = -Q(1,:);
end

return
