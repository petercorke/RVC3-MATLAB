function qj = ikineTrajNum(robot, Ts, ee, varargin)

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

% Determine end effector automatically, if not provided by the user
if nargin < 3 || isempty(ee)
    ee = robot.Bodies{end}.Name;
end

opt.weights = ones(1,6);
opt = tb_optparse(opt, varargin);

ik = inverseKinematics(RigidBodyTree=robot);

qsol = ik(ee, Ts(1).tform, opt.weights, robot.homeConfiguration);
qj = zeros(length(Ts), size(qsol,2));
qj(1,:) = qsol(1,:);
for i = 2:length(Ts)
    qsol = ik(ee, Ts(i).tform, opt.weights, qj(i-1,:));
    qj(i,:) = qsol(1,:);
end

end