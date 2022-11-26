close all; clear;

planar2 = ETS2.Rz("q1") * ETS2.Tx(1) * ETS2.Rz("q2") * ETS2.Tx(1);
planar2.teach(deg2rad([30 40]), "vellipse");

rvcprint("painters")