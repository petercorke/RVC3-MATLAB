close all
clear

a1 = 1; a2 = 1;
e = ETS3.Rz("q1") * ETS3.Ry("q2") * ...
   ETS3.Tz(a1) * ETS3.Ry("q3") * ETS3.Tz(a2) * ...
   ETS3.Rz("q4") * ETS3.Ry("q5") * ETS3.Rz("q6");

figure;
e.teach(deg2rad([4 29 54 0 54 -20]));

xlim([-1 3])
view(34.15, 23.175);

rvcprint("painters")
