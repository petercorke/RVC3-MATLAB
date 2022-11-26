close all
clear

walking(niterations=57)

view(133.0846,16.5698)

% Remove the corner coordinate system
ccfaxs = findall(gcf, 'type', 'axes', 'tag', 'CornerCoordinateFrame');
for k = 1:length(ccfaxs)
    delete(ccfaxs(k));
end

rvcprint("opengl")