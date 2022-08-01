function [tw,theta] = tr2twist(T)
    
    % closed form solution for matrix logarithm of a homogeneous transformation (Park & Lynch)
    % that handles the special cases
    
    % for now assumes T0 is the world frame
    
    [R,t] = tr2rt(T);
    
    if abs(trace(R) - 3) < 100*eps
        % matrix is identity
                disp('identity rotation')

        w = [0 0 0]';
        v = unit(t);
        theta = norm(t);
    elseif abs(trace(R) + 1) < 100*eps
        % tr R = -1
        % rotation by +/- pi, +/- 3pi etc
        disp('tr(R) = -1')
        
        theta = pi;
        
        skw = logm(R);
        w = vex( skw );

        Ginv = eye(3,3)/theta - skw/2 + ( 1/theta - cot(theta/2)/2 )*skw^2;
        v = Ginv * t;
    else
        % general case
        disp('general case')
        theta = acos( (trace(R)-1)/2 )
        
        skw = (R-R')/2/sin(theta);
        w = vex(skw);   % is a unit vector
        
        Ginv = eye(3,3)/theta - skw/2 + ( 1/theta - cot(theta/2)/2 )*skw^2;
        v = Ginv * t;
    end
    
    [w; v]
    
    S = logm(T)
    w = vex(S(1:3,1:3));
    theta = norm(w);
    w = unit(w)
    v = S(1:3,4) / theta   
%     [th,w] = tr2angvec(R);
%     w = w'
%     
%     d = dot(unit(w), transl(T))
%     h = d / th
%     
%     q = (transl(T) - h*th*w ) * inv(eye(3,3) - R)
%     
%     v = 
%     rho = (eye(3,3) - R')*t / 2 / (1-cos(th));
%     
%     v = cross(rho, w);
%     
%     tw = [skew(unit(w)) v'; 0 0 0  0];