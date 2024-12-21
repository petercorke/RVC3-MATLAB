
% load simulation data into workspace

[TrueMotion,IMU] = imudata();

% do a naive integration of angular velocity to estimate orientation

orientation(1) = quaternion([1 0 0 0]);
for k=1:size(IMU.gyro,1)-1
   orientation(k+1) = orientation(k) * quaternion(IMU.gyro(k,:)*IMU.dt, 'rotvec');
end

% figure
% plot(IMU.t, dist(orientation, true.orientation), 'r', 'LineWidth', 2 );

%% do the ECF to better estimate orientation

kI = 0.2; kP = 1;

bias = zeros(size(IMU.gyro,1),3);
orientation_ECF(1) = quaternion([1 0 0 0]);
for k=1:size(IMU.gyro,1)-1
   invq = conj( orientation_ECF(k) );
   sigmaR = cross(IMU.accel(k,:), invq.rotatepoint(TrueMotion.g0)) + ...
            cross(IMU.magno(k,:), invq.rotatepoint(TrueMotion.B0));
   wp = IMU.gyro(k,:) - bias(k,:) + kP*sigmaR;
   orientation_ECF(k+1) = orientation_ECF(k) * quaternion(wp*IMU.dt, 'rotvec');
   bias(k+1,:) = bias(k,:) - kI*sigmaR*IMU.dt;
end


clf
subplot(211)
plot(IMU.t, dist(orientation, TrueMotion.orientation), 'r', 'LineWidth', 2 );
hold on
plot(IMU.t, dist(orientation_ECF, TrueMotion.orientation), 'b', 'LineWidth', 2 );
legend('standard', 'explicit comp. filter', 'Location', 'NorthWest')
grid on
xlabel('Time (s)')
ylabel('Orientation error (rad)')

subplot(212)
plot(IMU.t, bias, 'LineWidth', 2)
grid on
xlabel('Time (s)')
ylabel('Estimated gyro bias b (rad/s)')
legend('b_x', 'b_y', 'b_z', 'Location', 'NorthWest')

rvcprint