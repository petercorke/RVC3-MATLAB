function rotate_axis(axis, toward, along, radius, angrange, label, origin)


    % draw the arc
    r = toward;
    %n = [0 0 1];
    n = cross(axis, toward);
    p0 = origin-along*axis;

    thm = angrange*pi/180;

    th = [-1:0.02:1]*thm;

    cxyz = [];
    for t=th
        p = p0 + radius*(r*cos(t) + n*sin(t));
        cxyz = [cxyz; p(:)'];
    end
    hold on
    plot3(cxyz(:,1), cxyz(:,2), cxyz(:,3), 'r');

    % draw the arrow head
    a = 0.8;
    p1 = p0 + a*radius*(r*cos(thm*a) + n*sin(thm*a));
    p2 = p0 + (2-a)*radius*(r*cos(thm*a) + n*sin(thm*a));

    pt = cxyz(end,:);
    xyz = [pt; p1];
    plot3(xyz(:,1), xyz(:,2), xyz(:,3), 'r');
    xyz = [pt; p2];
    plot3(xyz(:,1), xyz(:,2), xyz(:,3), 'r');

    % add the label
    p1 = view()*[cxyz(1,:)'; 1];
    p2 = view()*[cxyz(end,:)'; 1];
    if p1(1)-p2(1) < 0
        text(pt(1), pt(2), pt(3), ['  ' label]);
    else
        text(pt(1), pt(2), pt(3), [label '  '], 'HorizontalAlignment', 'right');
    end
    


    view(25, 25);

