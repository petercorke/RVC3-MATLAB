% line class
% constructor from 2 points, save these
% plot method, draws line within current axis bounds
%     error if no bounds
% methods .L, .P, .v, .w

% 
% side operator is zero when lines are parallel

function plucker4
    %two points
P = [1 3 4]'
Q = [2 5 7]'
    
    U = Q-P;
    U = unit(U);
    %V = cross(Q, P);
    V = cross(U, P);
    
    
    pl = [U; V]
    
    bounds = [-5 6 -4 7 -3 11];
    
    clf
    axis(bounds);
        plot2([P Q]', 'sk');

    grid on
    hold on
%     for lam=[dd(1):0.05:dd(2)]
%         p = P+lam*U;
%         plot3(p(1), p(2), p(3), '.');
%     end

% find the bounds and plot them
line.v = U;
line.p = P;
        P = intersect_volume(bounds, line)

    plot3(P(1,:), P(2,:), P(3,:), 'b')
    plot3(P(1,1), P(2,1), P(3,1), 'bx')
    plot3(P(1,2), P(2,2), P(3,2), 'bx')

        axis(bounds);


    %U = U/2; V = V/2;
    L = [cross(V,U); dot(U,U)]
    LL = L / L(4);
    
    plot3(LL(1), LL(2), LL(3), 'o');
    plot3([0 LL(1)], [0 LL(2)], [0 LL(3)], 'r');
    
  
end

function [P,dd] = intersect_volume(bounds, line)
    tt = [];
    
    % reshape, top row is minimum, bottom row is maximum
    bounds = reshape(bounds, [2 3]);
    
    for face=1:6
        % for each face of the bounding volume
        
        i = ceil(face/2);  % 1,2,3
        I = eye(3,3);
        plane.n = I(:,i);
        plane.p = [0 0 0]';
        plane.p(i) = bounds(face);
        [p,t] = intersect_line_plane(line, plane);
        
        if isempty(p)
            continue;  % no intersection
        end
        
        k = (p' > bounds(1,:)) & (p' < bounds(2,:));
        k(i) = [];
        if all(k)
            tt = [tt t];
        end
    end
    tt
    tt = sort(tt);
    
    P = bsxfun(@plus, line.p, line.v*tt);
end

function [p,t] = intersect_line_plane(line, plane)
    % intersection of plane (n,p) with the line (v,p)
    % returns point and line parameter
    dvn = dot(line.v, plane.n);
    
    if abs(dvn) > (100*eps)
        t = dot( plane.p-line.p, plane.n) / dot(line.v, plane.n);
        p = line.p + t*line.v;
    else
        p = [];
        t = [];
    end
end

