%CentralCamera.flowfield Optical flow
%
% C.flowfield(V) displays the optical flow pattern for a sparse grid
% of points when the camera has a spatial velocity V (6x1).
%
% See also QUIVER.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function flowfield(cam, vel)
    a = 50:100:1000;
    [U,V] = meshgrid(a, a);
    du=[]; dv=[];
    for i=1:size(U,2)                      
        for j=1:size(U,2)                      
            pdot = cam.visjac_p( [U(i,j) V(i,j)], 2 ) * vel(:);
            du(i,j) = pdot(1); dv(i,j) = pdot(2);
        end
    end

    quiver(U, V, du, dv, 0.4)
    axis equal
        axis([1 cam.npix(1) 1 cam.npix(2)]);

    set(gca, 'Ydir', 'reverse');
    xlabel('u (pixels)');
    ylabel('v (pixels)');
    grid

