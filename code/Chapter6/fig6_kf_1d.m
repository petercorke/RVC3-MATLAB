close all; clear;

% This requires Sensor Fusion & Tracking Toolbox and
% Statistics & Machine Learning Toolbox

initialState = 2;
initialVariance = 0.25;

%% Subfigure (a) - Simple state propagation with no process noise

% Set up 1-D Kalman Filter with simple identity for 
% process and measurement.
kf = trackingKF(1,1,1);

% Set initial state and variance
kf.State = initialState;
kf.StateCovariance = initialVariance;

kf.ProcessNoise = 0;

% Simulate odometry movement
kf.predict(2);

% Extract and plot different states and variances
figure;
x = 0:0.1:8;
y0 = normpdf(x,initialState,sqrt(initialVariance));
y1 = normpdf(x,kf.State,sqrt(kf.StateCovariance));
pl0 = plot(x,y0); hold on
pl1 = plot(x,y1, LineStyle="--");
yInitState = normpdf(initialState,initialState,sqrt(initialVariance));
yPredState = normpdf(kf.State,kf.State,sqrt(kf.StateCovariance));

% Plot the mean as well
plot(initialState, yInitState, ...
    Color=pl0.Color, LineStyle="none", Marker="o", MarkerSize=8, LineWidth=2);
plot(kf.State, yPredState, ...
    Color=pl1.Color, LineStyle="none", Marker="o", MarkerSize=8, LineWidth=2);

% Indicate odometry vector
quiver(2, 0.3, 2, 0, 0, Color="black", MaxHeadSize=0.15)
text(4.1,0.3,"odometry", FontSize=12)

legend(["PDF at step k", "Predicted PDF at k+1", "Mean at step k", ...
    "Predicted mean at k+1"]);

% General figure tidiness
ylim([0 1]);
xlabel("x");
ylabel("PDF");

rvcprint("painters", thicken=2, subfig="_a")


%% Subfigure (b) - Use process noise variance of 0.5
kf.State = 2;
kf.ProcessNoise = 0.5;
kf.predict(2);

figure;
y2 = normpdf(x,kf.State,sqrt(kf.StateCovariance));
yPredState = normpdf(kf.State,kf.State,sqrt(kf.StateCovariance));

pl2 = plot(x,y0); hold on
pl3 = plot(x,y2, LineStyle="--");

% Plot the mean as well
plot(initialState, yInitState, ...
    Color=pl2.Color, LineStyle="none", Marker="o", MarkerSize=8, LineWidth=2);
plot(kf.State, yPredState, ...
    Color=pl3.Color, LineStyle="none", Marker="o", MarkerSize=8, LineWidth=2);

l = legend(["PDF at step k", "Predicted PDF at k+1", "Mean at step k", ...
    "Predicted mean at k+1"]);

% General figure tidiness
ylim([0 1]);
xlabel("x");
ylabel("PDF");

rvcprint("painters", thicken=2, subfig="_b")