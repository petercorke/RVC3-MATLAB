close all; clear;

% This requires Sensor Fusion & Tracking Toolbox and
% Statistics & Machine Learning Toolbox

initialState = 2;
initialVariance = 0.25;

%% Subfigure (a) - State estimation with sensor reading

% Set up 1-D Kalman Filter with simple identity for 
% process and measurement.
kf = trackingKF(1,1,1);

kf.State = 2;
kf.StateCovariance = initialVariance;
kf.ProcessNoise = 0.5;
[x_pred, P_pred] = kf.predict(2);

% Use measurement noise variance of 1
% Correct with sensor measurement
sensorVariance = 1;
sensorMeas = 5;
kf.MeasurementNoise = sensorVariance;
[x_corr, P_corr] = kf.correct(sensorMeas);

figure;
x = 0:0.1:8;
yInit = normpdf(x,initialState,sqrt(initialVariance));
yPred = normpdf(x,x_pred,sqrt(P_pred));
yCorr = normpdf(x,x_corr,sqrt(P_corr));
ySens = normpdf(x,sensorMeas,sqrt(sensorVariance));
yInitState = normpdf(initialState,initialState,sqrt(initialVariance));
yPredState = normpdf(x_pred,x_pred,sqrt(P_pred));
yCorrState = normpdf(x_corr,x_corr,sqrt(P_corr));
ySensState = normpdf(sensorMeas,sensorMeas,sqrt(sensorVariance));

plInit = plot(x,yInit); hold on
plPred = plot(x,yPred, LineStyle="--");
plSens = plot(x,ySens, LineStyle=":");
plCorr = plot(x,yCorr, LineStyle="-.");

% Plot the mean as well
plot(initialState, yInitState, ...
    Color=plInit.Color, LineStyle="none", Marker="o", MarkerSize=8, LineWidth=2);
plot(x_pred, yPredState, ...
    Color=plPred.Color, LineStyle="none", Marker="o", MarkerSize=8, LineWidth=2);
plot(sensorMeas, ySensState, ...
    Color=plSens.Color, LineStyle="none", Marker="o", MarkerSize=8, LineWidth=2);
plot(x_corr, yCorrState, ...
    Color=plCorr.Color, LineStyle="none", Marker="o", MarkerSize=8, LineWidth=2);

l = legend(["PDF at step k", "Predicted PDF at k+1", "Sensor PDF at k+1", ...
    "Corrected PDF at k+1"]);
l.Position = [0.5993    0.7553    0.3000    0.1655];

% General figure tidiness
ylim([0 1]);
xlabel("x");
ylabel("PDF");

rvcprint("painters", thicken=2, subfig="_a")


%% Subfigure (b) - State estimation with low-variance sensor reading
kf.State = 2;
[x_pred, P_pred] = kf.predict(2);

% Change sensor variance to smaller value
sensorVariance = 0.4;
kf.MeasurementNoise = sensorVariance;
[x_corr, P_corr] = kf.correct(sensorMeas);
 
figure;
yCorr = normpdf(x,x_corr,sqrt(P_corr));
ySens = normpdf(x,sensorMeas,sqrt(sensorVariance));
yCorrState = normpdf(x_corr,x_corr,sqrt(P_corr));
ySensState = normpdf(sensorMeas,sensorMeas,sqrt(sensorVariance));

plInit = plot(x,yInit); hold on
plPred = plot(x,yPred, LineStyle="--");
plSens = plot(x,ySens, LineStyle=":");
plCorr = plot(x,yCorr, LineStyle="-.");

% Plot the mean as well
plot(initialState, yInitState, ...
    Color=plInit.Color, LineStyle="none", Marker="o", MarkerSize=8, LineWidth=2);
plot(x_pred, yPredState, ...
    Color=plPred.Color, LineStyle="none", Marker="o", MarkerSize=8, LineWidth=2);
plot(sensorMeas, ySensState, ...
    Color=plSens.Color, LineStyle="none", Marker="o", MarkerSize=8, LineWidth=2);
plot(x_corr, yCorrState, ...
    Color=plCorr.Color, LineStyle="none", Marker="o", MarkerSize=8, LineWidth=2);

l = legend(["PDF at step k", "Predicted PDF at k+1", "Sensor PDF at k+1", ...
    "Corrected PDF at k+1"]);
l.Position = [0.5993    0.7553    0.3000    0.1655];

% General figure tidiness
ylim([0 1]);
xlabel("x");
ylabel("PDF");

rvcprint("painters", thicken=2, subfig="_b")
