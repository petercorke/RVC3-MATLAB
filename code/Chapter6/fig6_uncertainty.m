close all; clear;

%% Subfigure (a) - Single hypothesis with small sigma
figure;
uncertainty(3, [30, 40]', [20 20]);
view(-38.7,20.4);

% Add more light and change colormap
camlight;
colormap("default");

% Set figure window position to make sure we get better axis labels
set(gcf, "Position", [58   383   642   460]);
rvcprint("opengl", subfig="_a");

%% Subfigure (b) - Single hypothesis with larger sigma
figure;
uncertainty(20, [30 40]', [20 20]);
view(-38.7,20.4)
colormap("default");
set(gcf, "Position", [58   383   642   460]);
rvcprint("opengl", subfig="_b");

%% Subfigure (c) - Multiple hypotheses with small sigma
figure;
uncertainty(4, [35 56; 30 40; 66 23; 55 62]');
view(-38.7,20.4)
camlight;
colormap("default");
set(gcf, "Position", [58   383   642   460]);
rvcprint("opengl", subfig="_c");

