clf

hold on
C = [3 2];
plotcircle(C, sqrt(2), 'k:')
plotcircle([0, 0], sqrt(13), 'k--')

T0 = trvec2tform2d([0,0]);
plottform2d(T0, frame="0", color="k");
TX = trvec2tform2d([2,3]);
plottform2d(TX, frame="X", color="b");

TR = tformr2d(2);

plottform2d(TR * TX, framelabel="RX", color="g");
plottform2d(TX * TR, framelabel="XR", color="g");


plotpoint(C, "ko", label="C", MarkerFaceColor="k");

TC = trvec2tform2d(C) * TR * trvec2tform2d(-C)

plottform2d(TC * TX, framelabel="XC", color="r");


axis equal
axis([-5 4 -1 5]);

rvcprint(thicken=2)