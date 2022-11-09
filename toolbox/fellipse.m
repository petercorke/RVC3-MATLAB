%fellipse Force ellipsoid for seriallink manipulator
%
% fellipse(R, Q, OPTIONS) displays the force ellipsoid for the 
% robot R at pose Q.  The ellipsoid is centered at the tool tip position.
%
% Options::
% '2d'       Ellipse for translational xy motion, for planar manipulator
% 'trans'    Ellipsoid for translational motion (default)
% 'rot'      Ellipsoid for rotational motion
%
%  Display options as per plot_ellipse to control ellipsoid face and edge
% color and transparency.
%
% Example::
%  To interactively update the force ellipsoid while using sliders
%  to change the robot's pose:
%          robot.teach('callback', @(r,q) fellipse(r,q))
%
% Notes::
% - The ellipsoid is tagged with the name of the robot prepended to
%   ".fellipse".
% - Calling the function with a different pose will update the ellipsoid.
%
% See also vellipse, plotellipse.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function fellipse(robot, q, varargin)
    
    if isa(robot, "ETS2") || isa(robot, "ETS3")
        rbt = ets2rbt(robot);
    else
        rbt = robot;
    end

    % Calculate a unique hash for the input object that can be used as tag
    % for the ellipse
    name = [char(mlreportgen.utils.hash(char(getByteStreamFromArray(robot)))) 'vellipse'];
    
    e = findobj('Tag', name);
    
    if isempty(q)
        delete(e);
        return;
    end
    
    opt.mode = {'trans', 'rot', '2d'};
    opt.deg = false;
    [opt,args] = tb_optparse(opt, varargin);
    
    if opt.deg
        % in degrees mode, scale the columns corresponding to revolute axes
        q = deg2rad(q);
    end
    if robot.n == 2
        opt.mode = '2d';
    end
    
    % TODO: Allow user to specify end effector
    ee = rbt.Bodies{end}.Name;
    J = rbt.geometricJacobian(q, ee);
    
    switch opt.mode
        case'2d'
            J = J(4:5,1:2);
        case 'trans'
            J = J(4:6,:);
        case 'rot'
            J = J(1:3,:);
    end
    
    JJ = J*J';
    if det(JJ) < 100*eps
        warning('RTB:fellipse:badval', 'Jacobian is singular, ellipse cannot be drawn')
        return
    end
    
    N = inv(JJ);
    
    %t = transl(robot.fkine(q));
    t = se3(rbt.getTransform(q, ee)).trvec;
    
    switch opt.mode
        case '2d'
            if isempty(e)
                plotellipse(N, t(1:2), 'edgecolor', 'r', 'Tag', name, args{:});
            else
                plotellipse(N, t(1:2), 'alter', e);
            end
        otherwise
            if isempty(e)
                plotellipse(N, t(1:3), 'edgecolor', 'k', 'fillcolor', 'r', 'alpha', 0.5, 'Tag', name, args{:});
            else
                plotellipse(N, t(1:3), 'alter', e);
            end
    end
end
