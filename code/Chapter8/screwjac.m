function J = screwjac(robot, q)

    T = robot.base;

    % compute the joint twists
    for j=1:robot.n

        link = robot.links(j);
        
        if link.isrevolute
            tw(j) = Twist('R', T.SO3.a, T.t);
        else
            tw(j) = Twist('P', T.SO3.a, T.t);
        end
           
        T = T * link.A(0);
    end
    
    A = SE3;
    J = [];
    for j=1:robot.n

        J(:,j) = A.Ad * tw(j).S;
                
        A = A * SE3( tw(j).T(q(j)) );
    end
    
    
    TE = robot.fkine(q);
    TEi = inv(TE);
    
%     J
%     blkdiag(TE.R, TE.R) * TEi.Ad
%     J = blkdiag(TE.R, TE.R) * TEi.Ad * J
    disp('J')
	J
    
%     disp('Ad * J')
%     Jn = TEi.Ad * J

    V = eye(6,6);
    %V(1:3,4:6) = -TE.R*skew(TE.R'*TE.t)*TE.R';
    V(1:3,4:6) = -skew(TE.t);

    disp('T * J')
    J = V*J
    
    disp('RTB jacob0')
    robot.jacob0(q)