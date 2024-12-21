close all; clear;

abb = loadrobot("abbIrb1600", DataFormat="row");
aIK = analyticalInverseKinematics(abb);

if logical(exist("ikIRB1600","file"))
    abbIKFcn = @ikIRB1600;
else
    abbIKFcn = aIK.generateIKFunction("ikIRB1600");
end

%% Subfigure (a) - Trajectory through wrist singularity (analytical IK)

qsing = [0, pi/4, 0, 0.1, 0, 0.4];
TG = se3(abb.getTransform(qsing, "tool0"));
TE1 = se3(trvec2tform([0 -0.3 0])) * TG;
TE2 = se3(trvec2tform([0 0.3 0])) * TG;

t = 0:0.02:2;
[s,sd,sdd] = minjerkpolytraj([0 1],[0 2],numel(t));
T = transformtraj(TE1.tform,TE2.tform,[0 2],t, ...
    TimeScaling=[s;sd;sdd]);
Ts = se3(T);

qj = ikineTraj(abbIKFcn, Ts);

figure;
xplot(t, qj, unwrap=true);

rvcprint("painters", subfig="_a", thicken=2, figy=150)

%% Subfigure (b) - Trajectory through wrist singularity (numerical IK)

qjn = ikineTrajNum(abb, Ts, "tool0");

figure;
xplot(t, qjn, unwrap=true);

rvcprint("painters", subfig="_b", thicken=2, figy=150)

%% Subfigure (c) - Joint-space trajectory
sol1 = abbIKFcn(TE1.tform);
sol2 = abbIKFcn(TE2.tform);
waypts = [sol1(1,:)', sol2(1,:)'];
qjp = quinticpolytraj(waypts, [0 2], t);

figure;
xplot(t, qjp');
l = legend;
l.Location = "best";
rvcprint("painters", subfig="_c", thicken=2, figy=150)

%% Subfigure (d) - Manipulability

mc = manipulability(abb, qj, "tool0");
mj = manipulability(abb, qjp', "tool0");

figure
plot(t, [mc mj]);
ylabel("Manipulability")
xlabel("Time (s)")
l = legend("Analytical IK", "Numerical IK", Location="SouthEast");
set(l, FontSize=12)

rvcprint("painters", subfig="_d", thicken=2);