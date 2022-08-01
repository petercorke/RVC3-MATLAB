function TE = screwfk(robot, q)
    
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
   
    % end effector pose at zero joint coordinates TE(0)
    M = robot.fkine(zeros(1,robot.n));
    
    % compute the product of exponentials
    TE = SE3;
    for j=1:robot.n
        TE = TE * tw(j).T(q(j));
    end
    TE = TE*M;
    
    
    TE
    robot.fkine(q)
    
    end