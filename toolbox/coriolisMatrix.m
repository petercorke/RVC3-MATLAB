function C = coriolisMatrix(robot, q, qd)
%coriolisMatrix Calculate Coriolis matrix
%
% C = coriolisMatrix(ROBOT, Q, QD) is the Coriolis/centripetal matrix (NxN)
% for the rigidBodyTree ROBOT in configuration Q and velocity QD, where N
% is the number of joints.  The product C*QD is the vector of joint
% force/torque due to velocity coupling.  The diagonal elements are due to
% centripetal effects and the off-diagonal elements are due to Coriolis
% effects.  This matrix is also known as the velocity coupling matrix,
% since it describes the disturbance forces on any joint due to velocity of
% all other joints.
%
% Notes::
% - Computationally slow, involves N^2/2 invocations of inverseDynamics.
%
% See also rigidBodyTree/inverseDynamics.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

N = length(robot.homeConfiguration);

assert(length(q) == N, 'RTB:coriolis:badarg', 'q must have %d elements', N)
assert(length(qd) == N, 'RTB:coriolis:badarg', 'qd must have %d elements', N)

% Always convert to row vectors
q = q(:)';
qd = qd(:)';

% Create a robot copy with no gravity and row vectors as data format
robot2 = robot.copy;
robot2.Gravity = [0 0 0];
robot2.DataFormat = "row";

C = zeros(N,N);
Csq = zeros(N,N);


% find the torques that depend on a single finite joint speed,
% these are due to the squared (centripetal) terms
%
%  set QD = [1 0 0 ...] then resulting torque is due to qd_1^2
for j=1:N
    QD = zeros(1,N);
    QD(j) = 1;
    tau = robot2.inverseDynamics(q, QD, zeros(size(q)));
    Csq(:,j) = Csq(:,j) + tau.';
end

% find the torques that depend on a pair of finite joint speeds,
% these are due to the product (Coridolis) terms
%  set QD = [1 1 0 ...] then resulting torque is due to
%    qd_1 qd_2 + qd_1^2 + qd_2^2
for j=1:N
    for k=j+1:N
        % find a product term  qd_j * qd_k
        QD = zeros(1,N);
        QD(j) = 1;
        QD(k) = 1;
        tau = robot2.inverseDynamics(q, QD, zeros(size(q)));
        C(:,k) = C(:,k) + (tau.' - Csq(:,k) - Csq(:,j)) * qd(j)/2;
        C(:,j) = C(:,j) + (tau.' - Csq(:,k) - Csq(:,j)) * qd(k)/2;
    end
end

C = C + Csq * diag(qd);
end