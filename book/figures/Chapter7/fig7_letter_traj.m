close all; clear;

abb = loadrobot("abbIrb1600", DataFormat="row");
aIK = analyticalInverseKinematics(abb);

if logical(exist("ikIRB1600","file"))
    abbIKFcn = @ikIRB1600;
else
    abbIKFcn = aIK.generateIKFunction("ikIRB1600");
end

load hershey

B = hershey{'B'};

p = [ 0.5*B.stroke; zeros(1,size(B.stroke,2))];
k = find(isnan(p(1,:)));
p(:,k) = p(:,k-1); p(3,k) = 0.2;

traj = mstraj(p(:,2:end)', [0.5 0.5 0.5], [], p(:,1)', 0.02, 0.2);

%% Subfigure (a) - Trajectory
figure;
plot3(traj(:,1), traj(:,2), traj(:,3))
hold on; plot3(p(1,:), p(2,:), p(3,:), 'rx', MarkerSize=10, LineWidth=1.5)
xlabel("x"); ylabel("y"); zlabel("z");

zlim([0, 0.2]);
view(-32.7, 34.8)

rvcprint("painters", subfig="_a", thicken=2)

%% Subfigure (b) - Robot executing motion
Tp = se3(trvec2tform([0.5 0 0.075])) * se3(eye(3), traj) * ...
    se3(oa2tform([0 1 0], [0 0 -1]));
qj = ikineTraj(abbIKFcn, Tp);

figure;
abb.show(qj(1,:));
hold on
plot3(traj(:,1) + 0.5, traj(:,2), traj(:,3), LineWidth=3)
abb.show(qj(170,:), FastUpdate=true, PreservePlot=false);

view(42.1113, 26.1767);
set(gca, "CameraViewAngle", 1.0824);
set(gca, "CameraPosition", [21.1992  -22.6272   15.3442]);
set(gca, "CameraTarget", [0.3523    0.4353    0.0626]);
camlight right

rvcprint("opengl", subfig="_b")

