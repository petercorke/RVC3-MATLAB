function chamfer_match
    
    % Things to try:
    %   - modify to search for just position and orientation, you set the scale
    %   - vary the number of particles in the swarm
    %   - try different optimizers
    %   - implement truncated chamfer match
    %   - extend to directional chamfer match, use the IPT implementation of
    %     distance transform which optionally returns the closest set pixel
    %   - test on an image of a real square

    % This example requires Global Optimization Toolbox from MathWorks
	
	% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 	

    
    %% create the outline of a rotated square
    im = zeros(256);
    im = insertShape(im, "FilledRectangle", [64, 64, 128, 128], Color='w', Opacity=1);
    im = imrotate(im(:,:,1), 15, "crop");
    edges = edge(im, "canny");
    imshow(edges)
    
    %% compute the distance transform and display it
    dx = bwdist(edges);
    imshow(dx, [], InitialMagnification = 300);
    colorbar;

    %% create the model
    % vertices of a square centered at origin with side length of 1
    corners = [-1 -1; 1 -1; 1 1; -1 1; -1 -1]'/2 ;

    
    %% minimize!
    
    % we use particle swarm since it provides constrained minimization and
    % copes well with local minima
    options = optimoptions('particleswarm', 'OutputFcns', @display)
  
    % state vector is: x, y, theta, scale
    [xf,ef] = particleswarm( @cost, 4,  ...
        [10 10 -pi/2 50], ...   % lower bounds
        [200 200 pi/2 200], ... % upper bounds
        options )
    
    %% nested functions to compute cost and display progress
    %   these have access to variables in this scope such as dx and corners
    
    function c = cost(x)
        % compute cost for this particle
        %  x = (x y theta scale)
        
        % compute an SE2 transform
        T = se2(tform2d(x(1:3)));
        
        % scale the corners and then apply SE2 transform
        p = T.transform(x(4)*corners, IsCol=true);
        
        % check if all the vertices are within the image
        c = [p(:)-1; 256-p(:)];
        if all(c>0)
            % vertices are inside
            
            dp = iprofile(dx, p);  % compute cost at each point along all line segments
            c = sum( dp );  % compute total cost (scalar)
            c = double(c);  % ensure result is a double
            c = c / x(4);   % normalize cost with respect to size
        else
            % vertices outside, penalize the particle
            c = Inf;
        end
    end
    
    function stop = display(optimvalues, ~)
        % display the current state of the minimziation, called after each
        % particleswarm iteration
        
        x = optimvalues.bestx;  % get current best estimate of x

        T = se2(tform2d(x(1:3)));  % compute SE2 transform
        p = T.transform(x(4)*corners, IsCol=true);  % compute vertices of square
        
        % show the distance field and overlay the current square estimate
        idisp(dx, 'plain');
        hold on
        plot2(p', 'r');
        drawnow
        
        stop = false;  % don't stop
    end 
end


