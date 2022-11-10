% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function [w,mx] = manipulability(robot, q, ee, varargin)

    opt.method = {'yoshikawa', 'asada'};
    opt.axes = {'all', 'trans', 'rot'};
    opt.dof = [];

    % Determine end effector automatically, if not provided by the user
    if nargin < 3 || isempty(ee)
        ee = robot.Bodies{end}.Name;
    end
    
    opt = tb_optparse(opt, varargin);
    
    if nargout == 0
        opt.axes = 'trans';
        mt = manipulability(robot, q, ee, 'setopt', opt);
        opt.axes = 'rot';
        mr = manipulability(robot, q, ee, 'setopt', opt);
        for i=1:size(mt,1)
        fprintf('Manipulability: translation %g, rotation %g\n', mt(i), mr(i));
        end
        return;
    end
    
    if isempty(opt.dof)
        switch opt.axes
            case 'trans'
                dof = [0 0 0 1 1 1];
            case 'rot'
                dof = [1 1 1 0 0 0];
            case 'all'
                dof = [1 1 1 1 1 1];
        end
    else
        dof = opt.dof;
    end
    
    opt.dof = logical(dof);

    if strcmp(opt.method, 'yoshikawa')
        w = zeros(size(q,1),1);
        for i=1:size(q,1)
            w(i) = yoshi(robot, ee, q(i,:), opt);
        end
    elseif strcmp(opt.method, 'asada')
        w = zeros(size(q,1),1);
        if nargout > 1
            dof = sum(opt.dof);
            MX = zeros(dof,dof,size(q,1));
            for i=1:size(q,1)
                [ww,mm] = asada(robot, q(i,:), ee, opt);
                w(i) = ww;
                MX(:,:,i) = mm;
            end
        else
            for i=1:size(q,1)
                w(i) = asada(robot, ee, q(i,:), opt);
            end
        end
    end

    if nargout > 1
        mx = MX;
    end
end

function m = yoshi(robot, ee, q, opt)
    J = robot.geometricJacobian(q, ee);
    
    J = J(opt.dof,:);
    m2 = det(J * J');
    m2 = max(0, m2);    % clip it to positive
    m = sqrt(m2);
end

function [m, mx] = asada(robot, ee, q, opt)
    J = robot.geometricJacobian(q, ee);
    
    if rank(J) < 6
        warning('robot is in degenerate configuration')
        m = 0;
        return;
    end

    Ji = pinv(J);
    % TODO: Should be inertiaMatrix
    M = robot.massMatrix(q);
    Mx = Ji' * M * Ji;
    d = find(opt.dof);
    Mx = Mx(d,d);
    e = eig(Mx);
    m = min(e) / max(e);

    if nargout > 1
        mx = Mx;
    end
end