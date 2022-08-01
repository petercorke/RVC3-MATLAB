% line class
% constructor from 2 points, save these
% plot method, draws line within current axis bounds
%     error if no bounds
% methods .L, .P, .v, .w

% 
% side operator is zero when lines are parallel

function plucker2
    %two points
P = [1 3 4]'
Q = [2 5 7]'
    
    U = Q-P;
    U = unit(U);
    %V = cross(Q, P);
    V = cross(U, P);
    
    
    pl = [U; V]
    
    bounds = [-5 5 -5 5 -5 5];
    
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
        P = findextent(bounds, U, P);

    plot3(P(1,:), P(2,:), P(3,:), 'b')
    plot3(P(1,1), P(2,1), P(3,1), 'bx')
    plot3(P(1,2), P(2,2), P(3,2), 'bx')

    
    %U = U/2; V = V/2;
    L = [cross(V,U); dot(U,U)]
    LL = L / L(4);
    
    
    plot3(LL(1), LL(2), LL(3), 'o');
    plot3([0 LL(1)], [0 LL(2)], [0 LL(3)], 'r');
    
  
end

function [P,dd] = findextent(bounds, v, L)
    dd = [];
    for i=1:6
        d = intersect2(i, bounds, v, L);
        dd = [dd d];
    end
    dd = sort(dd);
    
    P = bsxfun(@plus, L, v*dd);
end

function dd = intersect2(dim, bounds, v, L)
    n = [0 0 0]';
    ax = ceil(dim/2);
    n(ax) = 1;
    P = [0 0 0]';
    P(ax) = bounds(dim);
    
    [p,d] = intersect(n, P, v, L);
    
    dd = [];
    if p
        % finite intersection point
        r = test(ax, p, bounds);
        if r
            dd = [dd d];
        end  
    end
end

    function r = test(w, p, bounds)
        r = false;
        if (w ~= 1) && (p(1) < bounds(1))
            return
        end
        if (w ~= 1) && (p(1) > bounds(2))
            return
        end
        if (w ~= 2) && (p(2) < bounds(3))
            return
        end
        if (w ~= 2) && (p(2) > bounds(4))
            return
        end
        if (w ~= 3) && (p(3) < bounds(5))
            return
        end
        if (w ~= 3) && (p(3) > bounds(6))
            return
        end
        r = true;
    end
    
    
function [p,d] = intersect(n, P, v, L)
    % intersection of plane with normal n and point P with the line
    % direction v and point L
    dvn = dot(v,n);
    
    if abs(dvn) > (100*eps)
        d = dot( P-L, n) / dot(v, n);
        p = L+d*v;
    else
        p = [];
        d = [];
    end
    
end
    