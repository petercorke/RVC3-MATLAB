%delta2se Convert differential motion  to an se3 object
%
% T = delta2se(D) is an se3 object representing differential translation
% and rotation. The vector D=(dRx, dRy, dRz, dx, dy, dz) represents an
% infinitessimal motion, and is an approximation to the spatial velocity
% multiplied by time.
%
% T = delta2tform(D, fliptr=false) will flip the expected order of the
% translational and rotational components in D. When fliptr is set to true,
% the input vector D is expected as D=(dx, dy, dz, dRx, dRy, dRz)
%
% See also tform2delta.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function delta = delta2se(d, varargin)

    opt.fliptr = 1;
    % Parse name-value pairs (if they are passed)
    opt = tb_optparse(opt, varargin);
    
    d = d(:);
    
    if opt.fliptr
        delta = eye(4,4) + [vec2skew(d(1:3)) d(4:6); 0 0 0 0];
    else
        delta = eye(4,4) + [vec2skew(d(4:6)) d(1:3); 0 0 0 0];
    end
    
    delta = se3(delta);

end
