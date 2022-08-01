function out = uncertainty(sigma, centres, highlight)
    z = zeros(100, 100);

    if nargin < 2
        centres = [30, 40]';
    end
    
    for c = centres
    z = z + gauss2d(z, sigma, c);
    end
    
    clf
    surf(z)
    zlim = get(gca, 'Zlim');
    zlim(1) = -zlim(2);
    clf
    axis([0 100 0 100 zlim]);
    hold on
    surfc(z)
%     plot3(20, 20, z(20,20), '*')
%     plot3([20 20], [20 20], [0 z(20,20)], '-*')

[X,Y] = meshgrid(1:size(z,2), 1:size(z,1));
for r=1:5:size(X,1)
    k = sub2ind(size(z), Y(r,:), X(r,:));
        plot3(X(r,:), Y(r,:), z(k), 'Color', 0.5*[1 1 1])
    end
for c=1:5:size(X,2)
        k = sub2ind(size(z), Y(:,c),X(:,c));

        plot3(X(:,c), Y(:,c), z(k), 'Color', 0.5*[1 1 1])
end
    
    light
    lighting gouraud
    shading interp
    colormap(spring)
    grid
    xyzlabel
    zlabel('Probability density')
    
    if nargin > 2
    zlim = get(gca, 'ZLim');
        plot3(highlight(1)*[1 1], highlight(2)*[1 1], zlim, 'k', 'LineWidth', 1);
    end
    hold off
