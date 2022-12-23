close all; clear;
data = jsondecode(fileread("queensland.json"));

f = figure;
geobasemap colorterrain
hold on
for p = string(fieldnames(data.places))'
    geoplot(data.places.(p).lat, data.places.(p).lon, ".b", MarkerSize=20)
    if p == "MountIsa" || p == "Longreach"
        % Some manual alignment to avoid town name overlap
        text(data.places.(p).lat + 0.35, data.places.(p).lon + 0.1, p)
    else
        text(data.places.(p).lat, data.places.(p).lon + 0.25, p)
    end
end
geolimits([-28.6607  -14.6994], [136.9320  156.0042]);

% Set figure size, to there's a better proportion between 
% city names and surrounding land
f.Position = [0 0 880 750];

rvcprint("nogrid", format="jpg")