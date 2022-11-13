
% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function showcam(c, T, P)
    
    if nargin < 2
        T = c.T;
    end
    
    T = se3(T);
    
    clf
    axis([-3, 3, -3, 3, -3 3])
    daspect([1 1 1])
    hold on
    grid
    [x,y,z] = sphere(20);
    
    
    hg = hgtransform;
    surf(x,y,z, 'FaceColor', [0.8 0.8 1], 'EdgeColor', 0.5*[0.8 0.8 1], ...
        'EdgeLighting', 'gouraud', 'Parent', hg)
    light
    lighting gouraud
    set(hg, 'Matrix', T.tform);
    
    trplot(T, 'length', 1.6, 'arrow')
    
    axis
    limits = reshape(axis, 2, []);
    maxdim = max(diff(limits));
    
    o = T.t;
    
    if nargin > 2
        for i=1:numcols(P)
            plot3([o(1) P(1,i)], [o(2) P(2,i)], [o(3) P(3,i)], 'r');
            plot_sphere(P(:,i), maxdim*0.02, 'r');
        end
    end
    hold off
    xlabel('x'); ylabel('y'); zlabel('z');
