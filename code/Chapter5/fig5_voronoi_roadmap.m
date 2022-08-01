close all; clear;
load house

%% Subfigure (a) - Free space
% make the free space
free = 1 - floorplan;

free(1,:) = 0; free(end,:) = 0;
free(:,1) = 0; free(:,end) = 0;
%free = flipud(free);       % All IPT functions expect reversed y-axis
figure; imshow(free);
xlabel("x"); ylabel("y");
axis on
set(gca, "Ydir", "normal")

rvcprint("subfig", "_a", "nogrid", "painters");

%% Subfigure (b) - Skeleton image
% skeletonise it
skeleton = bwmorph(free, "skel", inf);
figure; imshow(skeleton);
xlabel("x"); ylabel("y");
axis on
set(gca, "Ydir", "normal")

rvcprint("subfig", "_b", "nogrid", "painters");

%% Subfigure (c) - Skeleton + obstacles
figure; 
% Have to create an indexed image (uint8), so imshow can handle colormap properly
% 0 = free space
% 1 = obstacle
% 2 = skeleton
idxImage = uint8(floorplan + 2*double(skeleton));
% Colormap needs to have 255 rows, but only first 3 matter
cmap = [1 1 1; 1 0 0; 0 0 0; repmat([0 0 0], 252, 1)];

imshow(idxImage, "Colormap", cmap);
xlabel("x"); ylabel("y");
axis on
set(gca, "Ydir", "normal")
rvcprint("subfig", "_c", "nogrid", "painters");

%% Subfigure (d) - Distance transform
distTrans = bwdist(1-free);
figure; imshow(distTrans, [])
xlabel("x"); ylabel("y");
colormap gray
brighten(0.5);
axis on
set(gca, "Ydir", "normal")
rvcprint("subfig", "_d", "nogrid", "painters");
