%CentralCamera.estpose Estimate pose from object model and camera view
%
% T = C.estpose(XYZ, UV) is an estimate of the pose of the object defined by
% coordinates XYZ (3xN) in its own coordinate frame.  UV (2xN) are the 
% corresponding image plane coordinates.
%
% Reference::
% "EPnP: An accurate O(n) solution to the PnP problem",
% V. Lepetit, F. Moreno-Noguer, and P. Fua,
% Int. Journal on Computer Vision,
% vol. 81, pp. 155-166, Feb. 2009.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function T = estpose(c, XYZ, uv)

    [R, t] = efficient_pnp(XYZ, uv, c.K);

    T = se3(R, t');
