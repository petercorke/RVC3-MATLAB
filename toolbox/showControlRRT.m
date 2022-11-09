% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function showControlRRT(p, solnInfo, map, start, goal)

% TODO: Make function more configurable (similar to Peter's other
% visualization functions with tb_optparse)
if ~isempty(map)
    map.show;
    
    % Remove the title, e.g. from binaryOccupancyMap
    title("");
end
hold on;

% Draw the tree
plot(solnInfo.TreeInfo(1,:),solnInfo.TreeInfo(2,:),'.-', MarkerSize=12);

% Draw the path
plotPath = p.copy;
plotPath.interpolate;
plot(plotPath.States(:,1),plotPath.States(:,2),'r-','LineWidth',3);

% Draw the start and goal configuration
% Use similar settings as in Navigation base class
startmarker = {'bo','MarkerFaceColor', 'k', 'MarkerEdgeColor', 'w', 'MarkerSize', 12};
goalmarker =  {'bp', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'w', 'MarkerSize', 18};
plot(start(1), start(2), startmarker{:});
plot(goal(1), goal(2), goalmarker{:});

% Draw vehicle to indicate heading
plotvehicle(start(1:3), "box", "scale", 1/25, "edgecolor", "k", "linewidth", 2);
plotvehicle(goal(1:3), "box", "scale", 1/25, "edgecolor", "k", "linewidth", 2);

% Draw some intermediate configurations (if needed)
% for i = 1:size(p.States,1)
%     plotvehicle(p.States(i,:), "box", "scale", 1/25, "edgecolor", [0.5 0.5 0.5], "linewidth", 1);
% end

hold off;

end

