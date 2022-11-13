% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

% Define images to process
imageFileNames = {'/usr/local/MATLAB/R2021a/toolbox/vision/visiondata/calibration/gopro/gopro01.jpg',...
    '/usr/local/MATLAB/R2021a/toolbox/vision/visiondata/calibration/gopro/gopro02.jpg',...
    '/usr/local/MATLAB/R2021a/toolbox/vision/visiondata/calibration/gopro/gopro03.jpg',...
    '/usr/local/MATLAB/R2021a/toolbox/vision/visiondata/calibration/gopro/gopro04.jpg',...
    '/usr/local/MATLAB/R2021a/toolbox/vision/visiondata/calibration/gopro/gopro05.jpg',...
    '/usr/local/MATLAB/R2021a/toolbox/vision/visiondata/calibration/gopro/gopro06.jpg',...
    '/usr/local/MATLAB/R2021a/toolbox/vision/visiondata/calibration/gopro/gopro07.jpg',...
    '/usr/local/MATLAB/R2021a/toolbox/vision/visiondata/calibration/gopro/gopro08.jpg',...
    '/usr/local/MATLAB/R2021a/toolbox/vision/visiondata/calibration/gopro/gopro09.jpg',...
    '/usr/local/MATLAB/R2021a/toolbox/vision/visiondata/calibration/gopro/gopro10.jpg',...
    '/usr/local/MATLAB/R2021a/toolbox/vision/visiondata/calibration/gopro/gopro11.jpg',...
    };
% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates of the corners of the squares
squareSize = 25;  % in units of 'millimeters'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera using fisheye parameters
[cameraParams, imagesUsed, estimationErrors] = estimateFisheyeParameters(imagePoints, worldPoints, ...
    [mrows, ncols], ...
    'EstimateAlignment', false, ...
    'WorldUnits', 'millimeters');

% View reprojection errors
h1=figure; showReprojectionErrors(cameraParams);

% Visualize pattern locations
h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortFisheyeImage(originalImage, cameraParams.Intrinsics, 'ScaleFactor', 0.9);

% Show the results
imshow(originalImage)
rvcprint3('fig13_9a');
imshow(undistortedImage)
rvcprint3('fig13_9b');
