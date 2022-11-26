close all; clear;

sl_rrmc
r = sim("sl_rrmc");

t = r.tout;
q = r.yout;

%% Subfigure (a) - Joint motions
figure;
s = stackedplot(t, q(:,1:3), ...
    DisplayLabels=["q1", "q2", "q3"], ...
    GridVisible=1, XLabel="Time");
s.LineWidth = 1.5;
s.AxesProperties(1).YLimits = [0 0.5];
s.AxesProperties(2).YLimits = [0.78 0.82];
s.AxesProperties(3).YLimits = [3.05 3.17];

% Make figure a bit taller, so it looks
figPos = get(gcf, "Position");
figPos(2) = figPos(2) - 200;
figPos(4) = 550;
set(gcf, "Position", figPos);
% s.FontSize = 10;

rvcprint("painters", "nobgfix", subfig="_a")

%% Subfigure (b) - Cartesian motion
figure;

Tfk = repmat(se3, 1, size(q,1));
for i = 1:size(q,1)
    Tfk(i) = se3(puma.getTransform(q(i,:), "link6"));
end

s = stackedplot(t, Tfk.trvec, ...
    DisplayLabels=["x", "y", "z"], ...
    GridVisible=1, XLabel="Time");
s.LineWidth = 1.5;

% Make figure a bit taller, so it looks
set(gcf, "Position", figPos);

rvcprint("painters", "nobgfix", subfig="_b")
