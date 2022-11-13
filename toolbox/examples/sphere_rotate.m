function sphrot = sphere_rotate(sph, T, varargin)

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

%     % if only a hemisphere pad the other hemisphere with grey
%     if nargin > 2
%         if strcmp(varargin(1), 'north')
%             sph = [sph; 0.3*ones(size(sph))];
%         elseif strcmp(varargin(1), 'south')
%             sph = [0.3*ones(size(sph)); sph];
%         end
%     end

    [nr,nc] = size(sph);

    % theta spans [0, pi]
    theta_range = linspace(0, pi, nr);

    % phi spans [-pi, pi]
    phi_range = linspace(-pi, pi, nc);

    % build the plaid matrices
    [Phi,Theta] = meshgrid(phi_range, theta_range);

    % convert the spherical coordinates to Cartesian
    x = sin(Theta) .* cos(Phi);
    y = sin(Theta) .* sin(Phi);
    z = cos(Theta);

    % convert to 3xN format
    p = [x(:)' ; y(:)'; z(:)'];

    % transform the points
    p = (homtrans(T.tform, p'))';

    % convert back to Cartesian coordinate matrices
    x = reshape(p(1,:), size(x));
    y = reshape(p(2,:), size(x));
    z = reshape(p(3,:), size(x));

    % convert back to spherical coordinates
%     r = sqrt(x.^2 + y.^2);
% 
%     asin is multiple valued over the interval [0,pi]
%     nTheta = asin(r);
%     nTheta(nr2:end,:) = pi-nTheta(nr2:end,:);
% 
%     nPhi = atan2(y, x);

nTheta = acos(z);
nPhi = atan2(y, x);
    
%     % phi long
%     % theta colat
%     nPhi = Phi+0.5;
%     nTheta = Theta ;
%     
%     nPhi = angdiff(nPhi);
%     nTheta = mod(nTheta, pi);

    % warp the image
    sphrot = interp2(Phi, Theta, sph, nPhi, nTheta);
