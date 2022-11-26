%close all
clf
view(3)
R = rotmx(pi/2)
plottform(R)
rvcprint(subfig='a', thicken=2)

clf
view(3)
rotmx(pi/2) * rotmy(pi/2)
plottform(ans)
rvcprint(subfig='b', thicken=2)
