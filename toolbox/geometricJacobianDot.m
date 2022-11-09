%geometricJacobianDot Derivative of Jacobian
%
% JDQ = geometricJacobianDot(ROBOT, Q, QD) is the product (6x1) of the
% derivative of the Jacobian (in the world frame) and the joint rates. The
% last body in ROBOT is considered to be the end effector.
%
% Notes:: - This term appears in the formulation for operational space
% control XDD = J(Q)QDD + JDOT(Q)QD - Written as per the reference and not
% very efficient.
%
% References:: - Fundamentals of Robotics Mechanical Systems (2nd ed)
%   J. Angleles, Springer 2003.
% - A unified approach for motion and force control of robot manipulators:
% The operational space formulation
%  O Khatib, IEEE Journal on Robotics and Automation, 1987.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function Jdot = geometricJacobianDot(robot, q, qd)
	%n = robot.n;
    links = robot.Bodies;

    % Using the notation of Angeles:
    %   [Q,a] ~ [R,t] the per link transformation
    %   P ~ R   the cumulative rotation t2r(Tj) in world frame
    %   e       the last column of P, the local frame z axis in world coordinates
    %   w       angular velocity in base frame
    %   ed      deriv of e
    %   r       is distance from final frame
    %   rd      deriv of r
    %   ud      ??

    % "n" is the velocity number, i.e. the number of non-fixed joints
    n = 0;

    for i=1:robot.NumBodies
        %T = links(i).A(q(i));
        if string(links{i}.Joint.Type) == "fixed"
            continue;
        end
        n = n + 1;
        T = se3(robot.getTransform(q, links{i}.Name, links{i}.Parent.Name));        
        Q{n} = t2r(T);
        a{n} = transl(T)';
    end

    P{1} = Q{1};
    e{1} = [0 0 1]';
    for i=2:n
        P{i} = P{i-1}*Q{i};
        e{i} = P{i}(:,3);
    end

    % step 1
    w{1} = qd(1)*e{1};
    for i=1:(n-1)
        w{i+1} = qd(i+1)*[0 0 1]' + Q{i}'*w{i};
    end

    % step 2
    ed{1} = [0 0 0]';
    for i=2:n
        ed{i} = cross(w{i}, e{i});
    end

    % step 3
    rd{n} = cross( w{n}, a{n});
    for i=(n-1):-1:1
        rd{i} = cross(w{i}, a{i}) + Q{i}*rd{i+1};
    end

    r{n} = a{n};
    for i=(n-1):-1:1
        r{i} = a{i} + Q{i}*r{i+1};
    end

    ud{1} = cross(e{1}, rd{1});
    for i=2:n
        ud{i} = cross(ed{i}, r{i}) + cross(e{i}, rd{i});
    end

    % step 4
    %  swap ud and ed
    v{n} = qd(n)*[ud{n}; ed{n}];
    for i=(n-1):-1:1
        Ui = blkdiag(Q{i}, Q{i});
        v{i} = qd(i)*[ud{i}; ed{i}] + Ui*v{i+1};
    end

    Jdot = v{1};
end