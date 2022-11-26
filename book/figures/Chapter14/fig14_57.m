%% Visual odometry example
%   - stereo camera
%   - ICP between frames

% read images
if ~exist('left')
    left = iread('bridge-l/*.png', 'roi', [20 750; 20 440]);
    right = iread('bridge-r/*.png', 'roi', [20 750; 20 440]);
end

%%

f        =  985.939; % [pixel] focal length
u0       =  390.255; % [pixel] X-coordinate of principle
v0       =  242.329; % [pixel] Y-coordinate of principle
b        =  0.20;    % [m] width of baseline of stereo camera rig

cam = CentralCamera('focal', f, 'centre', [u0 v0], 'pixel', [1 1 ]);


clear T ebundle efund
randinit
% matching
for i=1:100
    L = left(:,:,i);
    R = right(:,:,i);
    
    % find corner features
    fl = icorner(L, 'nfeat', 400, 'patch', 7, 'suppress', 0);
    fr = icorner(R, 'nfeat', 400, 'patch', 7, 'suppress', 0);
    
    % robustly match left and right corner features
    % - stereo match
    [mstereo,Cs] = fl.match(fr);
    Fstereo = mstereo.ransac(@fmatrix, 1e-4, 'retry', 5)


    % keep the features and match objects for the inliers
    k = Cs(1,mstereo.inlierx);  % index of inlier features
    fl = fl(k);
    
    mstereo = mstereo.inlier;
    
    % triangulate 3D points
    p = mstereo.p;
    p1 = p(1:2,:); p2 = p(3:4,:);

    d = p1(1,:) - p2(1,:);
    X = b * (p1(1,:) - u0) ./ d;
    Y = b * (p1(2,:) - v0) ./ d;
    Z = f * b ./ d;
    P = [X; Y; Z];
    
    if i > 1
        % if we have a previous frame
        
        % display two sequential stereo pairs
        idisp([L R; Lp Rp], 'nogui');
        
        % show the stereo matching in the current frame
        mstereo.plot('y', 'offset', [0 size(L,2) 0 0])
        
        % robustly match all the inliers from this frame with the inliers from previous frame
        % - temporal match
        [mtemporal,Ct] = fl.match(flp);
        [Ftemporal,eFt] = mtemporal.ransac(@fmatrix, 1e-4, 'retry', 5);
        
        % and plot them
        mtemporal.inlier.plot('y', 'offset', [0 0 0 size(L,1)])
        
        if i == 10
            rvcprint('svg')
            break
        end
        
        % now create a bundle adjustment problem
        
        ba = BundleAdjust(cam);
        
        c1 = ba.add_camera( SE3(), 'fixed' );  % first camera at origin (prev frame)
        c2 = ba.add_camera( SE3() );  %  second camera initialized at origin (current frame)
        
        for ii=mtemporal.inlierx
            j = Ct(1,ii);   % index to current frame feature and landmark
            lm = ba.add_landmark(P(:,j));
            p = mtemporal(ii).p;
            ba.add_projection(c2, lm, p(1:2));  % current camera
            ba.add_projection(c1, lm, p(3:4));  % previous camera
        end
        
        % solve bundle adjustment, fix number of iterations
        [baf,e] = ba.optimize('iterations', 10);
        
        tz(i) = baf.getcamera(2).t(3);
        ebundle(i) = e;
        efund(i) = eFt;
    end
    
    % keep images and features for next cycle
    flp = fl;
    Lp = L;
    Rp = R;
    
    drawnow
end
