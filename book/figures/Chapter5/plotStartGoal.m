function plotStartGoal(qs, qg, startSize, goalSize)
%plotStartGoal  Add special start and goal markers

if nargin < 3
    startSize = 10;
end
if nargin < 4
    goalSize = 14;
end

startmarker = {'bo','MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k', 'MarkerSize', startSize};
goalmarker =  {'bp', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k', 'MarkerSize', goalSize};
plot(qs(1), qs(2), startmarker{:});
plot(qg(1), qg(2), goalmarker{:});
end