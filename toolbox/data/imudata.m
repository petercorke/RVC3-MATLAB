% Simulation motion of a tumbling body with inertial sensors attached.
%
% imudata is the simulated motion and displays orientation and sensor outputs
% true, imu = imudata as above but returns the true orientation of the body and simulated sensor
%outputs:
%
%   true.t  simulation time (
%   true.attidue is an array (N) of quaternions representing orientation
%   true.omega is a 3-column matrix of angular velocity
%
%   imu.t simulation time (Nx1)
%   imu.gyro  simulated magnotometer data (Nx3)
%   imu.accel simulated magnotometer data (Nx3)
%   imu.magno simulated magnotometer data (Nx3)
%
% Note we could implement this functionality using the native imuSensor
% system object, which supports more complex noise/error models

%
% g0 unit vector in direction of gravity in inertial frame
% m0 unit vector in direction of magnetic field in inertial frame
%
% qtrue true orientation as quaternion (1xN)

%% vectorial sensor data


function [truth,imu] = imudata(visualize)

    % TODO: add command line handler
    %  add options for dt, tf

    if nargin == 0
        visualize = false;
    end

    %% IMU parameters
    
    % accelerometer
    g0 = [0 0 1]; % straight down in units of g
    gbias = 0.02*[2 -2 2]';  % bias 2% of norm

    % magnetometer, use N E U data in nT  for Brisbane (change to your own
    % location)
    B0 = normalize([28067.5, -5439.4, 44800.5]*1e-9, norm=1);
    mbias = 0.02*[-1 -1 2]';   % bias 2% of norm

    % gyro
    wbias = 0.05*[-1 2 -1]'; % bias 5% of max

    %% simulation

    %parameters
    dt = 0.05;
    tf = 20;
    w0 = 0.2*[1 2 2]'; % initial condition

    % make an asymmetric mass that will tumble
    J = diag([2 4 3]);
    J(1,2) = -1;
    J(2,1) = -1;
    J(1,3) = -2;
    J(3,1) = -2;
    %eig(J)

    % Solve Euler's rotational dynamics to get omega over time
    [t,omega] = ode45( @(t,w) -inv(J)*(cross(w, J*w)), [0:dt:tf], w0);
    % one row per timestep

    % Compute simulated sensor readings and true orientation
    orientation(1) = quaternion([1 0 0 0]);  % initial orientation
    accel = zeros(size(omega,1),3);
    magno = zeros(size(omega,1),3);

    for k=1:size(omega,1)-1
            iq = conj(orientation(k));
            accel(k,:) = iq.rotatepoint(g0)' + gbias;  % sensor reading in body frame
            magno(k,:) = iq.rotatepoint(B0)' + mbias;  % sensor reading
            orientation(k+1) = orientation(k) * quaternion(omega(k,:)*dt, 'rotvec');
    end

    % add bias to measured 
    gyro = omega + wbias';

    % optionally plot the orientation
    if nargout == 0
        figure
        plot(t, euler(orientation, 'zyx', 'frame'))
        title('orientation (truth)')
        xlabel('Time (seconds)')
        
        ylabel('Euler angles (rad)')
        legend({'\phi', '\theta', '\psi'})
        grid
        
        figure
        plot(t, gyro)
        title('Gyroscope measurement')
        xlabel('Time (seconds)')
        
        ylabel('Angular velocity (rad/s)')
        legend({'\omega^#_x', '\omega^#_y', '\omega^#_z'})
        grid
        
        figure
        plot(t, accel)
        title('Accelerometer measurement')
        xlabel('Time (seconds)')
        ylabel('Acceleration (g)')
        legend({'a^#_x', 'a^#_y', 'a^#_z'})
        grid

    elseif nargout >= 1
        truth.omega = omega;
        truth.orientation = orientation;
        truth.t = t';
        truth.dt = dt;
        truth.g0 = g0;
        truth.B0 = B0;
        if nargout == 2
            imu.t = t';
            imu.dt = dt;
            imu.gyro = gyro;
            imu.magno = magno;
            imu.accel = accel;
        end
    end