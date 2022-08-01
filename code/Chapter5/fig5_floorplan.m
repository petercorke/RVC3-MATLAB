close all; clear;
load house
floorMap = binaryOccupancyMap(flipud(floorplan));
bug = Bug2(floorMap);

p = bug.run(places.br3, places.kitchen);
bug.plot(p)
bug.plot_mline()

for location=fieldnames(places)'
    switch location{1}
        case 'br3'
            % This is the start point. Plot a blue circle.
            plotpoint(places.(location{1}), 'bo', 'bold', 'textcolor', ...
                'blue', 'label', ['  ' location{1}], 'MarkerSize', 12, ...
                'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue')
        
        case 'kitchen'
            % This is the end point. Plot a blue star.
            plotpoint(places.(location{1}), 'pk', 'bold', 'textcolor', ...
                'blue', 'label', ['  ' location{1}], 'MarkerSize', 12, ...
                'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue')

        otherwise
            % All other locations are empty black stars 
            plotpoint(places.(location{1}), 'pk', 'label', ['  ' location{1}], 'MarkerSize', 12)
    end
end

rvcprint("nogrid");



