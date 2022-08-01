close all; clear;

ekf_slam_run

%% Subfigure (a) - Covariance versus time
figure
ekf.plotP
set(gca, yscale="log")
grid on
xlabel("Time step")
rvcprint("painters", subfig="_a", thicken=1.5);

%% Subfigure (b) - Covariance matrix
figure
ekf.show_P
rvcprint("painters", subfig="_b");