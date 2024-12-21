close all
clear

e = ETS2.Rz("q1") * ETS2.Tx(1);
figure;
e.teach(deg2rad(30))

rvcprint("painters")
