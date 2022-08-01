close all
clear
panda = loadrobot("frankaEmikaPanda", DataFormat="row");

qr = [0, -0.3, 0, -2.2, 0, 2, 0.7854, 0, 0];

%% Subfigure (a) - Standard show
figure
panda.show(qr)

xlim([-0.5 0.75]);
ylim([-0.5 0.5]);
zlim([0 1]);

% Use opengl option here to ensure that frames show up correctly
rvcprint("opengl", subfig="_a")

%% Subfigure (b) - Link highlight
% NOTE: This will not automatically publish, since you have to manually
% click to select the hand link. Uncomment this to regenerate the figure

% figure;
% panda.show(qr, "Frames", "off");
% 
% xlim([-1.1755    1.4613])
% ylim([-1.5905    1.0462])
% zlim([-0.8228    1.8139])
% 
% set(gcf, "Position", [1000 918 410 420])
% 
% input("Manually zoom in and click on the panda_hand")
% 
% rvcprint("opengl", subfig="_b")

