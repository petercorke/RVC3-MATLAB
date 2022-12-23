close all
clear

f = figure;
walking(niterations=57)

view(133.0846,16.5698)

% Remove the corner coordinate system
ccfaxs = findall(gcf, 'type', 'axes', 'tag', 'CornerCoordinateFrame');
for k = 1:length(ccfaxs)
    delete(ccfaxs(k));
end

% Scale figure size a bit to make sure that Z axis label is not cut off
f.Position = [973   918   587   420];

rvcprint("opengl")