bdclose all; close all; clear;

% Simulate model and get outputs
r = sim("sl_lanechange");
tout = r.find("t");
yout = r.find("y");

%% Subfigure (a)
figure
s = stackedplot(tout, yout(:,2:4), ...
    "DisplayLabels", ["y", "theta", "psi"], ...
    "GridVisible", 1, "XLabel", "Time");

% "thicken" option doesn't work for stackedplot, so manually set thickness
% Do this before setting all the YLabel properties below, because
% s.LineWidth will reset those settings
s.LineWidth = 1.5;
drawnow % drawnow ensures that all graphics updates are applied

% Use workaround to get larger labels and Latex labels
idx = findNodeChildIdxForAxesProp(s, "YLabel", "theta");
s.NodeChildren(idx).YLabel.String = "\theta";
s.NodeChildren(idx).YLabel.FontSize = 15;
s.NodeChildren(idx).YLabel.Interpreter = "Tex";
drawnow

idx = findNodeChildIdxForAxesProp(s, "YLabel", "psi");
s.NodeChildren(idx).YLabel.String = "\psi";
s.NodeChildren(idx).YLabel.FontSize = 15;
s.NodeChildren(idx).YLabel.Interpreter = "Tex";
drawnow

% Odd update behavior forces me to reset the font size and interpreter
% after changing any YLabel string
idx = findNodeChildIdxForAxesProp(s, "YLabel", "\theta");
s.NodeChildren(idx).YLabel.FontSize = 15;
s.NodeChildren(idx).YLabel.Interpreter = "Tex";
idx = findNodeChildIdxForAxesProp(s, "YLabel", "\psi");
s.NodeChildren(idx).YLabel.FontSize = 15;
s.NodeChildren(idx).YLabel.Interpreter = "Tex";
drawnow

% Adjust size of "y" label
idx = findNodeChildIdxForAxesProp(s, "YLabel", "y");
s.NodeChildren(idx).YLabel.FontSize = 15;
drawnow

% Make the "Time" x label a bit bigger
idx = findNodeChildIdxForAxesProp(s, "XLabel", "Time");
s.NodeChildren(idx).XLabel.FontSize = 12;
drawnow

rvcprint("subfig", "_a", "nobgfix")

%% Subfigure (b)
figure
plot(yout(:,1), yout(:,2)); grid;
xlabel("Time")
ylabel("y")
rvcprint("subfig", "_b", "thicken", 1.5)

function idx = findNodeChildIdxForAxesProp(stackedLineChart, propName, searchString)
% Find index of NodeChildren array for an Axes with a given property string
    idx = 0;
    for i = 1:length(stackedLineChart.NodeChildren)
        child = stackedLineChart.NodeChildren(i);
        if ~isa(child, "matlab.graphics.axis.Axes")
            continue;
        end

        if string(child.(propName).String) == string(searchString)
            % Found the desired property valie!
            idx = i;
            break;
        end
    end
end