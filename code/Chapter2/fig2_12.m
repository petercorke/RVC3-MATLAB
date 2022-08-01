%close all
clf

hold on
TA = trvec2tform2d([1,2]) * tformr2d(30, 'deg')
plottform2d(TA, frame="A", color="b");

T0 = trvec2tform2d([0,0]);
plottform2d(T0, frame="0", color="k");  % reference frame

TB = trvec2tform2d([2,1])
plottform2d(TB, frame="B", color="r");

TAB = TA * TB
plottform2d(TAB, frame="AB", color="g");

TBA = TB * TA;
plottform2d(TBA, frame="BA", color="c");
P = [3 ; 2 ];

plot_point(P, 'label', ' P', 'solid', 'ko');

axis equal

axis([0 5 0 5])
rvcprint(thicken=2)