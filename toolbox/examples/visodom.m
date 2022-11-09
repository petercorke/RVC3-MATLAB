
function visodom
%% Visual odometry example
%   - stereo camera

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

if ~exist("doVisodomFigures", "var")
    doVisodomFigures = false;
end

close all

%% read images
tformFcn = @(in) imcrop(im2uint8(imadjust(in)), [17 17 730 460]);
left  = imageDatastore(fullfile(rvctoolboxroot,"examples","visodom", "left"));
left  = left.transform(tformFcn);

right = imageDatastore(fullfile(rvctoolboxroot,"examples","visodom", "right"));
right = right.transform(tformFcn);

% % ###############################################################################
% % # Camera parameter file                                                       #
% % ###############################################################################
% % 
% % [INTERNAL]
% % F        =  985.939 # [pixel] focal length
% % SX       =  1.0     # [pixel] pixel size in X direction
% % SY       =  1.0     # [pixel] pixel size in Y direction
% % X0       =  390.255 # [pixel] X-coordinate of principle
% % Y0       =  242.329 # [pixel] Y-coordinate of principle
% % 
% % [EXTERNAL]
% % B        =  0.20    # [m] width of baseline of stereo camera rig
% % X        = -0.83    # [m] distance of rectified images (virtual camera)
% % Y        =  0.00    # [m] lateral position of rectified images (virtual camera)
% % Z        =  1.28    # [m] height of rectified images (virtual camera)
% % TILT     =  0.0062  # [rad] tilt angle
% % YAW      =  0.0064  # [rad] yaw angle
% % ROLL     =  0.0009  # [rad] roll angle
% % 
% % # Notes:
% % #  In a stereo camera system the internal parameters for both cameras are the
% % #  same.
% % #
% % #  The camera position (X, Y, Z) is given in car coordinates.
% % #  For the definition of the camera and car coordinate system and the rotation 
% % #  angles see the image carcameracoord.png.

%%

f        =  985.939; % [pixel] focal length
u0       =  390.255; % [pixel] X-coordinate of principle
v0       =  242.329; % [pixel] Y-coordinate of principle
b        =  0.20;    % [m] width of baseline of stereo camera rig

frameSize = size(left.read(), [1 2]);
left.reset()

camIntrinsics = cameraIntrinsics(f, [u0, v0], frameSize);

rng(0)
i=0;
figure; figure; % make two empty figures

% matching
while left.hasdata()
    i = i+1;
    
    % for every frame
    L = left.read();
    R = right.read();    

    ptsL = detectORBFeatures(L);
    ptsR = detectORBFeatures(R);
    
    [orbfL, vptsL] = extractFeatures(L, ptsL);
    [orbfR, vptsR] = extractFeatures(R, ptsR);
    
    idxPairs = matchFeatures(orbfL, orbfR, "Unique", true);
    
    matchedPtsL = vptsL(idxPairs(:,1));
    matchedPtsR = vptsR(idxPairs(:,2));
    
    matchedfL = binaryFeatures(orbfL.Features(idxPairs(:,1), :));
        
    [Estereo, inlierIdx] = estimateEssentialMatrix(matchedPtsL, matchedPtsR, camIntrinsics, ...
     "MaxDistance", 0.2, "Confidence", 95);
    
    
    inlierPtsL = matchedPtsL(inlierIdx);
    inlierPtsR = matchedPtsR(inlierIdx);

    inlierfL = binaryFeatures(matchedfL.Features(inlierIdx, :));
    
    p1 = inlierPtsL.Location';
    p2 = inlierPtsR.Location';
    
    d = p1(1,:) - p2(1,:);
    
    d(d < 5*eps("single")) = eps("single"); % Avoid division by zero
    
    X = b * (p1(1,:) - u0) ./ d;
    Y = b * (p1(2,:) - v0) ./ d;
    Z = f * b ./ d;
    P = [X' Y' Z'];
      
    if i > 1  % if we have a previous frame

        % show the stereo matching in the current frame
        figure(1);
        showMatchedFeatures(L,R, inlierPtsL, inlierPtsR);
        title("Stereo matching");
        drawnow;
         
        if doVisodomFigures
            if i == 10
                rvcprint3('fig14_57a')
            end
        end

        % robustly match all the inliers from this frame with the inliers 
        % from previous frame - temporal match
        idxPairs = matchFeatures(inlierfLp, inlierfL, "Unique", true);

        matchedPtsLp = inlierPtsLp(idxPairs(:,1));
        matchedPtsL  = inlierPtsL(idxPairs(:,2));
    
        [Etemporal, inlierIdx] = estimateEssentialMatrix(matchedPtsL, matchedPtsLp, camIntrinsics, ...
            "MaxDistance", 0.2, "Confidence", 95);
        
        inlierPts1 = matchedPtsLp(inlierIdx);
        inlierPts2 = matchedPtsL(inlierIdx);

        % and plot them
        figure(2);
        showMatchedFeatures(L,Lp, inlierPts1, inlierPts2);
        title("Left frame temporal matching");
        drawnow

        if doVisodomFigures            
            if i == 10
                rvcprint3('fig14_57b')
            end
        end
        
        % Isolate P entries corresponding to inliers
        Psubset = Pp(idxPairs(:,1),:); % 1 for previous set of points P
        Psubset = Psubset(inlierIdx,:);

        % Set up and solve bundle adjustment problem. Use motion only
        % bundle adjustment which simply moves the camera while leaving the
        % points alone.
        absPose1 = rigid3d();
        [refinedPose, e] = bundleAdjustmentMotion(Psubset, inlierPts2, absPose1, ...
            camIntrinsics, 'PointsUndistorted', true); % 'Verbose', true
        tz(i-1) = refinedPose.Translation(3); % store the Z coordinate which is the camera displacement for the vehicle moving forward
        eout(i-1) = mean(e);
        
    end
    
    % keep images and features for next cycle
    inlierPtsLp = inlierPtsL;
    inlierfLp   = inlierfL;
    
    Pp = P;

    Lp = L;
    Rp = R;    

end

%% process the results

% time stamps
ts = load(fullfile(rvctoolboxroot,"examples","visodom","timestamps.dat"));
dts = diff(ts);

idxHighVal = dts > 0.06;

subplot(311)
plot(tz, '.-', 'MarkerSize', 15)
ylabel("Camera displacement (m)")
hold on
xdata = 1:250;
plot(tz(idxHighVal), 'x', 'MarkerSize', 15, "Xdata", xdata(idxHighVal))
legend("displacement", "missed video frame")
grid on

subplot(312)
plot(eout, '.-', 'MarkerSize', 15)
set(gca, 'YScale', 'log')
ylabel("Average error (pix)")
grid on

subplot(313)
plot(dts, '.', 'MarkerSize', 15)
ylim([0.04, 0.1]);
xlabel("Time step")
ylabel("\Delta T")
grid on

f = gcf;
f.Position = [2049 248 1672 1774];

if doVisodomFigures    
    rvcprint3("fig14_52");
end

end