% Fig 11.13a
imshow(K, [], 'InitialMagnification', 800);
axis on;
xlabel('u (pixels)'); ylabel('v (pixels)');
rvcprint3('fig11_13a');
close all

surfl(-15:15, -15:15, K)

% Fig 11.13b
h = 15;
surf(-h:h, -h:h, K, K);  shading faceted; 
set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
rvcprint3('fig11_13b');

K = fspecial('disk',8);

% Fig 11.13c
K = padarray(K, [7 7], 0, 'both');
surf(-h:h, -h:h, K, K);  shading faceted; 
set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
rvcprint3('fig11_13c');

% Fig 11.13d
K = kdgauss(5);
surf(-h:h, -h:h, K, K);  shading faceted; 
set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
rvcprint3('fig11_13d');


% Fig 11.13e
K = fspecial('log',31, 5);
% K = padarray(K, [7 7], 0, 'both');
surf(-h:h, -h:h, K, K);  shading faceted; 
set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
rvcprint3('fig11_13e');

% Fig 11.13f
K = kdog(5);
surf(-h:h, -h:h, K, K);  shading faceted; 
set(gca, 'XLimMode', 'manual', 'Xlim', [-15 15], 'YLimMode', 'manual', 'Ylim', [-15 15]); xlabel('u'); ylabel('v');
rvcprint3('fig11_13f');

close all;