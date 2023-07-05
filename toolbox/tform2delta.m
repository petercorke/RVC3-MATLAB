%tform2delta Convert SE(3) homogeneous transform to differential motion
%
% D = tform2delta(T0, T1) is the differential motion (6x1) corresponding to
% infinitessimal motion (in the T0 frame) from pose T0 to T1 which are homogeneous
% transformations (4x4) or SE3 objects.
%
% The vector D=(dRx, dRy, dRz, dx, dy, dz, ) represents infinitessimal translation
% and rotation, and is an approximation to the instantaneous spatial velocity
% multiplied by time step.
%
% D = tform2delta(T) as above but the motion is from the world frame to the SE3
% pose T.
%
% D = tform2delta(___, "fliptr") will flip the order of the
% translational and rotational components in D. When fliptr is set to true,
% the output vector will be D=(dRx, dRy, dRz, dx, dy, dz)
%
% Notes::
% - D is only an approximation to the motion T, and assumes
%   that T0 ~ T1 or T ~ eye(4,4).
% - Can be considered as an approximation to the effect of spatial velocity over a
%   a time interval, average spatial velocity multiplied by time.
%
% Reference::
% - Robotics, Vision & Control: Second Edition, P. Corke, Springer 2016; p67.
%
% See also delta2tform, delta2se.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat


function delta = tform2delta(T0, T1, options)
    arguments
        T0 
        T1 = []
        options.fliptr (1,1) logical = true
    end

    if isa(T0, 'se3')
        T0 = T0.tform;
    elseif ~istform(T0)
        error('RVC3:tform2delta:badarg', 'T0 should be SE(3) matrix or se3 instance');
    end
    
    if isempty(T1)
        % SYNTAX: tform2delta(T0, T1)
        T1 = T0;
        T0 = eye(4,4);
    else
        % SYNTAX: tform2delta(T0, T1)
        if isa(T1, 'se3')
            T1 = T1.tform;
        elseif ~istform(T1)
            error('RVC3:tform2delta:badarg', 'T1 should be SE(3) matrix or se3 instance');
        end
    end

    % compute incremental transformation from T0 to T1 in the T0 frame
    TD = inv(T0) * T1; %#ok<MINV>
    
    % build the delta vector
    translVec = tform2trvec(TD);
    rotVec = skew2vec(tform2rotm(TD) - eye(3,3));
    if options.fliptr
        % Put rotation first
        delta = [rotVec translVec];
    else
        % Put translation first
        delta = [translVec rotVec];
    end

% if nargin == 2
%     if isnumeric(varargin{1}) || isa(varargin{1}, "se3")
%         % SYNTAX: tform2delta(T0, T1)
%         B = varargin{1};
% 
%         T0 = T1;
%         if isa(B, 'se3')
%             T1 = B.tform;
%         elseif all(size(B) == 4)
%             T1 = B;
%         else
%             error('SMTB:tform2delta:badarg', 'T0 should be a homogeneous transformation');
%         end
%     else
%         % SYNTAX: tform2delta(T0, "fliptr")
%         flip = convertStringsToChars(varargin{1});
%         if strcmp(flip,'fliptr')
%             fliptr = true;
%         end
%     end
% end
% 
% if nargin == 3
%     % SYNTAX: tform2delta(T0, T1, "fliptr")
%     B = varargin{1};
%     T0 = T1;
%     if isa(B, 'se3')
%         T1 = B.tform;
%     elseif all(size(B) == 4)
%         T1 = B;
%     else
%         error('SMTB:tform2delta:badarg', 'T0 should be a homogeneous transformation');
%     end
% 
%     flip = convertStringsToChars(varargin{2});
%     if strcmp(flip,'fliptr')
%         fliptr = true;
%     end
% end
% 
% % compute incremental transformation from T0 to T1 in the T0 frame
% TD = inv(T0) * T1; %#ok<MINV>
% 
% % build the delta vector
% translVec = tform2trvec(TD);
% rotVec = skew2vec(tform2rotm(TD) - eye(3,3));
% if fliptr
%     % Put rotation first
%     delta = [rotVec translVec];
% else
%     % Put translation first
%     delta = [translVec rotVec];
% end

%    R0 = tform2rotm(T0); R1 = tform2rotm(T1);
%    % in world frame
%    %[th,vec] = tr2angvec(R1*R0');
%    dR = skew2vec(R1*R0');
%    %delta = [ (T1(1:3,4)-T0(1:3,4)); th*vec' ];
%    delta = [ (T1(1:3,4)-T0(1:3,4)); dR];

% same as above but more complex
%    delta = [	T1(1:3,4)-T0(1:3,4);
%        0.5*(	cross(T0(1:3,1), T1(1:3,1)) + ...
%            cross(T0(1:3,2), T1(1:3,2)) + ...
%            cross(T0(1:3,3), T1(1:3,3)) ...
%        )];
end

