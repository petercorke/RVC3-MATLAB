%RPY2JAC Jacobian from RPY angle rates to angular velocity
%
% J = RPY2JAC(YPR, OPTIONS) is a Jacobian matrix (3x3) that maps ZYX yaw-pitch-roll angle
% rates to angular velocity at the operating point RPY=[Y,P,R].
%
% J = RPY2JAC(Y, P, R, OPTIONS) as above but the yaw-pitch-roll angles are passed
% as separate arguments.
%
% Options::
% 'xyz'     Use XYZ roll-pitch-yaw angles
% 'yxz'     Use YXZ roll-pitch-yaw angles
%
% Notes::
% - Used in the creation of an analytical Jacobian.
% - Angles in radians, rates in radians/sec.
%
% Reference::
% - Robotics, Vision & Control: Second Edition, P. Corke, Springer 2016; p232-3.
%
% See also eul2jac, rpy2r, SerialLink.jacobe.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function J = rpy2jac(r, varargin)

opt.order = {'zyx', 'xyz', 'yxz'};
[opt,args] = tb_optparse(opt, varargin);


% unpack the arguments
if size(r,2) == 3
    p = r(:,2);
    y = r(:,1);
%     roll = r(:,1);
elseif nargin >= 3
    p = args{1};
    y = r;
    % roll = args{2}
else
    error('RVC3:rpy2jac:badarg', 'bad arguments')
end


switch opt.order
    case 'xyz'
        J = [
            sin(p)          0       1
            -cos(p)*sin(y)  cos(y)  0
            cos(p)*cos(y)   sin(y)  0
            ];

    case 'zyx'
        J = [
            cos(p)*cos(y), -sin(y), 0
            cos(p)*sin(y),  cos(y), 0
            -sin(p),       0, 1
            ];

    case 'yxz'
        J = [
            cos(p)*sin(y),  cos(y), 0
            -sin(p),       0, 1
            cos(p)*cos(y), -sin(y), 0
            ];
end

end

%{
    syms r p y rd pd yd wx wy wz real
    syms rt(t) pt(t) yt(t) 

    order = 'yxz'

    R = rpy2r(r, p, y, order);
    Rt = rpy2r(rt, pt, yt, order);
    dRdt = diff(Rt, t);
    dRdt = subs(dRdt, {diff(rt(t),t), diff(pt(t),t), diff(yt(t),t),}, {rd,pd,yd});
    dRdt = subs(dRdt, {rt(t),pt(t),yt(t)}, {r,p,y});
    dRdt = formula(dRdt)   % convert symfun to an array

    w = skew2vec(dRdt * R');
    w = simplify(w)

    clear A
    rpyd = [rd pd yd];

    for i=1:3
        for j=1:3
            C = coeffs(w(i), rpyd(j));
            if length(C) == 1
                A(i,j) = 0;
            else
            A(i,j) = C(2);
            end
        end
    end

    A
%}
